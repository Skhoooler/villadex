import 'package:flutter/material.dart';

import 'package:villadex/Util/nav_bar.dart';
import 'package:villadex/Style/colors.dart';

class PropertiesPage extends StatefulWidget {
  const PropertiesPage({Key? key}) : super(key: key);

  @override
  State<PropertiesPage> createState() => _PropertiesPageState();
}

class _PropertiesPageState extends State<PropertiesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Body
      body: Container (
        color: VillaDexColors().background,
      ),

      /// Bottom Nav Bar
      bottomNavigationBar: const NavBar(),
    );
  }

}