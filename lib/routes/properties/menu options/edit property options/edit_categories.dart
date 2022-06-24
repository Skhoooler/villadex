import 'package:flutter/material.dart';
import 'package:villadex/Style/colors.dart';
import 'package:villadex/routes/properties/menu%20options/edit%20property%20options/category_list_item.dart';

import '../../../../Style/text_styles.dart';
import '../../../../Util/nav_bar.dart';
import '../../../../model/category_model.dart';

class EditCategories extends StatefulWidget {
  final int propertyKey;

  const EditCategories({required this.propertyKey, Key? key}) : super(key: key);

  @override
  State<EditCategories> createState() => _EditCategoriesState();
}

class _EditCategoriesState extends State<EditCategories> {
  final _newCategoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: VilladexColors().background,
        child: Column(
          children: [
            /// Spacing
            const SizedBox(
              height: 15,
            ),

            /// Back button and Name
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
                  "Edit Categories",
                  style: VilladexTextStyles().getSecondaryTextStyle(),
                ),

                const Spacer(),

                /// Add a new Category
                IconButton(
                  icon: Icon(
                    Icons.add_rounded,
                    color: VilladexColors().accent,
                    size: 40,
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
                                child: TextFormField(
                                  controller: _newCategoryController,
                                  textCapitalization: TextCapitalization.characters,
                                  autocorrect: true,
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
                const SizedBox(width: 15,),
              ],
            ),

            const SizedBox(
              height: 25,
            ),

            Text(
              "Select a Category",
              style: VilladexTextStyles().getSecondaryTextStyle(),
            ),

            const SizedBox(
              height: 25,
            ),

            Container(
              width: MediaQuery.of(context).size.width,
              color: VilladexColors().background,
              child: FutureBuilder<List<Category?>?>(
                  future: Category.fetchAll(),
                  builder: (context, snapshot) {
                    List<Widget> data = [];

                    if (snapshot.hasData) {
                      data = snapshot.data?.map((category) {
                            return CategoryListItem(
                              category: category ?? Category(name: ""),
                              propertyKey: widget.propertyKey,
                            );
                          }).toList() ??
                          [];
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return data[index];
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const NavBar(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _newCategoryController.dispose();
  }
}
