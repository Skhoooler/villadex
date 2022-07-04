import 'package:flutter/material.dart';

import '../../../Style/colors.dart';
import '../../../Style/text_styles.dart';
import '../../../model/address_model.dart';
import '../../../model/property_model.dart';

class PropertyAddressForm extends StatefulWidget {
  final callback;

  const PropertyAddressForm({
    Key? key,
    required this.callback,
  }) : super(key: key);

  @override
  State<PropertyAddressForm> createState() => _PropertyAddressFormState();
}

class _PropertyAddressFormState extends State<PropertyAddressForm> {
  // Get data from text fields
  final _nameController = TextEditingController();
  final _streetAddress1Controller = TextEditingController();
  final _streetAddress2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  final _countryController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  //todo: Add ability to insert picture
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      color: VilladexColors().background,
      child: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// Add a new property
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12),
                  child: Text(
                    "Add a new Property",
                    style: VilladexTextStyles().getSecondaryTextStyle(),
                  ),
                ),

                /// Name of the Property
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please give the property a name";
                        //return 'Please enter a property name';
                      }
                      return null;
                    },
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    autocorrect: false,
                    cursorColor: VilladexColors().accent,
                    maxLines: 1,
                    decoration:
                        const InputDecoration(labelText: 'Property Name'),
                  ),
                ),

                /// Street Address 1
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an address';
                      }
                      return null;
                    },
                    controller: _streetAddress1Controller,
                    textCapitalization: TextCapitalization.words,
                    autocorrect: false,
                    cursorColor: VilladexColors().accent,
                    maxLines: 1,
                    decoration: const InputDecoration(
                      labelText: 'Street Address 1',
                    ),
                  ),
                ),

                /// Street Address 2
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12),
                  child: TextFormField(
                    validator: (value) {
                      return null;
                    },
                    controller: _streetAddress2Controller,
                    textCapitalization: TextCapitalization.words,
                    autocorrect: false,
                    cursorColor: VilladexColors().accent,
                    maxLines: 1,
                    decoration:
                        const InputDecoration(labelText: 'Street Address 2'),
                  ),
                ),

                /// City
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a city';
                      }
                      return null;
                    },
                    controller: _cityController,
                    textCapitalization: TextCapitalization.words,
                    autocorrect: false,
                    cursorColor: VilladexColors().accent,
                    maxLines: 1,
                    decoration: const InputDecoration(
                      labelText: 'City',
                    ),
                  ),
                ),

                /// State and Zip Code
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12),
                  child: Row(
                    children: [
                      /// State
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 6.0),
                          child: TextFormField(
                            validator: (value) {
                              return null;
                            },
                            controller: _stateController,
                            textCapitalization: TextCapitalization.characters,
                            autocorrect: false,
                            cursorColor: VilladexColors().accent,
                            maxLines: 1,
                            decoration: const InputDecoration(
                              labelText: 'State',
                            ),
                          ),
                        ),
                      ),

                      /// Zip
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 6.0),
                          child: TextFormField(
                            validator: (value) {
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            controller: _zipController,
                            autocorrect: false,
                            cursorColor: VilladexColors().accent,
                            maxLines: 1,
                            decoration: const InputDecoration(
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a country';
                      }
                      return null;
                    },
                    controller: _countryController,
                    textCapitalization: TextCapitalization.words,
                    autocorrect: false,
                    cursorColor: VilladexColors().accent,
                    maxLines: 1,
                    decoration: const InputDecoration(
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
                      bottom: MediaQuery.of(context).viewInsets.bottom + 6),
                  child: ElevatedButton(
                      child: const Text('Continue'),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          /// Create the property Object
                          Property property = Property(
                              name: _nameController.text,
                              owner: "Diana Doria",
                              // todo: Make this not hard coded
                              address: Address(
                                street1: _streetAddress1Controller.text,
                                street2: _streetAddress2Controller.text,
                                city: _cityController.text,
                                state: _stateController.text,
                                zip: _zipController.text,
                                country: _countryController.text,
                              ),
                              events: [],
                              expenditures: [],
                              associates: [],
                              earnings: []);

                          /// Clear the Text Controllers
                          _nameController.clear();
                          _streetAddress1Controller.clear();
                          _streetAddress2Controller.clear();
                          _cityController.clear();
                          _stateController.clear();
                          _zipController.clear();
                          _countryController.clear();

                          /// Set the state of the widget with a new PropertyListItem
                          widget.callback(property);

                        }
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Get rid of old controllers
  @override
  void dispose() {
    super.dispose();

    // Get rid of text controller when the widget is disposed
    _nameController.dispose();
    _streetAddress1Controller.dispose();
    _streetAddress2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _countryController.dispose();
  }
}
