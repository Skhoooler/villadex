import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:google_fonts/google_fonts.dart';
import 'package:villadex/style/colors.dart';

class VilladexTextStyles {
  /// Main TextStyle

  /// Secondary TextStyle
  TextStyle getSecondaryTextStyle() {
    return GoogleFonts.openSans(
        textStyle: TextStyle(
            color: VilladexColors().text,
            fontWeight: FontWeight.w600,
            fontSize: 25));
  }

  /// Tertiary TextStyle
  TextStyle getTertiaryTextStyle() {
    return GoogleFonts.openSans(
      textStyle: TextStyle(
        color: VilladexColors().text,
        fontWeight: FontWeight.w400,
        fontSize: 20,
      ),
    );
  }

  /// Tertiary TextStyle (With White Text)
  TextStyle getTertiaryTextStyleWhite() {
    return GoogleFonts.openSans(
      textStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w400,
        fontSize: 20,
      ),
    );
  }

  /// Quaternary TextStyle
  TextStyle getQuaternaryTextStyle() {
    return GoogleFonts.ebGaramond(
      textStyle: TextStyle(
        color: VilladexColors().text,
        fontWeight: FontWeight.w400,
        fontSize: 16,
      ),
    );
  }

  /// Calendar TextStyle
  TextStyle getCalendarTextStyle() {
    return GoogleFonts.abel(
        textStyle: TextStyle(
            color: VilladexColors().text, fontWeight: FontWeight.w500));
  }

  /// Set pdf font sizes
  final double _title = 40;
  final double _subtitle = 20;
  final double _heading1 = 30;
  final double _heading2 = 25;
  final double _text = 12;

  /// PDF Title
  pw.TextStyle getPDFTitle() {
    return pw.TextStyle(
      font: pw.Font.helveticaBold(),
      fontSize: _title,
    );
  }

  /// PDF Subtitle
  pw.TextStyle getPDFSubtitle() {
    return pw.TextStyle(
      font: pw.Font.helveticaOblique(),
      fontSize: _subtitle,
    );
  }

  /// PDF Heading 1
  pw.TextStyle getPDFHeading1() {
    return pw.TextStyle(
      font: pw.Font.helvetica(),
      fontSize: _heading1,
    );
  }

  /// PDF Heading 2
  pw.TextStyle getPDFHeading2() {
    return pw.TextStyle(
      font: pw.Font.helvetica(),
      fontSize: _heading2,
    );
  }

  /// PDF Regular Text
  pw.TextStyle getPDFText() {
    return pw.TextStyle(
      font: pw.Font.helveticaBold(),
      fontSize: _heading1,
    );
  }
}
