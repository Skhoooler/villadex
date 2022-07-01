// Returns a form for adding an earning
import 'package:flutter/material.dart';
import 'package:villadex/Style/text_styles.dart';
import 'package:villadex/model/address_model.dart';
import 'package:villadex/model/event_model.dart';
import '../../../style/colors.dart';
import 'date_selector.dart';

class EventForm extends StatefulWidget {
  final int propertyKey;

  const EventForm({Key? key, required this.propertyKey}) : super(key: key);

  @override
  State<EventForm> createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  final _streetAddress1Controller = TextEditingController();
  final _streetAddress2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  final _countryController = TextEditingController();

  //Address _address = Address(street1: "None", city: "None", country: "None");
  DateTime _date = DateTime.now();

  final _formKey = GlobalKey<FormState>();

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
                /// Add a new Event Title
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 6.0, horizontal: 12.0),
                  child: Text(
                    "Add a new Event",
                    style: VilladexTextStyles().getSecondaryTextStyle(),
                  ),
                ),

                /// Add a Name and a Date
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// Add a name
                    Flexible(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6.0, horizontal: 12),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please give the event a title';
                            }
                            return null;
                          },
                          controller: _nameController,
                          textCapitalization: TextCapitalization.words,
                          autocorrect: false,
                          cursorColor: VilladexColors().accent,
                          maxLines: 1,
                          decoration:
                              const InputDecoration(labelText: 'Event Title'),
                        ),
                      ),
                    ),

                    /// Add a date
                    Flexible(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6.0, horizontal: 12.0),
                        child: DateSelector(
                          callback: _setDateTime,
                        ),
                      ),
                    )
                  ],
                ),

                /// Add a Description
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        value = "";
                      }
                      return null;
                    },
                    controller: _descriptionController,
                    textCapitalization: TextCapitalization.sentences,
                    autocorrect: true,
                    cursorColor: VilladexColors().accent,
                    maxLines: 3,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                ),

                /// Address
                /// Street Address 1
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12),
                  child: TextFormField(
                    validator: (value) {
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

                /// Continue Button
                Padding(
                  padding: EdgeInsets.only(
                      left: 6.0,
                      right: 6.0,
                      top: 6.0,
                      bottom: MediaQuery.of(context).viewInsets.bottom + 6),
                  child: ElevatedButton(
                    child: const Text('Continue'),
                    onPressed: (() {
                      if (_formKey.currentState!.validate()) {
                        /// Insert event into database
                        Event(
                                name: _nameController.text,
                                description: _descriptionController.text,
                                date: _date,
                                address: Address(
                                  street1: _streetAddress1Controller.text,
                                  street2: _streetAddress2Controller.text,
                                  city: _cityController.text,
                                  state: _stateController.text,
                                  zip: _zipController.text,
                                  country: _countryController.text,
                                ),
                                propertyKey: widget.propertyKey)
                            .insert();

                        /// Clear old controllers
                        _nameController.clear();
                        _descriptionController.clear();

                        _streetAddress1Controller.clear();
                        _streetAddress2Controller.clear();
                        _cityController.clear();
                        _stateController.clear();
                        _zipController.clear();
                        _countryController.clear();

                        /// Return to previous screen
                        Navigator.pop(context);
                      }
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Gets the DateTime from the DateSelector child widget
  _setDateTime(DateTime dateSelected) {
    setState(() {
      _date = dateSelected;
    });
  }

  /// Get rid of controllers
  @override
  void dispose() {
    super.dispose();

    _nameController.dispose();
    _descriptionController.dispose();

    _streetAddress1Controller.dispose();
    _streetAddress2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _countryController.dispose();
  }
}
