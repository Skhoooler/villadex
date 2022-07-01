import 'dart:async';
import 'dart:typed_data';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:villadex/model/event_model.dart';

import '../../../style/colors.dart';
import '../../../style/text_styles.dart';

import '../../../Util/nav_bar.dart';
import '../../../model/earning_model.dart';
import '../../../model/expenditure_model.dart';
import '../../../model/property_model.dart';
import '../../../model/category_model.dart' as vd;
import '../../../util/analysis.dart';

class ReportGenerator extends StatefulWidget {
  final Property property;
  final DateTime startDate;
  final DateTime endDate;
  final Map<String, dynamic> options;

  const ReportGenerator({
    required this.property,
    required this.startDate,
    required this.endDate,
    required this.options,
    Key? key,
  }) : super(key: key);

  @override
  State<ReportGenerator> createState() => _ReportGeneratorState();
}

class _ReportGeneratorState extends State<ReportGenerator> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Body
      // todo: Add a back arrow to the previous page
      body: Container(
        //width: MediaQuery.of(context).size.width * .35,
        //height: MediaQuery.of(context).size.height * .7,
        color: VilladexColors().background,
        child: PdfPreview(
          build: (format) => _generateReport(),
        ),
      ),

      /// Bottom Nav Bar
      bottomNavigationBar: const NavBar(),
    );
  }

  ///////////////////////////////////////////////////////////////////////
  /// Generates a PDF file
  ///////////////////////////////////////////////////////////////////////
  Future<Uint8List> _generateReport() async {
    /// Create a VilladexAnalysis object
    VilladexAnalysis analyzer = await VilladexAnalysis.create(widget.property);

    /// Set up colors for the PDF
    PdfColor pdfPrimary = PdfColor.fromInt(VilladexColors().primary.value);
    PdfColor pdfOddRow = PdfColor.fromInt(VilladexColors().oddRow.value);
    PdfColor pdfWhiteText = PdfColor.fromInt(VilladexColors().background.value);

    /// Set up values
    String startDate = DateFormat.yMMMMd('en_US').format(widget.startDate);
    String endDate = DateFormat.yMMMMd('en_US').format(widget.endDate);

    double gross =
        await analyzer.getGrossByInterval(widget.startDate, widget.endDate);
    double net =
        await analyzer.getNetByInterval(widget.startDate, widget.endDate);

    /// Create Graphs
    // Get income data
    List<double> income = await analyzer.getIncomeByInterval(
        widget.startDate, widget.endDate,
        interval: widget.options["Interval"]);

    // Set up the Axis for the graph
    List<int> xAxis = [
      1,
      income.length,
      (income.length * .5).floor(),
      (income.length * .75).floor(),
      (income.length * .25).floor(),
    ];

    List<int> yAxis = [
      // Give some spacing between the graph and the bottom
      income.reduce(min) < 0 ? 0 : (income.reduce(min) * .5).floor(),
      income[0].floor(),
      income.reduce(max).floor(),
      income.reduce(min).floor(),
      ((income.reduce(max) + income.reduce(min)) / 2).floor(),
    ];

    // Sort the axis into ascending order (least to greatest)
    xAxis.sort((a, b) => a.compareTo(b));
    yAxis.sort((a, b) => a.compareTo(b));

    // Profits
    final profitsChart = pw.Chart(
        title: pw.Text("Income from $startDate to $endDate",
            style: VilladexTextStyles().getPDFText()),
        //right: pw.ChartLegend(),
        bottom: pw.Text(
          VilladexAnalysis.getIntervalName(widget.options["Interval"]),
          style: VilladexTextStyles().getPDFText(),
        ),
        grid: pw.CartesianGrid(
          //todo: Make this programmatic
          xAxis: pw.FixedAxis(
            xAxis,
            divisions: true,
          ),

          yAxis: pw.FixedAxis(
            yAxis,
            divisions: true,
          ),
        ),
        datasets: [
          pw.LineDataSet(
              legend: 'Profits',
              drawSurface: false,
              isCurved: true,
              drawPoints: false,
              pointSize: 6,
              color: pdfPrimary,
              data: List<pw.PointChartValue>.generate(
                  income.length,
                  (index) =>
                      pw.PointChartValue(index.toDouble() + 1, income[index])))
        ]);

    ////////////////////////////////////////////////////////////////////
    /// CREATE PDF REPORT
    ////////////////////////////////////////////////////////////////////
    /// Create base report
    final report = pw.Document(
        title:
            "${widget.property.name} report $startDate to ${DateFormat.yMMMMd('en_US').format(widget.endDate)}",
        author: "Villadex",
        compress: true,
        version: PdfVersion.pdf_1_5,
        pageMode: PdfPageMode.thumbs);

    /// Title/Profits
    report.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            children: [
              getTitle(),
              if (widget.options["Profits"])
                getProfit(gross, net, profitsChart),
            ],
          );
        },
      ),
    );

    /// Earnings
    if (widget.options["Earnings"]) {
      report.addPage(
        pw.MultiPage(
          build: (context) {
            return [
              getEarnings(analyzer, pdfPrimary, pdfOddRow),
            ];
          },
        ),
      );
    }

    /// Expenditures
    if (widget.options["Expenditures"]) {
      report.addPage(
        pw.MultiPage(
          build: (context) {
            return [
              getExpenditures(analyzer, pdfPrimary, pdfOddRow),
            ];
          },
        ),
      );
    }

    /// Events
    if (widget.options["Events"]) {
      report.addPage(
        pw.MultiPage(
          build: (context) {
            return [
              getEvents(),
            ];
          },
        ),
      );
    }

    /// Associates
    if (widget.options["Associates"]) {
      report.addPage(
        pw.MultiPage(
          build: (context) {
            return [
              getAssociates(),
            ];
          },
        ),
      );
    }
    return report.save();
  }

  ////////////////////////////////////////////////////////////////////
  /// PDF COMPONENTS
  ////////////////////////////////////////////////////////////////////
  /// Returns profits
  pw.Widget getProfit(double gross, double net, pw.Chart profitsChart) {
    PdfColor pdfMoney = PdfColor.fromInt(VilladexColors().money.value);
    PdfColor pdfError = PdfColor.fromInt(VilladexColors().error.value);
    return pw.Column(children: [
      ///Profits
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.start,
        children: [
          pw.Text("Profits", style: VilladexTextStyles().getPDFHeading1()),
        ],
      ),

      pw.SizedBox(height: 20),

      pw.Row(children: [
        /// Data
        pw.Expanded(
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              // Gross Profit
              pw.Text("Gross Profit", style: VilladexTextStyles().getPDFText()),
              pw.Text(
                gross > 0
                    ? "\$${gross.toStringAsFixed(2)}"
                    : "-\$${(gross * -1).toStringAsFixed(2)}",
                style: gross > 0
                    ? VilladexTextStyles().getPDFText().copyWith(
                          color: pdfMoney,
                        )
                    : VilladexTextStyles().getPDFText().copyWith(
                          color: pdfError,
                        ),
              ),

              pw.SizedBox(height: 10),

              // Net Profits
              pw.Text(
                "Net Profit",
                style: VilladexTextStyles().getPDFText(),
              ),
              pw.Text(
                net > 0
                    ? "\$${net.toStringAsFixed(2)}"
                    : "-\$${(net * -1).toStringAsFixed(2)}",
                style: net > 0
                    ? VilladexTextStyles().getPDFText().copyWith(
                          color: pdfMoney,
                        )
                    : VilladexTextStyles().getPDFText().copyWith(
                          color: pdfError,
                        ),
              ),

              pw.SizedBox(height: 10),
            ],
          ),
        ),

        /// Graph
        pw.Expanded(flex: 2, child: profitsChart),
      ]),
    ]);
  }

  /// Returns Events
  pw.Widget getEvents() {
    const headers = ["Name", "Date", "Address"];

    return pw.Column(children: [pw.Text("Events")]);
  }

  /// Returns Associates
  pw.Widget getAssociates() {
    const headers = ["Name", "Date", "Address"];

    return pw.Column(children: [pw.Text("Associates")]);
  }

  /// Returns Earnings
  pw.Widget getEarnings(
      VilladexAnalysis analyzer, PdfColor primary, PdfColor oddRow) {
    const earningHeaders = [
      'Name',
      'Date',
      'Category',
      'Amount',
    ];

    List<_EarningDataPoint> earningData = analyzer.earnings
        .map((item) => _EarningDataPoint(
            earning: item ??
                Earning(
                    name: "",
                    earningDate: DateTime.now(),
                    category: vd.Category(name: ""),
                    amount: 0,
                    propertyKey: widget.property.key)))
        .toList();

    return pw.Column(
      children: [
        /// Earnings
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          children: [
            pw.Text("Earnings", style: VilladexTextStyles().getPDFHeading1()),
          ],
        ),

        // Spacing
        pw.SizedBox(height: 15),

        // Table
        pw.Table.fromTextArray(
          // Decoration
          headerDecoration: pw.BoxDecoration(
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
            color: primary, //VilladexColors().pdfPrimary,
          ),

          oddRowDecoration: pw.BoxDecoration(
            color: oddRow, //VilladexColors().pdfOddRow,
          ),

          cellAlignments: {
            0: pw.Alignment.centerLeft,
            1: pw.Alignment.centerLeft,
            2: pw.Alignment.centerLeft,
            3: pw.Alignment.centerLeft,
          },

          /// Get Headers
          headers: List<String>.generate(
              earningHeaders.length, (col) => earningHeaders[col]),

          /// Get Data
          data: List<List<String>>.generate(
            earningData.length,
            (row) => List<String>.generate(
                earningHeaders.length, (col) => earningData[row].getIndex(col)),
          ),
        ),

        pw.SizedBox(height: 20),
      ],
    );
  }

  /// Returns Expenditures
  pw.Widget getExpenditures(
      VilladexAnalysis analyzer, PdfColor primary, PdfColor oddRow) {
    /// Table Headers
    const expenditureHeaders = [
      'Name',
      'Date',
      'Category',
      'Price',
      'Number',
      'Total',
    ];

    /// Create data points
    List<_ExpenditureDataPoint> expenditureData = analyzer.expenditures
        .map((item) => _ExpenditureDataPoint(
            expenditure: item ??
                Expenditure(
                    name: "",
                    expenditureDate: DateTime.now(),
                    category: vd.Category(name: ""),
                    amount: 0,
                    numUnits: 0,
                    propertyKey: widget.property.key)))
        .toList();

    return pw.Column(
      children: [
        /// Expenditures
        // Heading
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          children: [
            pw.Text("Expenditures",
                style: VilladexTextStyles().getPDFHeading1()),
          ],
        ),

        // Spacing
        pw.SizedBox(height: 15),

        // Table
        pw.Table.fromTextArray(
          // Decoration
          headerDecoration: pw.BoxDecoration(
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
            color: primary, //VilladexColors().pdfPrimary,
          ),

          oddRowDecoration: pw.BoxDecoration(
            color: oddRow, //VilladexColors().pdfOddRow,
          ),

          cellAlignments: {
            0: pw.Alignment.centerLeft,
            1: pw.Alignment.center,
            2: pw.Alignment.centerLeft,
            3: pw.Alignment.centerLeft,
            4: pw.Alignment.center,
            5: pw.Alignment.centerLeft,
          },

          /// Get Headers
          headers: List<String>.generate(
              expenditureHeaders.length, (col) => expenditureHeaders[col]),

          /// Get Data
          data: List<List<String>>.generate(
            expenditureData.length,
            (row) => List<String>.generate(expenditureHeaders.length,
                (col) => expenditureData[row].getIndex(col)),
          ),
        ),

        pw.SizedBox(height: 20),
      ],
    );
  }

  /// Returns the title of the pdf
  pw.Widget getTitle() {
    return pw.Column(
      children: [
        /// Title
        pw.SizedBox(
          width: double.infinity,
          child: pw.FittedBox(
            child: pw.Center(
              child: pw.Text(
                "${widget.property.name} report ${DateFormat.yMMMMd('en_US').format(widget.startDate)} to ${DateFormat.yMMMMd('en_US').format(widget.endDate)}",
                style: VilladexTextStyles().getPDFTitle(),
                overflow: pw.TextOverflow.visible,
                maxLines: 2,
              ),
            ),
          ),
        ),

        pw.SizedBox(height: 10),

        /// Owner
        pw.Center(
          child: pw.Text(
            "${widget.property.owner}",
            style: VilladexTextStyles().getPDFSubtitle(),
          ),
        ),

        /// Address
        // Street
        pw.Center(
          child: pw.Text(
            "${widget.property.address.street1} ${widget.property.address.street2}",
            style: VilladexTextStyles().getPDFSubtitle(),
          ),
        ),

        // City, state, zip
        pw.Center(
          child: pw.Text(
            "${widget.property.address.city}, ${widget.property.address.state} ${widget.property.address.zip}",
            style: VilladexTextStyles().getPDFSubtitle(),
          ),
        ),

        pw.Center(
          child: pw.Text(
            widget.property.address.country,
            style: VilladexTextStyles().getPDFSubtitle(),
          ),
        ),

        pw.SizedBox(height: 20),
      ],
    );
  }
}

class _EventDataPoint {
  _EventDataPoint({required Event event})
      : name = event.name,
        address = event.address?.fullAddress ?? "",
        date = DateFormat('yMd').format(event.date);

  final String name;
  final String address;
  final String date;

  String getIndex(int index) {
    switch (index) {
      case 0:
        return name;
      case 1:
        return date;
      case 2:
        return address;
    }
    return '';
  }
}

class _EarningDataPoint {
  _EarningDataPoint({required Earning earning})
      : name = earning.name,
        category = earning.category?.name ?? "",
        date = DateFormat('yMd').format(earning.earningDate),
        amount = "\$${earning.amount.toStringAsFixed(2)}",
        rawData = earning;

  final String name;
  final String category;
  final String date;
  final String amount;
  final Earning rawData;

  String getIndex(int index) {
    switch (index) {
      case 0:
        return name;
      case 1:
        return date;
      case 2:
        return category;
      case 3:
        return amount;
    }
    return '';
  }
}

class _ExpenditureDataPoint {
  _ExpenditureDataPoint({required Expenditure expenditure})
      : name = expenditure.name,
        category = expenditure.category.name,
        date = DateFormat('yMd').format(expenditure.expenditureDate),
        price = "\$${expenditure.amount.toStringAsFixed(2)}",
        number = expenditure.numUnits.toString(),
        total = "\$${expenditure.total}",
        rawData = expenditure;

  final String name;
  final String category;
  final String date;
  final String price;
  final String number;
  final String total;
  final Expenditure rawData;

  String getIndex(int index) {
    switch (index) {
      case 0:
        return name;
      case 1:
        return date;
      case 2:
        return category;
      case 3:
        return price;
      case 4:
        return number;
      case 5:
        return total;
    }
    return '';
  }
}
