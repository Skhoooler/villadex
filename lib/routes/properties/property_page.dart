import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marquee/marquee.dart';

import 'package:villadex/Util/nav_bar.dart';
import 'package:villadex/model/property_model.dart';
import 'package:villadex/routes/properties/menu%20options/delete_property.dart';
import 'package:villadex/routes/properties/menu%20options/edit_property_attributes.dart';
import 'package:villadex/routes/properties/menu%20options/generate_report_options.dart';
import 'package:villadex/style/colors.dart';
import 'package:villadex/style/text_styles.dart';

import 'main page widgets/main_expenditures.dart';
import 'main page widgets/profits.dart';
import 'main page widgets/unpaid_expenditures.dart';

import 'property_menu_widget.dart';

/// Menu items
enum Menu { editProperty, deleteProperty, createReport }

class PropertyPage extends StatefulWidget {
  final Property property;

  const PropertyPage({Key? key, required this.property}) : super(key: key);

  @override
  State<PropertyPage> createState() => _PropertyPageState();
}

class _PropertyPageState extends State<PropertyPage> {
  @override
  Widget build(BuildContext context) {
    const String assetName = 'lib/res/default_house.svg';
    final String fullAddress = widget.property.address.fullAddress;

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
                  SizedBox(
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          /// Back Button
                          IconButton(
                            iconSize: 35,
                            color: VilladexColors().accent,
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
                            widget.property.name,
                            style: VilladexTextStyles().getSecondaryTextStyle(),
                          ),

                          /// Set it to be on the other side of the screen
                          const Spacer(),

                          /// Menu
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: PopupMenuButton<Menu>(
                              color: VilladexColors().background,
                              icon: Icon(
                                Icons.menu,
                                color: VilladexColors().accent,
                              ),
                              iconSize: 35,
                              onSelected: (Menu item) {
                                setState(() {
                                  /// Edit Property
                                  if (item == Menu.editProperty) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditPropertyAttributes(
                                          propertyId: widget.property.key,
                                          name: widget.property.name,
                                        ),
                                      ),
                                    );

                                    /// Create Report
                                  } else if (item == Menu.createReport) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                GenerateReportOptions(
                                                  property: widget.property,
                                                )));

                                    /// Delete Property
                                  } else if (item == Menu.deleteProperty) {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return DeleteProperty(
                                            propertyKey: widget.property.key,
                                          );
                                        });
                                  }
                                });
                              },
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<Menu>>[
                                const PopupMenuItem<Menu>(
                                  value: Menu.editProperty,
                                  child: Text("Edit Property"),
                                ),
                                const PopupMenuItem<Menu>(
                                  value: Menu.createReport,
                                  child: Text("Create Report"),
                                ),
                                PopupMenuItem(
                                  value: Menu.deleteProperty,
                                  child: Text(
                                    "Delete Property",
                                    style: TextStyle(
                                        color: VilladexColors().error),
                                  ),
                                )
                              ],
                            ),
                          ),
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
            backgroundColor: VilladexColors().background,
            expandedHeight: MediaQuery.of(context).size.height * .35,
            floating: false,
            forceElevated: true,
            snap: false,
            pinned: false,
            elevation: 0,
          ),

          /// Main Content on the page
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  color: VilladexColors().background,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Profits(
                          property: widget.property,
                        ),
                        UnpaidExpenditures(
                          property: widget.property,
                        ),
                        MainExpenditures(
                          property: widget.property,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),

      /// Bottom Nav Bar
      bottomNavigationBar: const NavBar(),
      floatingActionButton: PropertyMenu(
        propertyKey: widget.property.key,
      ),
    );
  }
}
