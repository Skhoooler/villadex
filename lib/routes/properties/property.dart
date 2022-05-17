import 'package:flutter/material.dart';

import 'package:villadex/Util/nav_bar.dart';
import 'package:villadex/Style/colors.dart';

class Property extends StatelessWidget {
  const Property({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //body: ,

      /// Bottom Nav Bar
      bottomNavigationBar: const NavBar(),
    );
  }
}