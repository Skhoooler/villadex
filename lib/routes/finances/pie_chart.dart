/// This code was initially taken from the fl_chart documentation
/// https://github.com/imaNNeoFighT/fl_chart/blob/master/example/lib/pie_chart/samples/indicator.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:villadex/style/text_styles.dart';
import 'package:villadex/util/analysis.dart';

import '../../style/colors.dart';

class VilladexPieChart extends StatefulWidget {
  final String title;
  final VilladexAnalysis analyzer;

  const VilladexPieChart({
    Key? key,
    required this.title,
    required this.analyzer,
  }) : super(key: key);

  @override
  State<VilladexPieChart> createState() => _VilladexPieChartState();
}

class _VilladexPieChartState extends State<VilladexPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final List<CategoryAnalysisDataPoint> result =
        widget.analyzer.getTopExpendituresByCategory(4);

    return Container(
      width: MediaQuery.of(context).size.width * .93,
      height: MediaQuery.of(context).size.height * .3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              widget.title,
              style: VilladexTextStyles().getSecondaryTextStyle(),
            ),
          ),
          Expanded(
            flex: 6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// Chart
                Expanded(
                  flex: 5,
                  child: PieChart(PieChartData(
                    pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        // If you did not touch a valid section of the pie chart
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        // if you did, which one did you touch?
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    }),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 0,
                    centerSpaceRadius: 40,
                    sections: _showingSections(result),
                  )),
                ),

                /// Indicators
                Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _indicator(
                          result[0].category, VilladexColors().pieChartOne),
                      const SizedBox(
                        height: 5,
                      ),
                      _indicator(
                          result[1].category, VilladexColors().pieChartTwo),
                      const SizedBox(
                        height: 5,
                      ),
                      _indicator(
                          result[2].category, VilladexColors().pieChartThree),
                      const SizedBox(
                        height: 5,
                      ),
                      _indicator(
                          result[3].category, VilladexColors().pieChartFour),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _showingSections(
      List<CategoryAnalysisDataPoint> result) {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: VilladexColors().pieChartOne,
            value: result[0].value,
            title: '\$${result[0].value.toStringAsFixed(2)}',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: VilladexColors().pieChartText),
          );
        case 1:
          return PieChartSectionData(
            color: VilladexColors().pieChartTwo,
            value: result[1].value,
            title: '\$${result[1].value.toStringAsFixed(2)}',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: VilladexColors().pieChartText),
          );
        case 2:
          return PieChartSectionData(
            color: VilladexColors().pieChartThree,
            value: result[2].value,
            title: '\$${result[2].value.toStringAsFixed(2)}',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: VilladexColors().pieChartText),
          );
        case 3:
          return PieChartSectionData(
            color: VilladexColors().pieChartFour,
            value: result[3].value,
            title: '\$${result[3].value.toStringAsFixed(2)}',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: VilladexColors().pieChartText),
          );
        default:
          throw Error();
      }
    });
  }

  Widget _indicator(String name, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// Color of the indicator
        Container(
          width: 20,
          height: 20,
          color: color,
        ),

        /// Name of the Indicator
        Text('   $name'),
      ],
    );
  }
}
