import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:villadex/Style/colors.dart';
import 'package:villadex/Style/text_styles.dart';
import 'package:villadex/model/associate_model.dart';

import 'associate.dart';

class AssociateInteractor extends StatefulWidget {
  // Used to send data back to the parent
  final callback;
  final int propertyKey;

  const AssociateInteractor({
    Key? key,
    required this.callback,
    required this.propertyKey,
  }) : super(key: key);

  @override
  State<AssociateInteractor> createState() => _AssociateInteractorState();
}

class _AssociateInteractorState extends State<AssociateInteractor> {
  final _newAssociateController = TextEditingController();

  String selectedAssociate = "Select an Associate";

  // Keeps track of selected Associates
  HashMap<String, bool> selectedState = HashMap();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// Select existing Associates
        SizedBox(
          width: MediaQuery.of(context).size.width * .75,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: VilladexColors().primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                onPrimary:
                    VilladexTextStyles().getTertiaryTextStyleWhite().color),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Select an Associate"),
                    content: Container(
                      width: MediaQuery.of(context).size.width * .75,
                      height: MediaQuery.of(context).size.height * .5,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: VilladexColors().accent,
                          width: 5,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),

                      // todo: This is not working!
                      /// Fetch all of the Associates from the database
                      child: FutureBuilder<List<Associate?>?>(
                        future: Associate.fetchAll(),
                        builder: (context, snapshot) {
                          List<Widget> data = [];

                          if (snapshot.hasData) {
                            // Fill out selectedState Hashmap
                            snapshot.data?.forEach((associate) =>
                                selectedState[associate?.firstName ?? ""] =
                                    false);

                            data = snapshot.data?.map((associate) {
                                  return ListTile(
                                    title:
                                        Text(associate?.firstName ?? "Error"),
                                    focusColor: VilladexColors().primary,
                                    hoverColor: VilladexColors().secondary,
                                    selectedColor: VilladexTextStyles()
                                        .getTertiaryTextStyleWhite()
                                        .color,
                                    selectedTileColor: VilladexColors().primary,
                                    textColor: VilladexColors().text,
                                    selected:
                                        selectedState[associate?.firstName] ??
                                            false,
                                    enabled: true,
                                    onTap: (() {
                                      // Set the state of each entry to false
                                      selectedState.entries.map(
                                          (e) => selectedState[e.key] = false);

                                      setState(() {
                                        /// Set the state of the selected category to true
                                        selectedState[
                                            associate?.firstName ?? ""] = true;

                                        /// Set the display on the button
                                        selectedAssociate =
                                            associate?.firstName ?? "Error";

                                        /// Send the Associate back to the parent
                                        widget.callback([
                                          associate ??
                                              Associate(
                                                firstName:
                                                    associate?.firstName ??
                                                        "Error",
                                                lastName: associate?.lastName ??
                                                    "Error",
                                                propertyKey: widget.propertyKey,
                                              )
                                        ]);
                                      });

                                      /// Return to the main page
                                      Navigator.pop(context);
                                    }),
                                  );
                                }).toList() ??
                                [
                                  ListTile(
                                    title: const Text("None"),
                                    onTap: () {
                                      setState(() {
                                        /// Set the display on the button
                                        selectedAssociate = "None";

                                        /// Send the Associate back to the parent
                                        widget.callback([
                                          Associate(
                                            firstName: "None",
                                            lastName: "None",
                                            propertyKey: widget.propertyKey,
                                          )
                                        ]);

                                        /// Return to the main page
                                        Navigator.pop(context);
                                      });
                                    },
                                  )
                                ];
                          }
                          /// Add a none to the beginning of the list
                          data.insert(
                              0,
                              ListTile(
                                title: const Text("None"),
                                focusColor: VilladexColors().primary,
                                hoverColor: VilladexColors().secondary,
                                selectedColor: VilladexTextStyles()
                                    .getTertiaryTextStyleWhite()
                                    .color,
                                selectedTileColor: VilladexColors().primary,
                                textColor: VilladexColors().text,
                                enabled: true,
                                onTap: () {
                                  setState(() {
                                    selectedAssociate = "None";
                                    widget.callback(Associate(
                                        firstName: "None",
                                        lastName: "None",
                                        propertyKey: widget.propertyKey));
                                    Navigator.pop(context);
                                  });
                                },
                              ));

                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return data[index];
                            },
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
            child: Text(selectedAssociate),
          ),
        ),

        /// Add a new Associate
        IconButton(
          icon: Icon(
            Icons.add_rounded,
            color: VilladexColors().accent,
            size: MediaQuery.of(context).size.width * .10,
          ),
          onPressed: () {
            showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  return AssociateForm(
                    propertyKey: widget.propertyKey,
                  );
                });
          },
        ),
      ],
    );
  }

  /// Get rid of old controllers
  @override
  void dispose() {
    // Get rid of text controllers when the widget is disposed
    _newAssociateController.dispose();
    super.dispose();
  }
}
