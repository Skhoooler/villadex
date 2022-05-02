import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      body: Container(
        color: VillaDexColors().background,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [

            /// Spacing
            const SizedBox(height: 45,),

            /// Welcome Sign
            Expanded(
              flex: 2,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  'Welcome, Diana',
                  textAlign: TextAlign.center,
                  textScaleFactor: 2.0,
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      color: VillaDexColors().accent,
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
            ),

            /// Properties
            Expanded(
              flex: 11,
              child: Container(
                width: MediaQuery.of(context).size.width * .93,
                color: VillaDexColors().accent,
              ),
            ),

            /// Spacing
            const SizedBox(height: 10,)
          ],
        ),
      ),

      /// Bottom Nav Bar
      bottomNavigationBar: const NavBar(),
    );
  }
}
