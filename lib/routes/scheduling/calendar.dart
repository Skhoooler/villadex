import 'dart:collection';

import 'package:flutter/material.dart';

import 'package:table_calendar/table_calendar.dart';

import 'package:villadex/Style/theme.dart';
import 'package:villadex/model/event_model.dart';
import '../../style/colors.dart';

class VilladexCalendar extends StatefulWidget {
  const VilladexCalendar({Key? key}) : super(key: key);

  @override
  State<VilladexCalendar> createState() => _VilladexCalendarState();
}

class _VilladexCalendarState extends State<VilladexCalendar> {
  final startCalendar = DateTime.utc(2020);
  final endCalendar = DateTime.utc(DateTime
      .now()
      .year + 10);

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [VilladexColors().primary, VilladexColors().background],
          begin: const Alignment(0.0, -1),
          end: const Alignment(0.0, .9),
        ),
      ),
      padding: const EdgeInsetsDirectional.only(bottom: 50),
      child: FutureBuilder<List<Event?>?>(
        future: Event.fetchAll(),
        builder: (context, snapshot) {
          List<Widget> children = [];

          /// Fill out the Calendar if there is data
          if (snapshot.hasData) {
            children = [
              TableCalendar(
                focusedDay: DateTime.now(),
                firstDay: startCalendar,
                lastDay: endCalendar,
                calendarStyle: getCalendarStyle(),
                headerStyle: getCalendarHeaderStyle(),
                /// Loads Events from the future builder to the calenar
                eventLoader: (DateTime day) {
                  return snapshot.data?.where(
                      (event) {
                        if (event?.date.toUtc().compareTo(day.toUtc()) == 0) {
                          return true;
                        } else {
                          return false;
                        }
                      }).toList() ?? [];
                },
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
            ];
          }

          /// Wait to get events
          else {
            children = const <Widget>[
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Fetching your events...'),
              ),
            ];
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          );
        },
      ),
    );
  }
}
