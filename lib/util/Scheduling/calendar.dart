import 'package:flutter/material.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:villadex/Util/Scheduling/calendar_item.dart';

import 'package:villadex/Style/colors.dart';
import 'package:villadex/Style/theme.dart';

class VilladexCalendar extends StatefulWidget {
  const VilladexCalendar({Key? key}) : super(key: key);

  @override
  State<VilladexCalendar> createState() => _VilladexCalendarState();
}

class _VilladexCalendarState extends State<VilladexCalendar> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {


    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            VillaDexColors().calendarBackground,
            VillaDexColors().background
          ],
          begin: const Alignment(0.0, -1),
          end: const Alignment(0.0, .9),
        ),
      ),
      padding: const EdgeInsetsDirectional.only(bottom: 50),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Calendar
          TableCalendar(
            focusedDay: DateTime.now(),
            firstDay: DateTime.utc(2015),
            lastDay: DateTime.utc(2050),
            calendarStyle: getCalendarStyle(),
            headerStyle: getCalendarHeaderStyle(),
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
          ),
        ],
      ),
    );
  }
}
