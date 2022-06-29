import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

import '../../../style/colors.dart';

import '../../../Util/nav_bar.dart';
import '../../../model/earning_model.dart';
import '../../../model/expenditure_model.dart';
import '../../../model/property_model.dart';

class ReportGenerator extends StatefulWidget {
  final Property property;

  const ReportGenerator({required this.property, Key? key}) : super(key: key);

  @override
  State<ReportGenerator> createState() => _ReportGeneratorState();
}

class _ReportGeneratorState extends State<ReportGenerator> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Body
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

  /// Generates a PDF file
  Future<Uint8List> _generateReport() async {
    /// Set font sizes
    double title = 40;
    double heading1 = 25;
    double text = 12;

    /// Set Colors (since VilladexColors won't work here)
    PdfColor primary = PdfColor.fromInt(VilladexColors().primary.value);
    PdfColor oddRow = PdfColor.fromInt(VilladexColors().oddRow.value);
    PdfColor whiteText = PdfColor.fromInt(VilladexColors().background.value);

    /// Create Headers for Tables
    const expenditureHeaders = [
      'Name',
      'Date',
      'Category',
      'Price',
      'Number',
      'Total',
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
        .map(
          (item) => _ExpenditureDataPoint(
            item?.name ?? "",
            item?.category.name ?? "",
            DateFormat('yMd').format(item?.expenditureDate ?? DateTime.now()),
            item?.numUnits.toString() ?? "",
            "\$${item?.amount.toStringAsFixed(2)}" ?? "",
            "\$${(item?.numUnits ?? 0 * item!.amount).toStringAsFixed(2)}",
          ),
        )
        .toList();

    /// Create base report
    final report = pw.Document(
        title:
            "${widget.property.name} report ${DateFormat.yMMMMd('en_US').format(DateTime.now())}",
        author: "Villadex",
        compress: true,
        version: PdfVersion.pdf_1_5);

    /// Fill out the report
    report.addPage(pw.Page(
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
                      "${widget.property.name} Report ${DateFormat.yMMMMd('en_US').format(DateTime.now())}",
                      style: pw.TextStyle(
                        font: pw.Font.helveticaBold(),
                        fontSize: title,
                      ),
                      overflow: pw.TextOverflow.visible,
                      maxLines: 2,
                    ),
                  ),
                ),
              ),

              /// Spacing
              pw.SizedBox(height: 20),

              /// Expenditures
              // Heading
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text(
                    "Expenditures",
                    style: pw.TextStyle(
                      font: pw.Font.helvetica(),
                      fontSize: heading1,
                    ),
                  ),
                ],
              ),

              // Spacing
              pw.SizedBox(height: 15),

              // Table
              pw.Table.fromTextArray(
                /// Decoration
                headerDecoration: pw.BoxDecoration(
                  borderRadius:
                      const pw.BorderRadius.all(pw.Radius.circular(2)),
                  color: primary,
                ),

                oddRowDecoration: pw.BoxDecoration(
                  color: oddRow,
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
            ],
          );
        }));

    return report.save();
  }
}

class _ExpenditureDataPoint {
  const _ExpenditureDataPoint(
    this.name,
    this.category,
    this.date,
    this.number,
    this.price,
    this.total,
  );

  final String name;
  final String category;
  final String date;
  final String price;
  final String number;
  final String total;

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
