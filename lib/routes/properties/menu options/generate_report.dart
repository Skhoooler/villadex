import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

import 'package:villadex/Style/colors.dart';

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
    List<Expenditure?>? expenditures = await Expenditure.fetchAll();
    List<Earning?>? earnings = await Earning.fetchAll();

    final report = pw.Document(
        title:
            "${widget.property.name} report ${DateFormat.yMMMMd('en_US').format(DateTime.now())}",
        author: "Villadex",
        compress: true,
        version: PdfVersion.pdf_1_5);

    report.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(children: [
            /// Title
            pw.SizedBox(
              width: double.infinity,
              child: pw.FittedBox(
                child: pw.Text(
                  "${widget.property.name} Report ${DateFormat.yMMMMd('en_US').format(DateTime.now())}",
                  //todo: Add fonts
                ),
              ),
            ),

            /// Spacing

          ]);
        }));

    return report.save();
  }
}
