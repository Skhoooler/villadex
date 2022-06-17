import 'package:flutter/material.dart';
import 'colors.dart';
import 'text_styles.dart';

class VilladexButton {
  ButtonStyle getStyle() {
    return ButtonStyle(
        backgroundColor: MaterialStateProperty.all(VilladexColors().primary),
        foregroundColor: MaterialStateProperty.all(VilladexColors().background),
        elevation: MaterialStateProperty.all(8),
        fixedSize: MaterialStateProperty.all(const Size(250, 155)),
        textStyle: MaterialStateProperty.all(
            VilladexTextStyles().getTertiaryTextStyle()));
  }
}
