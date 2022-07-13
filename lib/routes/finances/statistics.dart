import 'package:flutter/material.dart';
import 'package:villadex/style/colors.dart';
import 'package:villadex/style/text_styles.dart';
import 'package:intl/intl.dart';
import '../../util/analysis.dart';

class VilladexStatistics extends StatefulWidget {
  final VilladexAnalysis analyzer;

  const VilladexStatistics({required this.analyzer, Key? key})
      : super(key: key);

  @override
  State<VilladexStatistics> createState() => _VilladexStatisticsState();
}

class _VilladexStatisticsState extends State<VilladexStatistics> {
  String selectedIntervalName = "Weekly";
  DataInterval selectedInterval = DataInterval.weekly;

  @override
  Widget build(BuildContext context) {
    DateTime end = DateTime.now();
    DateTime start = end.subtract(
        Duration(days: widget.analyzer.setIntervalDays(selectedInterval)));

    double gross = widget.analyzer.getGrossByInterval(start, end);
    double net = widget.analyzer.getNetByInterval(start, end);
    double expenses = widget.analyzer.getTotalExpenditureByInterval(start, end);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// Title
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 8),
            child: Text(
              "Statistics",
              style:
              VilladexTextStyles().getSecondaryTextStyle(),
            ),
          ),
        ),

        /// Dates
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: Center(
            child: Text(
              "${DateFormat.yMMMd("en_US").format(DateTime.now().subtract(Duration(days: widget.analyzer.setIntervalDays(selectedInterval)))).toString()}   -   ${DateFormat.yMMMd("en_US").format(DateTime.now()).toString()}",
              style: VilladexTextStyles().getTertiaryTextStyle(),
            ),
          ),
        ),

        /// Select Interval
        Center(
          child: DropdownButton(
            value: selectedIntervalName,
            onChanged: (String? newValue) {
              if (newValue == "Weekly") {
                selectedInterval = DataInterval.weekly;
              } else if (newValue == "Bi-Weekly") {
                selectedInterval = DataInterval.biWeekly;
              } else if (newValue == "Monthly") {
                selectedInterval = DataInterval.monthly;
              } else if (newValue == "Bi-Yearly") {
                selectedInterval = DataInterval.biYearly;
              } else if (newValue == "Yearly") {
                selectedInterval = DataInterval.yearly;
              } else if (newValue == "Year-To-Date") {
                selectedInterval = DataInterval.yearToDate;
              }

              setState(() {
                selectedIntervalName = newValue ?? "Error";
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
        ),

        /// Table Header
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Expanded(flex: 2, child: Text("")),
            Expanded(
              flex: 3,
              child: Text(
                "Expenditures",
                style: VilladexTextStyles().getTertiaryTextStyle(),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                "Earnings",
                style: VilladexTextStyles().getTertiaryTextStyle(),
              ),
            ),
          ],
        ),

        /// Mean
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Text(
                "Mean",
                style: VilladexTextStyles().getTertiaryTextStyle(),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                "\$${widget.analyzer.getExpenditureMeanByInterval(selectedInterval).toStringAsFixed(2)}",
                style: VilladexTextStyles()
                    .getTertiaryTextStyle()
                    .copyWith(color: VilladexColors().error),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                "\$${widget.analyzer.getEarningMeanByInterval(selectedInterval).toStringAsFixed(2)}",
                style: VilladexTextStyles()
                    .getTertiaryTextStyle()
                    .copyWith(color: VilladexColors().money),
              ),
            )
          ],
        ),

        /// Median
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Text(
                "Median",
                style: VilladexTextStyles().getTertiaryTextStyle(),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                "\$${widget.analyzer.getExpenditureMedianByInterval(selectedInterval).toStringAsFixed(2)}",
                style: VilladexTextStyles()
                    .getTertiaryTextStyle()
                    .copyWith(color: VilladexColors().error),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                "\$${widget.analyzer.getEarningMedianByInterval(selectedInterval).toStringAsFixed(2)}",
                style: VilladexTextStyles()
                    .getTertiaryTextStyle()
                    .copyWith(color: VilladexColors().money),
              ),
            ),
          ],
        ),

        const SizedBox(
          height: 15,
        ),

        /// Gross Earnings
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    "Gross Earnings",
                    style: VilladexTextStyles().getTertiaryTextStyle(),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    gross > 0
                        ? "\$${gross.toStringAsFixed(2)}"
                        : "-\$${(gross * -1).toStringAsFixed(2)}",
                    style: gross > 0
                        ? VilladexTextStyles().getTertiaryTextStyle().copyWith(
                              color: VilladexColors().money,
                            )
                        : VilladexTextStyles().getTertiaryTextStyle().copyWith(
                              color: VilladexColors().error,
                            ),
                  ),
                ),
              ),
            ],
          ),
        ),

        /// Net Earnings
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  "Net Earnings",
                  style: VilladexTextStyles().getTertiaryTextStyle(),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  net > 0
                      ? "\$${net.toStringAsFixed(2)}"
                      : "-\$${(net * -1).toStringAsFixed(2)}",
                  style: net > 0
                      ? VilladexTextStyles().getTertiaryTextStyle().copyWith(
                            color: VilladexColors().money,
                          )
                      : VilladexTextStyles().getTertiaryTextStyle().copyWith(
                            color: VilladexColors().error,
                          ),
                ),
              ),
            ),
          ],
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  "Total Expenditures",
                  style: VilladexTextStyles().getTertiaryTextStyle(),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  expenses == 0
                      ? "\$${expenses.toStringAsFixed(2)}"
                      : "-\$${expenses.toStringAsFixed(2)}",
                  style: expenses == 0
                      ? VilladexTextStyles()
                          .getTertiaryTextStyle()
                          .copyWith(color: VilladexColors().money)
                      : VilladexTextStyles()
                          .getTertiaryTextStyle()
                          .copyWith(color: VilladexColors().error),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
