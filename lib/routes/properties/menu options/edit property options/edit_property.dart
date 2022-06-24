import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../Style/colors.dart';
import '../../../../Style/text_styles.dart';
import '../../../../Util/nav_bar.dart';
import '../../../../model/address_model.dart';
import '../../../../model/property_model.dart';
import '../../properties.dart';

class EditProperty extends StatefulWidget {
  final int propertyId;
  final String name;

  const EditProperty({
    required this.propertyId,
    required this.name,
    Key? key,
  }) : super(key: key);

  @override
  State<EditProperty> createState() => _EditPropertyState();
}

class _EditPropertyState extends State<EditProperty> {
  late final Property property;
  bool fetch = true;

  // Get data from text fields
  final _nameController = TextEditingController();
  final _streetAddress1Controller = TextEditingController();
  final _streetAddress2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  final _countryController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  //todo: Add ability to edit picture
  final String assetName = 'lib/res/default_house.svg';

  @override
  Widget build(BuildContext context) {
    loadPropertyData();

    return Scaffold(
      body: Container(
        color: VilladexColors().background,
        child: CustomScrollView(
          slivers: [
            /// Back button and Name
            SliverAppBar(
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    /// Image
                    GestureDetector(
                      onTap: () {
                        // todo: Edit image
                      },
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * .35,
                        child: SvgPicture.asset(
                          assetName,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),

                    /// Name and back button
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

                            /// Page Name
                            Text(
                              "Edit ${widget.name}",
                              style:
                                  VilladexTextStyles().getSecondaryTextStyle(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              automaticallyImplyLeading: false,

              /// Other Options for the app bar
              backgroundColor: VilladexColors().background,
              expandedHeight: MediaQuery.of(context).size.height * .35,
              floating: true,
              forceElevated: true,
              snap: true,
              elevation: 0,
            ),

            /// Main Content
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    //height: 1000,
                    width: MediaQuery.of(context).size.width,
                    color: VilladexColors().background,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          /// Name of the Property
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6.0, horizontal: 12),
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
                              decoration: const InputDecoration(
                                  labelText: 'Property Name'),
                            ),
                          ),

                          /// Street Address 1
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6.0, horizontal: 12),
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
                            padding: const EdgeInsets.symmetric(
                                vertical: 6.0, horizontal: 12),
                            child: TextFormField(
                              validator: (value) {
                                return null;
                              },
                              controller: _streetAddress2Controller,
                              textCapitalization: TextCapitalization.words,
                              autocorrect: false,
                              cursorColor: VilladexColors().accent,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                  labelText: 'Street Address 2'),
                            ),
                          ),

                          /// City
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6.0, horizontal: 12),
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
                            padding: const EdgeInsets.symmetric(
                                vertical: 6.0, horizontal: 12),
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
                                      textCapitalization:
                                          TextCapitalization.characters,
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
                            padding: const EdgeInsets.symmetric(
                                vertical: 6.0, horizontal: 12),
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a city';
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
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom +
                                        6),
                            child: ElevatedButton(
                                child: const Text('Update'),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    /*Address newAddress = Address.existing(
                                        street1: _streetAddress1Controller.text,
                                        street2: _streetAddress2Controller.text,
                                        city: _cityController.text,
                                        state: _stateController.text,
                                        zip: _zipController.text,
                                        country: _countryController.text,
                                        dateCreated:
                                            property.address.dateCreated,
                                        primaryKey: property.address.key,
                                        propertyKey: property.key);

                                    Property newProperty = Property.existing(
                                      name: _nameController.text ?? "",
                                      owner: "Diana Doria",
                                      //todo: Update this
                                      address: newAddress,
                                      calendar: property.calendar,
                                      expenditures: property.expenditures,
                                      associates: property.associates,
                                      earnings: property.earnings,
                                      primaryKey: property.key,
                                      dateCreated: property.dateCreated,
                                    );*/

                                    property.name = _nameController.text;
                                    property.address.street1 = _streetAddress1Controller.text;
                                    property.address.street2 = _streetAddress2Controller.text;
                                    property.address.city = _cityController.text;
                                    property.address.state = _stateController.text;
                                    property.address.zip = _zipController.text;
                                    property.address.country = _countryController.text;

                                    /// Update database
                                    property.update();
                                    property.address.update();

                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(builder:
                                          (BuildContext context) {
                                        return const PropertiesPage();
                                      }),
                                      ModalRoute.withName('/home'),
                                    );
                                  }
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: const NavBar(),
    );
  }

  Future<void> loadPropertyData() async {
    if (fetch) {
      Property.fetchById(widget.propertyId).then((fetchedProperty) {
        // todo: Stop the owner from being hard coded
        property = fetchedProperty ??
            Property(
              owner: 'Diana Doria',
              name: '',
              address: Address(country: '', city: '', street1: ''),
            );

        _nameController.text = fetchedProperty?.name ?? "";
        _streetAddress1Controller.text = fetchedProperty?.address.street1 ?? "";
        _streetAddress2Controller.text = fetchedProperty?.address.street2 ?? "";
        _cityController.text = fetchedProperty?.address.city ?? "";
        _stateController.text = fetchedProperty?.address.state ?? "";
        _zipController.text = fetchedProperty?.address.zip ?? "";
        _countryController.text = fetchedProperty?.address.country ?? "";
      });

      fetch = false;
    }
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
