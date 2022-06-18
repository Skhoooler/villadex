import 'package:flutter/material.dart';
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
        fontSize: 25
      )
    );
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

  /// Calendar TextStyle
  TextStyle getCalendarTextStyle() {
    return GoogleFonts.abel(
      textStyle: TextStyle(
        color: VilladexColors().text,
        fontWeight: FontWeight.w500
      )
    );
  }
}