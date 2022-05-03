/// This code was initially taken from the fl_chart documentation
/// https://github.com/imaNNeoFighT/fl_chart/blob/master/example/lib/pie_chart/samples/indicator.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:villadex/Style/colors.dart';

class VilladexPieChart extends StatefulWidget {
  const VilladexPieChart({Key? key, required this.title}) : super(key: key);

  final String title;
  @override
  State<VilladexPieChart> createState() => _VilladexPieChartState();
}

class _VilladexPieChartState extends State<VilladexPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      //width: MediaQuery.of(context).size.width * .93,
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
                  touchedIndex =
                      pieTouchResponse.touchedSection!.touchedSectionIndex;
                });
              }),
              borderData: FlBorderData(
                show: false,
              ),
              sectionsSpace: 0,
              centerSpaceRadius: 40,
              sections: _showingSections(),
            )),
          ),

          /// Indicators
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _indicator('Expense 1', VillaDexColors().pieChartOne),
                const SizedBox(height: 5,),
                _indicator('Expense 2', VillaDexColors().pieChartTwo),
                const SizedBox(height: 5,),
                _indicator('Expense 3', VillaDexColors().pieChartThree),
                const SizedBox(height: 5,),
                _indicator('Expense 4', VillaDexColors().pieChartFour),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: VillaDexColors().pieChartOne,
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: VillaDexColors().pieChartText),
          );
        case 1:
          return PieChartSectionData(
            color: VillaDexColors().pieChartTwo,
            value: 30,
            title: '30%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: VillaDexColors().pieChartText),
          );
        case 2:
          return PieChartSectionData(
            color: VillaDexColors().pieChartThree,
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: VillaDexColors().pieChartText),
          );
        case 3:
          return PieChartSectionData(
            color: VillaDexColors().pieChartFour,
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: VillaDexColors().pieChartText),
          );
        default:
          throw Error();
      }
    });
  }

  Widget _indicator( String name, Color color ) {
    return Container(
      child: Row(
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
      ),
    );
  }
}
