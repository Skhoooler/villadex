import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:villadex/Util/nav_bar.dart';
import 'package:villadex/routes/properties/forms/property_address_interactor.dart';
import '../../style/colors.dart';
import 'package:villadex/routes/properties/property_list_item.dart';

import 'package:villadex/model/database.dart' as db;
import 'package:villadex/model/property_model.dart';

List<Widget> _properties = [
  const Center(child: Text("Fetching properties from database..."))
];

class PropertiesPage extends StatefulWidget {
  // If loadData is true, load all properties from the database.
  // It is false by default
  final bool loadData;

  const PropertiesPage({
    Key? key,
    this.loadData = false,
  }) : super(key: key);

  @override
  State<PropertiesPage> createState() => _PropertiesPageState();
}

class _PropertiesPageState extends State<PropertiesPage> {
  @override
  void initState() {
    // Load all properties from the database only once, the first time
    // this widget is called.
    if (widget.loadData) {
      // Clear the _properties
      _properties = [const Center(child: Text("Fetching properties..."))];

      // Fetch the properties
      unawaited(
        db.DatabaseConnection.database.then((databaseConnection) {
          // Get data from the database
          try {
            Property.fetchAll().then((propertyList) {
              // Get rid of the "fetching properties message"
              _properties.removeAt(0);

              // Populate _properties with property data
              if (propertyList!.isNotEmpty) {
                for (var element in propertyList) {
                  if (element != null) {
                    _properties.add(PropertyListItem(property: element));
                  }
                }
              }
            });
          } catch (e) {
            // If an error occurs, add an error message to properties
            _properties.add(
              const Text(
                  "An Error has occurred loading data from the database"),
            );
          }
        }),
      );
    }
    super.initState();
  }

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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// Property List
                    Expanded(
                      flex: 8,
                      child: ListView.builder(
                          itemCount: _properties.length,
                          itemBuilder: (context, index) => _properties[index]),
                    ),

                    /// Add property modal
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: IconButton(
                            icon: Icon(
                              Icons.add_rounded,
                              color: VilladexColors().accent,
                              size: 40,
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
    setState(() {
      _properties.add(PropertyListItem(property: property));

      /// Add the property Item to the database
      property.insert();
      property.address.insert();

      /// Return to the main view
      Navigator.pop(context);
    });
  }
}
