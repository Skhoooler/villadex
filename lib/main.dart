import 'package:flutter/material.dart';

import 'package:villadex/Util/nav_bar.dart';
import 'package:villadex/Style/colors.dart';

void main() {
  runApp(const Villadex());
}

class Villadex extends StatelessWidget {
  const Villadex({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      /// Body
      body: Container(
        color: VillaDexColors().background,
        //child: //Text('Welcome Diana'),
      ),

      /// Bottom Navigation Bar
      bottomNavigationBar: const NavBar(),
    );
  }
}
