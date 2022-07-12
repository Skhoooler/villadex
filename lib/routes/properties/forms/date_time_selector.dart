import 'package:flutter/material.dart';
import 'package:villadex/style/colors.dart';
import 'package:villadex/style/text_styles.dart';
import 'package:intl/intl.dart';

class DateTimeSelector extends StatefulWidget {
  // Used to send data back to the parent
  final callback;
  final String dateDisplayText;

  const DateTimeSelector(
      {Key? key,
      required this.callback,
      this.dateDisplayText = "Date & Time",})
      : super(key: key);

  @override
  State<DateTimeSelector> createState() => _DateTimeSelectorState();
}

class _DateTimeSelectorState extends State<DateTimeSelector> {
  bool dateSelected = false;
  String display = "Date & Time";
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 6,
        bottom: 6,
        left: 3,
        right: 12,
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * .4,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: VilladexColors().primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                onPrimary:
                    VilladexTextStyles().getTertiaryTextStyleWhite().color),
            onPressed: (() {
              _selectDateTime(context);
            }),
            child: Center(
              child: Text(dateSelected
                  ? display
                  : widget.dateDisplayText),
            ) //Text(display),
            ),
      ),
    );
  }

  void _selectDateTime(BuildContext context) async {
    // Pull up the date picker
    selectedDate = (await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2030),
        )) ??
        DateTime.now();

    final selectedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(DateTime.now()),
        ) ??
        TimeOfDay.fromDateTime(DateTime.now());

    selectedDate = DateTime(selectedDate.year, selectedDate.month,
        selectedDate.day, selectedTime.hour, selectedTime.minute);

    // Set the display to the selected Date
    if (display != selectedDate.toString()) {
      setState(() {
        dateSelected = true;
        display = DateFormat('yMMMMd').add_jm().format(selectedDate);
      });
    }

    // Send the data back to the parent
    widget.callback(selectedDate);
  }
}
