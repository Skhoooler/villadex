import 'dart:collection';

import 'package:flutter/material.dart';

import 'package:table_calendar/table_calendar.dart';

import 'package:villadex/Style/theme.dart';
import 'package:villadex/Util/nav_bar.dart';
import 'package:villadex/model/event_model.dart';
import '../../style/colors.dart';

class VilladexCalendar extends StatefulWidget {
  const VilladexCalendar({Key? key}) : super(key: key);

  @override
  State<VilladexCalendar> createState() => _VilladexCalendarState();
}

class _VilladexCalendarState extends State<VilladexCalendar> {
  final startDay = DateTime.utc(2020);
  final endDay = DateTime.utc(DateTime.now().year + 10);

  List<dynamic> _selectedEvents = [];

  DateTime _selectedDay = DateTime.now();
  /*DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  late Map<DateTime, List<dynamic>> _events;
  late List<dynamic> _selectedEvents;*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VilladexColors().background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<Map<DateTime, List<Event?>>>(
                future: populateEvents(),
                builder: (context, snapshot) {
                  List<Widget> calendar = [];

                  if (snapshot.hasData) {
                    calendar = [
                      TableCalendar(
                        calendarFormat: CalendarFormat.month,
                        calendarStyle: getCalendarStyle(),
                        headerStyle: getCalendarHeaderStyle(),
                        startingDayOfWeek: StartingDayOfWeek.sunday,
                        firstDay: startDay,
                        lastDay: endDay,
                        focusedDay: DateTime.now(),
                        eventLoader: (DateTime day) {
                          return snapshot.data![day] ?? [];
                        },
                        selectedDayPredicate: (day) {
                          return isSameDay(_selectedDay, day);
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = selectedDay;
                            focusedDay = focusedDay;
                          });
                        },
                      )
                    ];
                  }

                  return Column(
                    children: calendar,
                  );
                }),
          ],
        ),
      ),
      bottomNavigationBar: const NavBar(),
    );
  }

/*    return Container(
      decoration: BoxDecoration(
        color: VilladexColors().background,
        /*gradient: LinearGradient(
          colors: [VilladexColors().primary, VilladexColors().background],
          begin: const Alignment(0.0, -1),
          end: const Alignment(0.0, 1),
        ),*/
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

                /// Loads Events from the future builder to the calendar
                /*eventLoader: (DateTime day) {
                  return snapshot.data?.where(
                      (event) {
                        if (event?.date.toUtc().compareTo(day.toUtc()) == 0) {
                          return true;
                        } else {
                          return false;
                        }
                      }).toList() ?? [];
                },*/
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
  }*/

  Future<Map<DateTime, List<Event?>>> populateEvents() async {
    List<Event?> eventList = await Event.fetchAll() ?? [];
    _selectedEvents = [];

    /// Hashmap where the key is the DateTime, and the value is a List of events
    final events = LinkedHashMap<DateTime, List<Event?>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll({
      for (var event in eventList)
        // Key
        event?.date ?? DateTime.now():
            // Value
            eventList
                .where((element) =>
                    element?.date.toUtc().compareTo(
                        event?.date.toUtc() ?? DateTime.now().toUtc()) ==
                    0)
                .toList()
    });

    return events;
  }

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }
}
