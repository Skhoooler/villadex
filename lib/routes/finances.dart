import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:villadex/Util/nav_bar.dart';
import 'package:villadex/Style/colors.dart';
import 'package:villadex/Util/Finances/pie_chart.dart' as chart;

class FinancesPage extends StatefulWidget {
  const FinancesPage({Key? key}) : super(key: key);

  @override
  State<FinancesPage> createState() => _FinancesPageState();
}

class _FinancesPageState extends State<FinancesPage> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Body
      body: Container(
        color: VillaDexColors().background,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Spacing
            const SizedBox(
              height: 10,
            ),

            /// Pie Chart
            const Expanded(
              flex: 8,
              child: chart.VilladexPieChart(title: 'Expenses',
              ),
            ),

            /// Other
            Expanded(
              flex: 14,
              child: Container(
                width: MediaQuery.of(context).size.width * .93,
                color: Colors.blue,
              ),
            ),

            /// Spacing

            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),

      /// Bottom Nav Bar
      bottomNavigationBar: const NavBar(),
    );
  }

  /// Generates a list of sections to put in the pie chart
  List<PieChartSectionData> showingSections() {
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
}
