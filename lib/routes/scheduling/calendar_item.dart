import 'package:flutter/material.dart';

import '../../model/event_model.dart';

class CalendarListItem extends StatefulWidget {
  final Event event;

  const CalendarListItem({required this.event, Key? key}) : super(key: key);

  @override
  State<CalendarListItem> createState() => _CalendarListItemState();
}

class _CalendarListItemState extends State<CalendarListItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 200,
      color: Colors.blue,
    );
  }
}
