import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'package:villadex/Util/nav_bar.dart';
import '../../style/colors.dart';
import 'package:villadex/routes/properties/property_list_item.dart';
import 'package:villadex/Style/text_styles.dart';

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
  final _streetAddress1Controller = TextEditingController();
  final _streetAddress2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  final _countryController = TextEditingController();

  // Get images from the user
  final _imagePicker = ImagePicker();

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
    final _formKey = GlobalKey<FormState>();

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
              child: Container(
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
                                    return Container(
                                      height: 500,
                                      color: VilladexColors().background,
                                      child: Center(
                                        child: SingleChildScrollView(
                                          child: Form(
                                            key: _formKey,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                /// Add a new property
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 6.0,
                                                      horizontal: 12),
                                                  child: Text(
                                                    "Add a new property",
                                                    style: VilladexTextStyles()
                                                        .getSecondaryTextStyle(),
                                                  ),
                                                ),

                                                /// Name of the Property
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 6.0,
                                                      horizontal: 12),
                                                  child: TextFormField(
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Please enter a property name';
                                                      }
                                                      return null;
                                                    },
                                                    controller: _nameController,
                                                    textCapitalization: TextCapitalization.words,
                                                    autocorrect: false,
                                                    cursorColor:
                                                        VilladexColors().accent,
                                                    maxLines: 1,
                                                    decoration:
                                                        const InputDecoration(
                                                            labelText:
                                                                'Property Name'),
                                                  ),
                                                ),

                                                /// Street Address 1
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 6.0,
                                                      horizontal: 12),
                                                  child: TextFormField(
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Please enter an address';
                                                      }
                                                      return null;
                                                    },
                                                    controller:
                                                        _streetAddress1Controller,
                                                    textCapitalization: TextCapitalization.words,
                                                    autocorrect: false,
                                                    cursorColor:
                                                        VilladexColors().accent,
                                                    maxLines: 1,
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText:
                                                          'Street Address',
                                                    ),
                                                  ),
                                                ),

                                                /// Street Address 2
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 6.0,
                                                      horizontal: 12),
                                                  child: TextFormField(
                                                    validator: (value) {
                                                      return null;
                                                    },
                                                    controller:
                                                        _streetAddress2Controller,
                                                    textCapitalization: TextCapitalization.words,
                                                    autocorrect: false,
                                                    cursorColor:
                                                        VilladexColors().accent,
                                                    maxLines: 1,
                                                    decoration:
                                                        const InputDecoration(
                                                            labelText:
                                                                'Street Address 2'),
                                                  ),
                                                ),

                                                /// City
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 6.0,
                                                      horizontal: 12),
                                                  child: TextFormField(
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Please enter a city';
                                                      }
                                                      return null;
                                                    },
                                                    controller: _cityController,
                                                    textCapitalization: TextCapitalization.words,
                                                    autocorrect: false,
                                                    cursorColor:
                                                        VilladexColors().accent,
                                                    maxLines: 1,
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText: 'City',
                                                    ),
                                                  ),
                                                ),

                                                /// State and Zip Code
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 6.0,
                                                      horizontal: 12),
                                                  child: Row(
                                                    children: [
                                                      /// State
                                                      Flexible(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 6.0),
                                                          child: TextFormField(
                                                            validator: (value) {
                                                              return null;
                                                            },
                                                            controller:
                                                                _stateController,
                                                            textCapitalization: TextCapitalization.characters,
                                                            autocorrect: false,
                                                            cursorColor:
                                                                VilladexColors()
                                                                    .accent,
                                                            maxLines: 1,
                                                            decoration:
                                                                const InputDecoration(
                                                              labelText:
                                                                  'State',
                                                            ),
                                                          ),
                                                        ),
                                                      ),

                                                      /// Zip
                                                      Flexible(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 6.0),
                                                          child: TextFormField(
                                                            validator: (value) {
                                                              return null;
                                                            },
                                                            keyboardType: TextInputType.number,
                                                            controller:
                                                                _zipController,
                                                            autocorrect: false,
                                                            cursorColor:
                                                                VilladexColors()
                                                                    .accent,
                                                            maxLines: 1,
                                                            decoration:
                                                                const InputDecoration(
                                                              labelText: 'Zip',
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                /// Country
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 6.0,
                                                      horizontal: 12),
                                                  child: TextFormField(
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Please enter a city';
                                                      }
                                                      return null;
                                                    },
                                                    controller:
                                                        _countryController,
                                                    textCapitalization: TextCapitalization.words ,
                                                    autocorrect: false,
                                                    cursorColor:
                                                        VilladexColors().accent,
                                                    maxLines: 1,
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText: 'Country',
                                                    ),
                                                  ),
                                                ),

                                                // Continue Button
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                    left: 6.0,
                                                    right: 6.0,
                                                    top: 6.0,
                                                    bottom:
                                                        MediaQuery.of(context)
                                                                .viewInsets
                                                                .bottom +
                                                            6,
                                                  ),
                                                  child: ElevatedButton(
                                                      child: const Text(
                                                          'Continue'),
                                                      onPressed: () {
                                                        if (_formKey
                                                            .currentState!
                                                            .validate()) {
                                                          /// Create the property Object
                                                          Property property =
                                                              Property(
                                                                  name:
                                                                      _nameController
                                                                          .text,
                                                                  owner:
                                                                      "Diana Doria",
                                                                  // todo: Make this not hard coded
                                                                  address: Address(
                                                                      street1:
                                                                          _streetAddress1Controller
                                                                              .text,
                                                                      street2:
                                                                          _streetAddress2Controller
                                                                              .text,
                                                                      city: _cityController
                                                                          .text,
                                                                      state: _stateController
                                                                          .text,
                                                                      zip: _zipController
                                                                          .text,
                                                                      country:
                                                                          _countryController
                                                                              .text),
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
                                                            _properties.add(
                                                                PropertyListItem(
                                                              property:
                                                                  property,
                                                            ));
                                                          });

                                                          /// Clear the Text Controllers
                                                          _nameController
                                                              .clear();
                                                          _streetAddress1Controller
                                                              .clear();
                                                          _streetAddress2Controller
                                                              .clear();
                                                          _cityController
                                                              .clear();
                                                          _stateController
                                                              .clear();
                                                          _zipController
                                                              .clear();
                                                          _countryController
                                                              .clear();

                                                          // Return to the main view
                                                          Navigator.pop(
                                                              context);
                                                        }
                                                      }),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
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
    _streetAddress1Controller.dispose();
    _streetAddress2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _countryController.dispose();

    super.dispose();
  }
}
