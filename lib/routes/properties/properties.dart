import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:villadex/Util/nav_bar.dart';
import 'package:villadex/routes/properties/forms/property_address_interactor.dart';
import '../../style/colors.dart';
import 'package:villadex/routes/properties/property_list_item.dart';

import 'package:villadex/model/property_model.dart';

class PropertiesPage extends StatefulWidget {
  const PropertiesPage({
    Key? key,
  }) : super(key: key);

  @override
  State<PropertiesPage> createState() => _PropertiesPageState();
}

class _PropertiesPageState extends State<PropertiesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Body
      body: Container(
        color: VilladexColors().background,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            /// Spacing
            const SizedBox(
              height: 45,
            ),

            /// Welcome Sign
            Expanded(
              flex: 2,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  'Welcome, Diana',
                  textAlign: TextAlign.center,
                  textScaleFactor: 2.0,
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      color: VilladexColors().accent,
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
                color: VilladexColors().background,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    /// Property List
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .95,
                      height: MediaQuery.of(context).size.height * .6,
                      child: FutureBuilder<List<Property?>?>(
                          future: Property.fetchAll(),
                          builder: (context, snapshot) {
                            List<Widget> data = [];

                            /// If there are properties in the database
                            if (snapshot.hasData) {
                              data = snapshot.data?.map((property) {
                                    return PropertyListItem(
                                      property: property!,
                                      callback: reload,
                                    );
                                  }).toList() ??
                                  [];

                              /// If you are waiting for the properties to fetch
                            } else {
                              data = [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * .2,
                                  height: MediaQuery.of(context).size.height * .2,
                                  child: CircularProgressIndicator(
                                    color: VilladexColors().primary,
                                  ),
                                )
                              ];
                            }
                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return data[index];
                                });
                          }),
                    ),


                    /// Add property pop up modal
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: IconButton(
                            icon: Icon(
                              Icons.add_rounded,
                              color: VilladexColors().accent,
                              size: 50,
                            ),
                            onPressed: () {
                              showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return PropertyAddressForm(
                                      callback: _setProperty,
                                    );
                                  });
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// Spacing
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),

      /// Bottom Nav Bar
      bottomNavigationBar: const NavBar(),
    );
  }

  /// Gets the Property from the PropertyAddressInteractor child widget
  _setProperty(Property property) {
    /// Add the property Item to the database
    property.insert();
    property.address.insert();

    setState(() {});

    /// Return to the main view
    Navigator.pop(context);
  }

  /// Reset the page
  void reload() {
    setState(() {});
  }
}
