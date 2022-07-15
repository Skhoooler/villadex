import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  String selectedIntervalName = "Weekly";
  DataInterval selectedInterval = DataInterval.weekly;

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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * .95,
                  height: MediaQuery.of(context).size.height * .8,
                  child: FutureBuilder<VilladexAnalysis>(
                    future: VilladexAnalysis.create(),
                    builder: (context, snapshot) {
                      List<Widget> data = [];

                      if (snapshot.hasData) {
                        DateTime end = DateTime.now();
                        DateTime start = end.subtract(Duration(
                            days: snapshot.data!
                                .setIntervalDays(selectedInterval)));

                        data = [
                          /// Dates and Interval Selector
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              /// Dates
                              Center(
                                child: Text(
                                  "${DateFormat.yMMMd("en_US").format(DateTime.now().subtract(Duration(days: snapshot.data!.setIntervalDays(selectedInterval)))).toString()}   -   ${DateFormat.yMMMd("en_US").format(DateTime.now()).toString()}",
                                  style: VilladexTextStyles()
                                      .getSecondaryTextStyle(),
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
                            ],
                          ),

                          /// Pie Charts
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * .30,
                            child: ListView(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              children: [
                                /// Show Pie Chart
                                chart.VilladexPieChart(
                                  title: "Top Expenses by Category",
                                  analyzer: snapshot.data!,
                                  earningMode: false,
                                  start: start,
                                  end: end,
                                ),

                                /// Show Pie Chart
                                chart.VilladexPieChart(
                                  title: "Top Earnings by Category",
                                  analyzer: snapshot.data!,
                                  earningMode: true,
                                  start: start,
                                  end: end,
                                ),
                              ],
                            ),
                          ),

                          /// Statistics
                          Center(
                            child: VilladexStatistics(
                              analyzer: snapshot.data!,
                              start: start,
                              end: end,
                              selectedInterval: selectedInterval,
                            ),
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
