import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';

import '../../../Style/colors.dart';
import '../../../Style/text_styles.dart';
import '../../../model/property_model.dart';
import '../../../model/expenditure_model.dart';
import '../../../model/earning_model.dart';

//////////////////////////////////////////////////////////////
/// Displays the net and gross profits of the property
//////////////////////////////////////////////////////////////
class Profits extends StatefulWidget {
  final Property property;

  const Profits({
    required this.property,
    Key? key,
  }) : super(key: key);

  @override
  State<Profits> createState() => _ProfitState();
}

class _ProfitState extends State<Profits> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Material(
        elevation: 20,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            color: VilladexColors().background2,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// Title
              Center(
                child: Text(
                  "Profits",
                  style: VilladexTextStyles().getTertiaryTextStyle(),
                ),
              ),

              /// Body
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: VilladexColors().background2,
                    child: FutureBuilder(
                      future: Future.wait(
                          [Expenditure.fetchAll(), Earning.fetchAll()]),
                      builder:
                          (context, AsyncSnapshot<List<dynamic>> snapshot) {
                        // Snapshot[0] = Expenditure
                        // Snapshot[1] = Earning
                        /*if (snapshot.hasData) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: LineChart(LineChartData(
                              lineBarsData: [LineChartBarData(spots: [],),],
                            )),
                          );
                        }*/

                        return Text(
                          "Loading data...",
                          style: VilladexTextStyles().getSecondaryTextStyle(),
                        );
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
