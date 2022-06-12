import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:xen_popup_card/xen_card.dart';
import 'package:image_picker/image_picker.dart';

import 'package:villadex/Util/nav_bar.dart';
import 'package:villadex/Style/colors.dart';
import 'package:villadex/routes/properties/property_list_item.dart';

import 'package:villadex/model/database.dart' as db;
import 'package:villadex/model/property_model.dart';
import 'package:villadex/model/address_model.dart';

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
  // Get data from text fields
  final _nameController = TextEditingController();
  final _streetAddressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  final _countryController = TextEditingController();

  // Get images from the user
  final _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    // Load all properties from the database only once, the first time
    // this widget is called.
    // Todo: Fix duplicating property bug
    if (widget.loadData) {
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

    return Scaffold(
      /// Body
      body: Container(
        color: VillaDexColors().background,
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
                color: VillaDexColors().background,
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

                    /// Add property
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: IconButton(
                          icon: Icon(
                            Icons.add_rounded,
                            color: VillaDexColors().accent,
                            size: 40,
                          ),
                          onPressed: () => showDialog(
                            context: context,
                            builder: (builder) => XenPopupCard(
                              borderRadius: 32,
                              cardBgColor: VillaDexColors().background,

                              /// Body
                              body: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  /// Image of the Property
                                  Container(
                                      /*child: imageFile == null
                                      ? Container(

                                    ),*/
                                      ),

                                  /// Name of the Property
                                  TextFormField(
                                    controller: _nameController,
                                    autocorrect: false,
                                    cursorColor: VillaDexColors().accent,
                                    maxLines: 1,
                                    decoration: const InputDecoration(
                                        labelText: 'Property Name'),
                                  ),

                                  const SizedBox(
                                    height: 15,
                                  ),

                                  /// Street Address
                                  TextFormField(
                                    controller: _streetAddressController,
                                    autocorrect: false,
                                    cursorColor: VillaDexColors().accent,
                                    maxLines: 1,
                                    decoration: const InputDecoration(
                                      labelText: 'Street Address',
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 15,
                                  ),

                                  /// City
                                  TextFormField(
                                    controller: _cityController,
                                    autocorrect: false,
                                    cursorColor: VillaDexColors().accent,
                                    maxLines: 1,
                                    decoration: const InputDecoration(
                                      labelText: 'City',
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 15,
                                  ),

                                  Row(
                                    children: [
                                      /// State
                                      Flexible(
                                        child: TextFormField(
                                          controller: _stateController,
                                          autocorrect: false,
                                          cursorColor: VillaDexColors().accent,
                                          maxLines: 1,
                                          decoration: const InputDecoration(
                                            labelText: 'State',
                                          ),
                                        ),
                                      ),

                                      const SizedBox(
                                        width: 30,
                                      ),

                                      /// Zip
                                      Flexible(
                                        child: TextFormField(
                                          controller: _zipController,
                                          autocorrect: false,
                                          cursorColor: VillaDexColors().accent,
                                          maxLines: 1,
                                          decoration: const InputDecoration(
                                            labelText: 'Zip',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(
                                    height: 15,
                                  ),

                                  /// Country
                                  TextFormField(
                                    controller: _countryController,
                                    autocorrect: false,
                                    cursorColor: VillaDexColors().accent,
                                    maxLines: 1,
                                    decoration: const InputDecoration(
                                      labelText: 'Country',
                                    ),
                                  ),
                                ],
                              ),

                              /// Gutter
                              gutter: XenCardGutter(
                                shadow: const BoxShadow(spreadRadius: 0),
                                borderRadius: 32,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 200,

                                      /// Continue Button
                                      child: ElevatedButton(
                                        onPressed: () {
                                          /// Create the property Object
                                          Property property = Property(
                                              name: _nameController.text,
                                              owner: "Diana Doria",
                                              // todo: Make this not hard coded
                                              address: Address(
                                                  street1:
                                                      _streetAddressController
                                                          .text,
                                                  city: _cityController.text,
                                                  state: _stateController.text,
                                                  zip: _zipController.text,
                                                  country:
                                                      _countryController.text),
                                              events: [],
                                              expenditures: [],
                                              associates: [],
                                              earnings: []);

                                          /// Add the property Item to the database
                                          property.insert();
                                          property.address.insert();

                                          /// Set the state of the widget with a new PropertyListItem
                                          setState(() {
                                            // Add the entry to the _properties list
                                            _properties.add(PropertyListItem(
                                              property: property,
                                            ));
                                          });

                                          /// Clear the Text Controllers
                                          _nameController.clear();
                                          _streetAddressController.clear();
                                          _cityController.clear();
                                          _stateController.clear();
                                          _zipController.clear();
                                          _countryController.clear();

                                          // Return to the main view
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Continue'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
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

  _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery, maxHeight: 1800, maxWidth: 1800);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
    }
  }

  /// Get rid of old controllers
  @override
  void dispose() {
    // Get rid of text controller when the widget is disposed
    _nameController.dispose();
    _streetAddressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _countryController.dispose();

    super.dispose();
  }
}
