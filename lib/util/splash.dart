import 'package:flutter/material.dart';

import '../routes/properties/properties.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final int duration = 1500; // Duration of splash screen in milliseconds

  @override
  void initState() {
    super.initState();
    _navigateHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text(
            "Splash Screen",
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }

  _navigateHome() async {
    await Future.delayed(Duration(milliseconds: duration));
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const PropertiesPage()));
  }
}
