import 'package:flutter/material.dart';
import 'package:villadex/style/colors.dart';
import 'package:villadex/style/text_styles.dart';
import 'package:intl/intl.dart';

class DateSelector extends StatefulWidget {
  // Used to send data back to the parent
  final callback;

  const DateSelector({Key? key, required this.callback}) : super(key: key);

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  String display = "Date";
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
        width: MediaQuery.of(context).size.width * .3,
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
            _selectDate(context);
          }),
          child: Text(display),
        ),
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    // Pull up the date picker
    selectedDate = (await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2030),
        )) ??
        DateTime.now();

    // Set the display to the selected Date
    if (display != selectedDate.toString()) {
      setState(() {
        display = DateFormat('yMd').format(selectedDate);
      });
    }

    // Send the data back to the parent
    widget.callback(selectedDate);
  }
}
