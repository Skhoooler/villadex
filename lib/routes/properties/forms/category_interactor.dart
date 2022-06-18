import 'dart:collection';

import 'package:flutter/material.dart';
import '../../../style/text_styles.dart';
import '../../../model/category_model.dart';
import '../../../style/colors.dart';

class CategoryInteractor extends StatefulWidget {
  const CategoryInteractor({Key? key}) : super(key: key);

  @override
  _CategoryInteractorState createState() => _CategoryInteractorState();
}

class _CategoryInteractorState extends State<CategoryInteractor> {
  final _newCategoryController = TextEditingController();

  // What is displayed to the user
  String selectedCategory = "Select a Category";

  // Keeps track of selected Categories
  HashMap<String, bool> selectedState = HashMap();

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// Select existing Categories
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: VilladexColors().primary,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              onPrimary:
                  VilladexTextStyles().getTertiaryTextStyleWhite().color),
          onPressed: () {
            // Show the dialog, then reset the state of the button
            showDialog(
                context: context,
                builder: (context) {
                  // Show a dialog
                  return AlertDialog(
                    title: const Text("Select a Category"),
                    content: Container(
                      width: MediaQuery.of(context).size.width * .75,
                      height: MediaQuery.of(context).size.height * .5,
                      decoration: BoxDecoration(
                        color: VilladexColors().background2,
                        border: Border.all(
                          color: VilladexColors().accent,
                          width: 5,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      // Fetch all of the Categories from the database and build
                      // a Listview from them
                      child: FutureBuilder<List<Category?>?>(
                        future: Category.fetchAll(),
                        builder: (context, snapshot) {
                          List<Widget> data = [];

                          if (snapshot.hasData) {
                            data = snapshot.data?.map((category) {
                                  return ListTile(
                                    title: Text(category?.name ?? "Error"),
                                    focusColor: VilladexColors().primary,
                                    hoverColor: VilladexColors().secondary,
                                    selectedColor: VilladexTextStyles()
                                        .getTertiaryTextStyleWhite()
                                        .color,
                                    tileColor:
                                        selectedState[category?.name] ?? false
                                            ? VilladexColors().primary
                                            : VilladexColors().background2, // If it is selected, set the tile to green
                                    textColor: VilladexColors().text,
                                    selected:
                                        selectedState[category?.name] ?? false,
                                    enabled: true,
                                    onTap: (() {
                                      setState(() {
                                        // Flip the state of the list tile's selected property
                                        if (selectedState[category?.name] ==
                                            true) {
                                          selectedState[category?.name ?? ""] =
                                              false;
                                        } else {
                                          selectedState[category?.name ?? ""] =
                                              true;
                                        }
                                        selectedCategory =
                                            category?.name ?? "Error";
                                      });
                                    }),
                                  );
                                }).toList() ??
                                [
                                  const ListTile(
                                    title: Text("No Data"),
                                  )
                                ];
                          }

                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return data[index];
                              });
                        },
                      ),
                    ),
                  );
                });
          },
          child: Text(selectedCategory),
        ),

        /// Add a new Category
        IconButton(
          icon: Icon(
            Icons.add_rounded,
            color: VilladexColors().accent,
            size: MediaQuery.of(context).size.width * .10,
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return SimpleDialog(
                  title: const Center(child: Text("Add a new Category")),
                  children: [
                    /// Get user input
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: _newCategoryController,
                          textCapitalization: TextCapitalization.characters,
                          autocorrect: false,
                          cursorColor: VilladexColors().accent,
                          maxLines: 1,
                          decoration: const InputDecoration(
                            labelText: 'Category',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a category';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),

                    /// Submit User input
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * .23,
                        vertical: 12,
                      ),
                      child: Container(
                        color: VilladexColors().primary,
                        child: SimpleDialogOption(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          onPressed: () {
                            // Insert into database
                            Category category =
                                Category(name: _newCategoryController.text);

                            category.insert();

                            Navigator.pop(context);
                            _newCategoryController.clear();
                          },
                          child: Center(
                            child: Text(
                              "Enter",
                              style: VilladexTextStyles()
                                  .getTertiaryTextStyleWhite(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    // Get rid of text controllers when the widget is disposed
    _newCategoryController.dispose();
    super.dispose();
  }
}
