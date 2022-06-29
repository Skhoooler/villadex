import 'package:flutter/material.dart';
import 'package:villadex/Style/colors.dart';
import 'package:villadex/routes/properties/forms/date_selector.dart';
import 'package:villadex/routes/properties/menu%20options/generate_report.dart';

import '../../../Style/text_styles.dart';
import '../../../Util/nav_bar.dart';
import '../../../model/property_model.dart';

enum DataInterval { weekly, biWeekly, monthly, biYearly, yearly, yearToDate }

class GenerateReportOptions extends StatefulWidget {
  final Property property;

  const GenerateReportOptions({required this.property, Key? key})
      : super(key: key);

  @override
  State<GenerateReportOptions> createState() => _GenerateReportOptionsState();
}

class _GenerateReportOptionsState extends State<GenerateReportOptions> {
  DateTime _dateStart = DateTime.now();
  DateTime _dateEnd = DateTime.now();

  /// Options
  Map<String, dynamic> options = {
    "Expenditures": true,
    "Earnings": true,
    "Data Interval": DataInterval.weekly,
  };

  String selectedInterval = "Weekly";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: VilladexColors().background,
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),

            /// Back button and Name
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// Back Button
                IconButton(
                  iconSize: 35,
                  color: VilladexColors().accent,
                  icon: const Icon(
                    Icons.arrow_back,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),

                const SizedBox(
                  width: 10,
                ),

                /// Page Name
                Text(
                  "Create a Report",
                  style: VilladexTextStyles().getSecondaryTextStyle(),
                ),
              ],
            ),

            const SizedBox(
              height: 20,
            ),

            /// Select Dates
            Center(
              child: Text(
                "Select Start  and End Date",
                style: VilladexTextStyles().getTertiaryTextStyle(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DateSelector(
                    callback: _setDateTimeStart, displayText: "Start Date"),
                DateSelector(
                    callback: _setDateTimeEnd, displayText: "End Date"),
              ],
            ),

            /// Select data frequency
            Text(
              "Data Interval",
              style: VilladexTextStyles().getTertiaryTextStyle(),
            ),

            DropdownButton(
              value: selectedInterval,
              onChanged: (String? newValue) {
                if (newValue == "Weekly") {
                  options["Data Interval"] = DataInterval.weekly;
                } else if (newValue == "Bi-Weekly") {
                  options["Data Interval"] = DataInterval.biWeekly;
                } else if (newValue == "Monthly") {
                  options["Data Interval"] = DataInterval.monthly;
                } else if (newValue == "Bi-Yearly") {
                  options["Data Interval"] = DataInterval.biYearly;
                } else if (newValue == "Yearly") {
                  options["Data Interval"] = DataInterval.yearly;
                } else if (newValue == "Year-To-Date") {
                  options["Data Interval"] = DataInterval.yearToDate;
                }

                setState(() {
                  selectedInterval = newValue ?? "Error";
                });
              },
              items: [
                'Weekly',
                'Bi-Weekly',
                'Monthly',
                'Bi-Yearly',
                'Yearly',
                'Year-To-Date'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),

            /// Create Report Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReportGenerator(
                      property: widget.property,
                      startDate: _dateStart,
                      endDate: _dateEnd,
                      options: options,
                    ),
                  ),
                );
              },
              child: const Text("Create Report"),
            )
          ],
        ),
      ),

      /// Bottom Nav Bar
      bottomNavigationBar: const NavBar(),
    );
  }

  /// Gets the starting DateTime from the DateSelector child widget
  _setDateTimeStart(DateTime dateSelected) {
    setState(() {
      _dateStart = dateSelected;
    });
  }

  /// Gets the ending DateTime from the DateSelector child widget
  _setDateTimeEnd(DateTime dateSelected) {
    setState(() {
      _dateEnd = dateSelected;
    });
  }
}
