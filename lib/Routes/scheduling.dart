import 'package:flutter/material.dart';

import 'package:villadex/Util/calendar.dart';
import 'package:villadex/Util/nav_bar.dart';
import 'package:villadex/Style/colors.dart';

class SchedulingPage extends StatefulWidget {
  const SchedulingPage({Key? key}) : super(key: key);

  @override
  State<SchedulingPage> createState() => _SchedulingPageState();
}

class _SchedulingPageState extends State<SchedulingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Body
      body: Container (
        color: VillaDexColors().background,
        child: Column(
          children: const [
            VilladexCalendar(

            )
          ],
        ),
      ),

      /// Bottom Nav Bar
      bottomNavigationBar: const NavBar(),
    );
  }

}