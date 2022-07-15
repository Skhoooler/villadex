import 'package:flutter/material.dart';
import 'package:villadex/style/colors.dart';
import 'package:villadex/style/text_styles.dart';
import '../../util/analysis.dart';

class VilladexStatistics extends StatefulWidget {
  final VilladexAnalysis analyzer;
  final DateTime start;
  final DateTime end;
  final DataInterval selectedInterval;

  const VilladexStatistics({
    required this.analyzer,
    required this.start,
    required this.end,
    required this.selectedInterval,
    Key? key,
  }) : super(key: key);

  @override
  State<VilladexStatistics> createState() => _VilladexStatisticsState();
}

class _VilladexStatisticsState extends State<VilladexStatistics> {
  @override
  Widget build(BuildContext context) {
    double gross = widget.analyzer.getGrossByInterval(widget.start, widget.end);
    double net = widget.analyzer.getNetByInterval(widget.start, widget.end);
    double expenses =
        widget.analyzer.getTotalExpenditureByInterval(widget.start, widget.end);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// Title
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              "Statistics",
              style: VilladexTextStyles().getSecondaryTextStyle(),
            ),
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
                "\$${widget.analyzer.getExpenditureMeanByInterval(widget.selectedInterval).toStringAsFixed(2)}",
                style: VilladexTextStyles()
                    .getTertiaryTextStyle()
                    .copyWith(color: VilladexColors().error),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                "\$${widget.analyzer.getEarningMeanByInterval(widget.selectedInterval).toStringAsFixed(2)}",
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
                "\$${widget.analyzer.getExpenditureMedianByInterval(widget.selectedInterval).toStringAsFixed(2)}",
                style: VilladexTextStyles()
                    .getTertiaryTextStyle()
                    .copyWith(color: VilladexColors().error),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                "\$${widget.analyzer.getEarningMedianByInterval(widget.selectedInterval).toStringAsFixed(2)}",
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
                    "\$${gross.toStringAsFixed(2)}",
                    style: gross == 0
                        ? VilladexTextStyles().getTertiaryTextStyle().copyWith(
                              color: VilladexColors().error,
                            )
                        : VilladexTextStyles().getTertiaryTextStyle().copyWith(
                              color: VilladexColors().money,
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
                  "\$${net.toStringAsFixed(2)}",
                  style: net == 0
                      ? VilladexTextStyles().getTertiaryTextStyle().copyWith(
                            color: VilladexColors().error,
                          )
                      : VilladexTextStyles().getTertiaryTextStyle().copyWith(
                            color: VilladexColors().money,
                          ),
                ),
              ),
            ),
          ],
        ),

        /// Total Expenditures
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
