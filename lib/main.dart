import 'package:flutter/material.dart';

import 'package:villadex/Style/theme.dart' as villadex_theme;
import 'package:villadex/Routes/properties/properties.dart' as home;

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
      theme: villadex_theme.getTheme(),
      home: const HomePage(
        loadData: true,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final bool loadData;

  const HomePage({Key? key, this.loadData = false}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      /// Body
      body: home.PropertiesPage(
        loadData: true,
      ),
    );
  }
}
