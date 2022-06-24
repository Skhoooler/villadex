import 'package:flutter/material.dart';
import 'package:villadex/routes/properties/menu%20options/edit%20property%20options/edit_categories.dart';
import 'package:villadex/style/colors.dart';
import 'package:villadex/style/text_styles.dart';

import '../../../../model/category_model.dart';

class CategoryListItem extends StatefulWidget {
  final Category category;
  final int propertyKey;

  const CategoryListItem({
    required this.propertyKey,
    required this.category,
    Key? key,
  }) : super(key: key);

  @override
  State<CategoryListItem> createState() => _CategoryListItemState();
}

class _CategoryListItemState extends State<CategoryListItem> {
  final _updateCategoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    title: Center(
                      child: Text(
                        widget.category.name,
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                      ),
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
                              /// Delete
                              Container(
                                width: MediaQuery.of(context).size.width * .3,
                                height:
                                    MediaQuery.of(context).size.height * .05,
                                color: VilladexColors().error,
                                child: SimpleDialogOption(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  onPressed: () {
                                    Category.deleteById(widget.category.key);
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            EditCategories(
                                                propertyKey:
                                                    widget.category.key),
                                      ),
                                    );
                                    //todo: Streamline this a little, if possible
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            EditCategories(
                                          propertyKey: widget.propertyKey,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Center(
                                    child: Text(
                                      "Delete",
                                      style: TextStyle(
                                          color: VilladexColors().background2),
                                    ),
                                  ),
                                ),
                              ),

                              /// Update
                              Container(
                                width: MediaQuery.of(context).size.width * .3,
                                height:
                                    MediaQuery.of(context).size.height * .05,
                                color: VilladexColors().background2,
                                child: SimpleDialogOption(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  onPressed: () {
                                    _updateCategoryController.text =
                                        widget.category.name;
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return SimpleDialog(
                                            title: const Center(
                                                child: Text("Update Category")),
                                            children: [
                                              /// Get user input
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 6,
                                                ),
                                                child: Form(
                                                  child: TextFormField(
                                                    controller:
                                                        _updateCategoryController,
                                                    textCapitalization:
                                                        TextCapitalization
                                                            .characters,
                                                    autocorrect: true,
                                                    cursorColor:
                                                        VilladexColors().accent,
                                                    maxLines: 1,
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText: 'Category',
                                                    ),
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
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
                                                  horizontal:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          .23,
                                                  vertical: 12,
                                                ),
                                                child: Container(
                                                  color:
                                                      VilladexColors().primary,
                                                  child: SimpleDialogOption(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 12,
                                                      vertical: 6,
                                                    ),
                                                    onPressed: () {
                                                      // Update the database
                                                      Category.existing(
                                                              primaryKey: widget
                                                                  .category.key,
                                                              name:
                                                                  _updateCategoryController
                                                                      .text,
                                                              dateCreated: widget
                                                                  .category
                                                                  .dateCreated)
                                                          .update();

                                                      _updateCategoryController
                                                          .clear();

                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              EditCategories(
                                                            propertyKey: widget
                                                                .propertyKey,
                                                          ),
                                                        ),
                                                      );
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
                                        });
                                  },
                                  child: const Center(
                                    child: Text(
                                      "Update",
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    ],
                  );
                });
          },
          child: Container(
            width: MediaQuery.of(context).size.width * .55,
            height: MediaQuery.of(context).size.height * .08,
            decoration: BoxDecoration(
              color: VilladexColors().background2,
              border: Border.all(
                color: VilladexColors().accent,
                width: 5,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                widget.category.name,
                style: VilladexTextStyles().getTertiaryTextStyle(),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _updateCategoryController.dispose();
  }
}
