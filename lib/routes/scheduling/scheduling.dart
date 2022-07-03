import 'package:flutter/material.dart';

import 'package:villadex/Util/nav_bar.dart';

import '../../style/colors.dart';
import 'calendar.dart';
import 'calendar_item.dart';

/*class SchedulingPage extends StatefulWidget {
  const SchedulingPage({Key? key}) : super(key: key);

  @override
  State<SchedulingPage> createState() => _SchedulingPageState();
}

class _SchedulingPageState extends State<SchedulingPage> {
  @override
  Widget build(BuildContext context) {
    // Replace this later with database calls
    List<CalendarItem> _calendarItems = [
      CalendarItem(
          event: "Event", start: DateTime.now(), end: DateTime.utc(2025))
    ];

    return Scaffold(
      /// Body
      body: Container(
        color: VilladexColors().background,
        child: Column(
          children: [
            const VilladexCalendar(),

            /// Calendar Items
            Column(
              children: _calendarItems,
            ),

            /// Add new item
            IconButton(
              color: VilladexColors().accent,
              onPressed: () {
                setState(() {
                  _calendarItems.add(CalendarItem(
                      event: "Event",
                      start: DateTime.now(),
                      end: DateTime.utc(2025)));
                });
              },
              icon: const Icon(
                Icons.add_circle,
              ),
              iconSize: 50,
            )
          ],
        ),
      ),

      /// Bottom Nav Bar
      bottomNavigationBar: const NavBar(),
    );
  }
}*/
