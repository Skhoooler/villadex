import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:villadex/Style/colors.dart';

import '../../../Util/nav_bar.dart';
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
        color: VilladexColors().background,
      ),

      /// Bottom Nav Bar
      bottomNavigationBar: const NavBar(),
    );
  }
}
