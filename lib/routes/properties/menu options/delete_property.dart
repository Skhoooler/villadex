import 'package:flutter/material.dart';
import 'package:villadex/routes/properties/properties.dart';
import 'package:villadex/style/colors.dart';

import '../../../model/property_model.dart';

class DeleteProperty extends StatefulWidget {
  final int propertyKey;

  const DeleteProperty({Key? key, required this.propertyKey}) : super(key: key);

  @override
  State<DeleteProperty> createState() => _DeletePropertyState();
}

class _DeletePropertyState extends State<DeleteProperty> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Center(
        child: Text("Really delete the Property?"),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// No
              Container(
                width: MediaQuery.of(context).size.width * .3,
                height: MediaQuery.of(context).size.height * .05,
                color: VilladexColors().primary,
                child: SimpleDialogOption(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Center(
                    child: Text("No"),
                  ),
                ),
              ),

              /// Yes
              Container(
                width: MediaQuery.of(context).size.width * .3,
                height: MediaQuery.of(context).size.height * .05,
                color: VilladexColors().background2,
                child: SimpleDialogOption(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  onPressed: () {
                    /// Second Dialog to make sure it is ok to delete
                    showDialog(
                        context: context,
                        builder: (context) {
                          return SimpleDialog(
                              title: const Center(
                                child: Text("Are you sure?"),
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      /// No
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .3,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .05,
                                        color: VilladexColors().error,
                                        child: SimpleDialogOption(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          onPressed: () {
                                            Navigator.of(context)
                                              ..pop()
                                              ..pop();
                                          },
                                          child: Center(
                                            child: Text(
                                              "No",
                                              style: TextStyle(
                                                  color: VilladexColors()
                                                      .background2),
                                            ),
                                          ),
                                        ),
                                      ),

                                      /// Final Yes
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .3,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .05,
                                        color: VilladexColors().background2,
                                        child: SimpleDialogOption(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          onPressed: () {
                                            // Remove property from database
                                            Property.deleteById(
                                                widget.propertyKey);
                                            // Pop twice back to main menu
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(builder:
                                                  (BuildContext context) {
                                                return const PropertiesPage();
                                              }),
                                              ModalRoute.withName('/home'),
                                            );
                                          },
                                          child: const Center(
                                            child: Text(
                                              "Yes",
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]);
                        });
                  },
                  child: const Center(
                    child: Text("Yes"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
