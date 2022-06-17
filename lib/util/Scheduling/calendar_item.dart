import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:villadex/Style/theme.dart';

import '../../style/colors.dart';

class CalendarItem extends StatefulWidget {
  const CalendarItem(
      {Key? key,
      required String event,
      required DateTime start,
      required DateTime end})
      : super(key: key);

  @override
  State<CalendarItem> createState() => _CalendarItemState();
}

class _CalendarItemState extends State<CalendarItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Text Information
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Event Name
              Container(
                height: 15,
                child: const Text('Cleaning'),
              ),

              /// Event Location
              Container(
                height: 15,
                child: const Text('La Casita'),
              ),

              /// Time
              Container(
                height: 15,
                child: const Text('8:00am - 9:00am'),
              )
            ],
          ),

          /// Image
          Container(
            height: 50,
            width: 50,
            color: VilladexColors().primary,
          ),
        ],
      ),
    );
  }
}
