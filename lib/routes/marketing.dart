import 'package:flutter/material.dart';

import 'package:villadex/Util/nav_bar.dart';
import 'package:villadex/Style/colors.dart';

class MarketingPage extends StatefulWidget {
  const MarketingPage({Key? key}) : super(key: key);

  @override
  State<MarketingPage> createState() => _MarketingPageState();
}

class _MarketingPageState extends State<MarketingPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Body
      body: Container(
        color: VilladexColors().background,
        child: Column(
          children: [
          ],
        ),
      ),

      /// Bottom Nav Bar
      bottomNavigationBar: const NavBar(),
    );
  }
}
