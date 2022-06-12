import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marquee/marquee.dart';

import 'package:villadex/Util/nav_bar.dart';
import 'package:villadex/model/property_model.dart';
import 'package:villadex/style/colors.dart';
import 'package:villadex/style/text_styles.dart';

import 'property_menu_widget.dart';

class PropertyPage extends StatelessWidget {
  const PropertyPage({Key? key, required this.propertyData}) : super(key: key);

  final Property propertyData;

  @override
  Widget build(BuildContext context) {
    const String assetName = 'lib/res/default_house.svg';
    final String fullAddress = propertyData.address.fullAddress;

    return Scaffold(
      // https://www.youtube.com/watch?v=jgGRTC2Uruo - Flutter - How To Scroll Animate An Image Into an App Bar (CustomScrollView Widget)
      body: CustomScrollView(
        slivers: [
          /// Image and App Bar
          SliverAppBar(
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
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
                        decelerationDuration:
                            const Duration(milliseconds: 3000),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            automaticallyImplyLeading: false,

            /// Other Options for the app bar
            backgroundColor: VillaDexColors().background,
            expandedHeight: MediaQuery.of(context).size.height * .35,
            floating: true,
            forceElevated: true,
            snap: true,
            elevation: 15,
          ),

          /// Main Content on the page
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  height: 1000,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: VillaDexColors().background,
                  ),
                  child: Column(
                    children: const [
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      /// Bottom Nav Bar
      bottomNavigationBar: const NavBar(),
      floatingActionButton: const PropertyMenu(),
    );
  }
}
