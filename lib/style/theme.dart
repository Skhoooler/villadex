import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:villadex/Style/text_styles.dart';

import 'colors.dart';

/// Theming for the entire app
ThemeData getTheme() {
  return ThemeData(
    /// Decoration for Page Transitions
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    }),

    /// Decoration for TextFields
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: VilladexColors().primary,
      selectionColor: VilladexColors().primary,
      selectionHandleColor: VilladexColors().primary,
    ),

    /// Decoration for TextFields
    inputDecorationTheme: InputDecorationTheme(

      isDense: true,

      // Default
      border: const UnderlineInputBorder(),

      // Focused
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(40),
        borderSide: BorderSide(
          color: VilladexColors().primary,
          width: 2.0,
        ),
      ),
      labelStyle: TextStyle(
        color: VilladexColors().text
      ),

      // Error
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: VilladexColors().error,
          width: 2.0,
        ),
      ),
      errorStyle: TextStyle(color: VilladexColors().error),
      errorMaxLines: 2,
    ),

    highlightColor: VilladexColors().primary,
    splashColor: VilladexColors().accent,
  );
}

/// Styling for the Calendar Body
CalendarStyle getCalendarStyle() {
  return CalendarStyle(
    canMarkersOverflow: false,
    isTodayHighlighted: true,
    outsideDaysVisible: false,

    /// Cell Decoration
    todayDecoration: ShapeDecoration(
      shape: const CircleBorder(),
      color: VilladexColors().fadedPrimary,
    ),

    selectedDecoration: ShapeDecoration(
      shape: const CircleBorder(),
      color: VilladexColors().primary,
    ),

    /// TextStyles
    defaultTextStyle: VilladexTextStyles().getCalendarTextStyle(),
    disabledTextStyle: VilladexTextStyles().getCalendarTextStyle().copyWith(
          color: VilladexColors().error,
        ),
    holidayTextStyle: VilladexTextStyles()
        .getCalendarTextStyle()
        .copyWith(color: VilladexColors().accent),
    outsideTextStyle: VilladexTextStyles()
        .getCalendarTextStyle()
        .copyWith(color: VilladexColors().calendarBackgroundText),
    weekendTextStyle: VilladexTextStyles().getCalendarTextStyle().copyWith(
        color: VilladexColors().primary,
        fontWeight: FontWeight.w900),
  );
}

/// Styling for the Calendar Head
HeaderStyle getCalendarHeaderStyle() {
  return const HeaderStyle(
    titleCentered: false,
    formatButtonShowsNext: false,

    // Chevron are the '<' '>' icons to swipe the calendar to the left or right
    rightChevronVisible: true,
    leftChevronVisible: true,
    formatButtonVisible: true
  );
}
