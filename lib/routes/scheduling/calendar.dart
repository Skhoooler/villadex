import 'dart:collection';

import 'package:flutter/material.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:villadex/Style/text_styles.dart';

import 'package:villadex/Style/theme.dart';
import 'package:villadex/Util/nav_bar.dart';
import 'package:villadex/model/event_model.dart';
import 'package:villadex/routes/scheduling/calendar_item.dart';
import '../../model/property_model.dart';
import '../../style/colors.dart';
import '../properties/forms/event.dart';

class VilladexCalendar extends StatefulWidget {
  const VilladexCalendar({Key? key}) : super(key: key);

  @override
  State<VilladexCalendar> createState() => _VilladexCalendarState();
}

class _VilladexCalendarState extends State<VilladexCalendar> {
  late Property selectedProperty;

  final startDay = DateTime.utc(2020);
  final endDay = DateTime.utc(DateTime.now().year + 10);
  CalendarFormat _calendarFormat = CalendarFormat.month;

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
                        calendarFormat: _calendarFormat,
                        calendarStyle: getCalendarStyle(),
                        headerStyle: getCalendarHeaderStyle(),
                        startingDayOfWeek: StartingDayOfWeek.sunday,
                        firstDay: startDay,
                        lastDay: endDay,
                        focusedDay: _selectedDay,
                        eventLoader: (DateTime day) {
                          return snapshot.data![day] ?? [];
                        },
                        selectedDayPredicate: (day) {
                          return isSameDay(_selectedDay, day);
                        },
                        onFormatChanged: (format) {
                          setState(() {
                            _calendarFormat = format;
                          });
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = selectedDay;
                            focusedDay = selectedDay;

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Select a Property"),
                  content: Container(
                    width: MediaQuery.of(context).size.width * .75,
                    height: MediaQuery.of(context).size.height * .5,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: VilladexColors().accent,
                        width: 5,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),

                    /// Pull up properties
                    child: FutureBuilder<List<Property?>?>(
                      future: Property.fetchAll(),
                      builder: (context, snapshot) {
                        List<Widget> data = [];

                        if (snapshot.hasData) {
                          data = snapshot.data?.map((property) {
                                return ListTile(
                                  title: Text(property?.name ?? "Error"),
                                  focusColor: VilladexColors().primary,
                                  hoverColor: VilladexColors().primary,
                                  selectedColor: VilladexTextStyles()
                                      .getTertiaryTextStyleWhite()
                                      .color,
                                  selectedTileColor: VilladexColors().primary,
                                  textColor: VilladexColors().text,
                                  enabled: true,
                                  onTap: () {
                                    Navigator.pop(context);

                                    // Add Event
                                    showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return EventForm(
                                            propertyKey: property?.key ?? 0,
                                          );
                                        });
                                  },
                                );
                              }).toList() ??
                              [];
                        }
                        return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return data[index];
                          },
                        );
                      },
                    ),
                  ),
                );
              });
        },
        backgroundColor: VilladexColors().primary,
        child: const Icon(Icons.add),
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
