import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marquee/marquee.dart';

import 'package:villadex/Util/nav_bar.dart';
import 'package:villadex/model/property_model.dart';
import 'package:villadex/style/colors.dart';
import 'package:villadex/routes/properties/info_page.dart';
import 'package:villadex/style/text_styles.dart';

class PropertyPage extends StatelessWidget {
  const PropertyPage({Key? key, required this.propertyData}) : super(key: key);

  final Property propertyData;

  @override
  Widget build(BuildContext context) {
    const String assetName = 'lib/res/default_house.svg';
    final String fullAddress = propertyData.address.fullAddress;

    return Scaffold(
      body: Container(
        color: VillaDexColors().background,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            /// Image, Name and Address
            Stack(
              children: [
                /// Image
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * .35,
                  child: SvgPicture.asset(assetName, fit: BoxFit.fitWidth),
                ),

                /// Name and Back Button
                Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        /// Back Button
                        IconButton(
                          iconSize: 35,
                          color: VillaDexColors().accent,
                          icon: const Icon(
                            Icons.arrow_back,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),

                        const SizedBox(
                          width: 10,
                        ),

                        /// Property Name
                        Text(
                          propertyData.name,
                          style: VilladexTextStyles().getSecondaryTextStyle(),
                        )
                      ],
                    ),
                  ],
                ),

                /// Address
                Positioned(
                  top: MediaQuery.of(context).size.height * .315,
                  child: SizedBox(
                    height: 30,
                    width: MediaQuery.of(context).size.width,
                    child: Marquee(
                      text: fullAddress,
                      style: VilladexTextStyles().getTertiaryTextStyle(),
                      blankSpace: 50,
                      velocity: 30,
                      pauseAfterRound: const Duration(milliseconds: 15000),
                      decelerationCurve: Curves.decelerate,
                      decelerationDuration: const Duration(milliseconds: 3000),
                    ),
                  ),
                ),
              ],
            ),

            /// Rest of Page
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// Recents
                  Container(
                    width: MediaQuery.of(context).size.width * .9,
                    height: MediaQuery.of(context).size.height * .50,
                    margin: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: VillaDexColors().accent,
                      borderRadius: const BorderRadius.all(Radius.circular(25)),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          InfoPage(),
                          InfoPage(),
                          InfoPage(),
                          Container(
                            color: Colors.red,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      /// Bottom Nav Bar
      bottomNavigationBar: const NavBar(),
    );
  }
}
