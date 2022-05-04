import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:villadex/Style/colors.dart';

class VilladexTextStyles {
  TextStyle getCalendarTextStyle() {
    return GoogleFonts.abel(
      textStyle: TextStyle(
        color: VillaDexColors().text,
        fontWeight: FontWeight.w500
      )
    );
  }
}