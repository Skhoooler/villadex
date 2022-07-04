import 'dart:collection';

import 'package:flutter/material.dart';

import 'package:table_calendar/table_calendar.dart';

import 'package:villadex/Style/theme.dart';
import 'package:villadex/Util/nav_bar.dart';
import 'package:villadex/model/event_model.dart';
import 'package:villadex/routes/scheduling/calendar_item.dart';
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
  List<Widget> events = [];

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

                            // On day selected, clear out the events list
                            events.clear();
                            // Repopulate it with events on that day
                            snapshot.data?[_selectedDay]?.forEach((event) {
                              events.add(
                                CalendarListItem(
                                  event: event ??
                                      Event(
                                        name: 'Error',
                                        date: DateTime.now(),
                                      ),
                                ),
                              );
                            });
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Center(
                          child: SingleChildScrollView(
                            child: Column(
                              children: events,
                            ),
                          ),
                        ),
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
