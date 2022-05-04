import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:villadex/Style/colors.dart';
import 'package:villadex/Style/text_styles.dart';

/// Theming for the entire app
ThemeData getTheme() {
  return ThemeData(
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    }),
  );
}

/// Styling for the Calendar
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
