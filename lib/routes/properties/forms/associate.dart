// Returns a form for adding an earning
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

import 'package:villadex/Style/text_styles.dart';
import 'package:villadex/model/address_model.dart';
import 'package:villadex/model/associate_model.dart';
import 'package:villadex/model/contact_model.dart';
import '../../../style/colors.dart';

class AssociateForm extends StatefulWidget {
  final int propertyKey;

  const AssociateForm({Key? key, required this.propertyKey}) : super(key: key);

  @override
  State<AssociateForm> createState() => _AssociateFormState();
}

class _AssociateFormState extends State<AssociateForm> {
  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final _streetAddress1Controller = TextEditingController();
  final _streetAddress2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  final _countryController = TextEditingController();

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
                /// Add a new Associate Title
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 6.0, horizontal: 12.0),
                  child: Text(
                    "Add a new Associate",
                    style: VilladexTextStyles().getSecondaryTextStyle(),
                  ),
                ),

                /// Name of the person
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12),
                  child: Row(
                    children: [
                      /// First Name
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 3.0),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please give this person a first name';
                              }
                              return null;
                            },
                            controller: _firstNameController,
                            textCapitalization: TextCapitalization.words,
                            autocorrect: false,
                            cursorColor: VilladexColors().accent,
                            maxLines: 1,
                            decoration:
                                const InputDecoration(labelText: 'First Name'),
                          ),
                        ),
                      ),

                      /// Middle Name
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 3.0, right: 3.0),
                          child: TextFormField(
                            validator: (value) {
                              return null;
                            },
                            controller: _middleNameController,
                            textCapitalization: TextCapitalization.words,
                            autocorrect: false,
                            cursorColor: VilladexColors().accent,
                            maxLines: 1,
                            decoration:
                                const InputDecoration(labelText: 'Middle Name'),
                          ),
                        ),
                      ),

                      /// Last Name
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 3.0),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please give this person a last name';
                              }
                              return null;
                            },
                            controller: _lastNameController,
                            textCapitalization: TextCapitalization.words,
                            autocorrect: false,
                            cursorColor: VilladexColors().accent,
                            maxLines: 1,
                            decoration:
                                const InputDecoration(labelText: 'Last Name'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                /// Email
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12),
                  child: TextFormField(
                    validator: (value) {
                      if (value != null) {
                        if (value.isNotEmpty && !EmailValidator.validate(value)) {
                          return "Please enter a valid email";
                        }
                      }
                      return null;
                    },
                    controller: _emailController,
                    textCapitalization: TextCapitalization.none,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    cursorColor: VilladexColors().accent,
                    maxLines: 1,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                ),

                /// Phone Number
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12),
                  child: TextFormField(
                    validator: (value) {
                      return null;
                    },
                    controller: _phoneController,
                    textCapitalization: TextCapitalization.none,
                    keyboardType: TextInputType.phone,
                    autocorrect: false,
                    cursorColor: VilladexColors().accent,
                    maxLines: 1,
                    decoration:
                        const InputDecoration(labelText: 'Phone Number'),
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
                      // todo: Make Address be a popup alertDialog
                      if (_formKey.currentState!.validate()) {
                        Associate associate = Associate(
                          firstName: _firstNameController.text,
                          middleName: _middleNameController.text,
                          lastName: _lastNameController.text,
                          contact: Contact(
                            email: _emailController.text,
                            phoneNumber: _phoneController.text,
                            address: Address(
                              street1: _streetAddress1Controller.text,
                              street2: _streetAddress2Controller.text,
                              city: _cityController.text,
                              state: _stateController.text,
                              zip: _zipController.text,
                              country: _countryController.text,
                            ),
                          ),
                          propertyKey: widget.propertyKey,
                        );

                        /// Insert associate into database
                        associate.insert();

                        /// Clear the Text Controllers
                        _firstNameController.clear();
                        _middleNameController.clear();
                        _lastNameController.clear();
                        _emailController.clear();
                        _phoneController.clear();

                        _streetAddress1Controller.clear();
                        _streetAddress2Controller.clear();
                        _cityController.clear();
                        _stateController.clear();
                        _zipController.clear();
                        _countryController.clear();

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

  /// Get rid of controllers
  @override
  void dispose() {
    super.dispose();

    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();

    _streetAddress1Controller.dispose();
    _streetAddress2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _countryController.dispose();
  }
}
