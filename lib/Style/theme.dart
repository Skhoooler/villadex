import 'package:flutter/material.dart';

import 'package:villadex/Style/colors.dart';

/// Theming for the entire app
ThemeData getTheme() {
  return ThemeData(
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
      }
    ),
  );
}