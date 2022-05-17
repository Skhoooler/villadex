import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:villadex/Style/colors.dart';
import 'package:villadex/Style/text_styles.dart';

/// Theming for the entire app
ThemeData getTheme() {
  return ThemeData(
    /// Decoration for Page Transitions
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    }),

    /// Decoration for TextFields
    inputDecorationTheme: InputDecorationTheme(

      isDense: true,

      // Default
      border: const UnderlineInputBorder(),

      // Focused
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(40),
        borderSide: BorderSide(
          color: VillaDexColors().primary,
          width: 2.0,
        ),
      ),
      labelStyle: TextStyle(
        color: VillaDexColors().secondary
      ),

      // Error
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: VillaDexColors().error,
          width: 2.0,
        ),
      ),
      errorStyle: TextStyle(color: VillaDexColors().error),
      errorMaxLines: 2,
    ),
  );
}

/// Styling for the Calendar Body
CalendarStyle getCalendarStyle() {
  return CalendarStyle(
    canMarkersOverflow: false,
    isTodayHighlighted: true,
    outsideDaysVisible: true,

    /// Cell Decoration
    todayDecoration: ShapeDecoration(
      shape: const CircleBorder(),
      color: VillaDexColors().primaryGradient,
    ),

    /// TextStyles
    defaultTextStyle: VilladexTextStyles().getCalendarTextStyle(),
    disabledTextStyle: VilladexTextStyles().getCalendarTextStyle().copyWith(
          color: VillaDexColors().error,
        ),
    holidayTextStyle: VilladexTextStyles()
        .getCalendarTextStyle()
        .copyWith(color: VillaDexColors().blue),
    outsideTextStyle: VilladexTextStyles()
        .getCalendarTextStyle()
        .copyWith(color: VillaDexColors().calendarBackgroundText),
    weekendTextStyle: VilladexTextStyles().getCalendarTextStyle().copyWith(
        color: VillaDexColors().calendarBackgroundAccent,
        fontWeight: FontWeight.w900),
  );
}

/// Styling for the Calendar Head
HeaderStyle getCalendarHeaderStyle() {
  return const HeaderStyle(
    titleCentered: false,

    // Chevron are the '<' '>' icons to swipe the calendar to the left or right
    rightChevronVisible: true,
    leftChevronVisible: true,
  );
}
