import 'dart:async';
import 'dart:ffi';
import 'dart:typed_data';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

import '../../../style/colors.dart';
import '../../../style/text_styles.dart';

import '../../../Util/nav_bar.dart';
import '../../../model/earning_model.dart';
import '../../../model/expenditure_model.dart';
import '../../../model/property_model.dart';
import '../../../model/category_model.dart' as vd;
import 'generate_report_options.dart';

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
    /// Set up colors for the PDF
    PdfColor pdfPrimary = PdfColor.fromInt(VilladexColors().primary.value);
    PdfColor pdfOddRow = PdfColor.fromInt(VilladexColors().oddRow.value);
    PdfColor pdfWhiteText = PdfColor.fromInt(VilladexColors().background.value);

    String startDate = DateFormat.yMMMMd('en_US').format(widget.startDate);
    String endDate = DateFormat.yMMMMd('en_US').format(widget.endDate);

    /// Create Headers for Tables
    const expenditureHeaders = [
      'Name',
      'Date',
      'Category',
      'Price',
      'Number',
      'Total',
    ];

    const earningHeaders = [
      'Name',
      'Date',
      'Category',
      'Amount',
    ];

    //todo: Only fetch all from property
    /// Get expenditures and earnings from the database
    List<Expenditure?> expenditures = await Expenditure.fetchAll() ?? [];
    List<Earning?> earnings = await Earning.fetchAll() ?? [];

    /// Sort both lists by date
    expenditures.sort((a, b) {
      return a?.expenditureDate
              .compareTo(b?.expenditureDate ?? DateTime.now()) ??
          0;
    });

    earnings.sort((a, b) {
      return a?.earningDate.compareTo(b?.earningDate ?? DateTime.now()) ?? 0;
    });

    /// Create Expenditure and Earning Data Points
    List<_ExpenditureDataPoint> expenditureData = expenditures
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

    List<_EarningDataPoint> earningData = earnings
        .map((item) => _EarningDataPoint(
            earning: item ??
                Earning(
                    name: "",
                    earningDate: DateTime.now(),
                    category: vd.Category(name: ""),
                    amount: 0,
                    propertyKey: widget.property.key)))
        .toList();

    /// Create Graphs
    // Get income data
    List<double> income = await widget.property.getIncomeByInterval(
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
          _getInterval(),
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
              drawPoints: true,
              pointSize: 6,
              color: pdfPrimary,
              data: List<pw.PointChartValue>.generate(
                  income.length,
                  (index) =>
                      pw.PointChartValue(index.toDouble() + 1, income[index])))
        ]);

    /// Create base report
    final report = pw.Document(
        title:
            "${widget.property.name} report $startDate to ${DateFormat.yMMMMd('en_US').format(widget.endDate)}",
        author: "Villadex",
        compress: true,
        version: PdfVersion.pdf_1_5,
        pageMode: PdfPageMode.thumbs);

    /// Fill out the report
    report.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
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

              ///General Information
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text("Profits",
                      style: VilladexTextStyles().getPDFHeading1()),
                ],
              ),

              pw.SizedBox(height: 20),

              pw.Row(children: [
                /// Data
                pw.Expanded(
                  child: pw.Column(
                    children: [
                      // Gross Profit
                      pw.Text("Gross Profit",
                          style: VilladexTextStyles().getPDFText()),
                    ],
                  ),
                ),

                /// Graph
                pw.Expanded(flex: 2, child: profitsChart),
              ])

              /// Earnings
              /*pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text("Earnings",
                      style: VilladexTextStyles().getPDFHeading1()),
                ],
              ),

              // Spacing
              pw.SizedBox(height: 15),

              // Table
              pw.Table.fromTextArray(
                // Decoration
                headerDecoration: pw.BoxDecoration(
                  borderRadius:
                      const pw.BorderRadius.all(pw.Radius.circular(2)),
                  color: pdfPrimary, //VilladexColors().pdfPrimary,
                ),

                oddRowDecoration: pw.BoxDecoration(
                  color: pdfOddRow, //VilladexColors().pdfOddRow,
                ),

                cellAlignments: {
                  0: pw.Alignment.centerLeft,
                  1: pw.Alignment.centerLeft,
                  2: pw.Alignment.centerLeft,
                  3: pw.Alignment.centerLeft,

                },

                /// Get Headers
                headers: List<String>.generate(earningHeaders.length,
                    (col) => earningHeaders[col]),

                /// Get Data
                data: List<List<String>>.generate(
                  earningData.length,
                  (row) => List<String>.generate(earningHeaders.length,
                      (col) => earningData[row].getIndex(col)),
                ),
              ),

              pw.SizedBox(height: 20),

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
                  borderRadius:
                      const pw.BorderRadius.all(pw.Radius.circular(2)),
                  color: pdfPrimary, //VilladexColors().pdfPrimary,
                ),

                oddRowDecoration: pw.BoxDecoration(
                  color: pdfOddRow, //VilladexColors().pdfOddRow,
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
                headers: List<String>.generate(expenditureHeaders.length,
                    (col) => expenditureHeaders[col]),

                /// Get Data
                data: List<List<String>>.generate(
                  expenditureData.length,
                  (row) => List<String>.generate(expenditureHeaders.length,
                      (col) => expenditureData[row].getIndex(col)),
                ),
              ),

              pw.SizedBox(height: 20),*/
            ],
          );
        },
      ),
    );

    return report.save();
  }

  String _getInterval() {
    switch (widget.options["Interval"]) {
      case DataInterval.weekly:
        return "Week";
      case DataInterval.biWeekly:
        return "Two Weeks";
      case DataInterval.monthly:
        return "Month";
      case DataInterval.biYearly:
        return "6 Months";
      case DataInterval.yearly:
        return "Year";
      case DataInterval.yearToDate:
        return "Year to Date";
    }
    return "Error";
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
