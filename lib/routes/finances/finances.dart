import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:villadex/Util/nav_bar.dart';
import 'package:villadex/routes/finances/statistics.dart';
import 'package:villadex/util/analysis.dart';
import '../../Style/text_styles.dart';
import '../../style/colors.dart';
import 'pie_chart.dart' as chart;

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
        color: VilladexColors().background,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 15,
            ),
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

                /// Title
                Text(
                  "Finances",
                  style: VilladexTextStyles().getSecondaryTextStyle(),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                width: MediaQuery.of(context).size.width * .95,
                height: MediaQuery.of(context).size.height * .8,
                child: FutureBuilder<VilladexAnalysis>(
                  future: VilladexAnalysis.create(),
                  builder: (context, snapshot) {
                    List<Widget> data = [];

                    if (snapshot.hasData) {
                      data = [
                        /// Show Pie Chart
                        chart.VilladexPieChart(
                          title: "Expenses by Category",
                          analyzer: snapshot.data!,
                        ),

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

                        Center(
                            child:
                                VilladexStatistics(analyzer: snapshot.data!)),

                        Container(
                          width: MediaQuery.of(context).size.width * .93,
                          height: MediaQuery.of(context).size.height * 1,
                          color: Colors.blue,
                        ),
                      ];
                    }
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return data[index];
                        });
                  },
                ),
              ),
            ),
          ],
        ),
      ),

      backgroundColor: VilladexColors().background,

      /// Bottom Nav Bar
      bottomNavigationBar: const NavBar(),
    );
  }
}
