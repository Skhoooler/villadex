import 'package:flutter/material.dart';

import 'package:villadex/Util/nav_bar.dart';
import 'package:villadex/Style/colors.dart';

class FinancesPage extends StatefulWidget {
  const FinancesPage({Key? key}) : super(key: key);

  @override
  State<FinancesPage> createState() => _FinancesPageState();
}

class _FinancesPageState extends State<FinancesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Body
      body: Container (
        color: VillaDexColors().accent,
      ),

      /// Bottom Nav Bar
      bottomNavigationBar: const NavBar(),
    );
  }

}