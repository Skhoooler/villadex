import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:villadex/Style/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../routes/properties/properties.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final int duration = 2000; // Duration of splash screen in milliseconds

  @override
  void initState() {
    super.initState();
    _navigateHome();
  }

  @override
  Widget build(BuildContext context) {
    const String logo = 'lib/res/villadexLogo.svg';
    double iconSize = MediaQuery.of(context).size.width * .25;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [VilladexColors().primary, VilladexColors().fadedPrimary],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(2, 2),
              stops: const [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Center(
          child: Wrap(
            direction: Axis.vertical,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 0,
            children: [
              SizedBox(
                width: iconSize,
                height: iconSize,
                child: SvgPicture.asset(
                  logo,
                  color: VilladexColors().background,
                  fit: BoxFit.fitHeight,
                ),
              ),
              Text(
                "Villadex",
                style: GoogleFonts.cormorantGaramond(
                  textStyle: TextStyle(
                      color: VilladexColors().background,
                      fontWeight: FontWeight.w300,
                      fontSize: 70),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .20,
              )
            ],
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
