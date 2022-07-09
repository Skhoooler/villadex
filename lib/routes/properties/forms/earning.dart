// Returns a form for adding an earning
import 'package:flutter/material.dart';
import 'package:villadex/Style/text_styles.dart';

import '../../../model/category_model.dart';
import '../../../model/earning_model.dart';
import '../../../style/colors.dart';
import 'category_interactor.dart';
import 'date_time_selector.dart';

class EarningForm extends StatefulWidget {
  final int propertyKey;

  const EarningForm({Key? key, required this.propertyKey}) : super(key: key);

  @override
  State<EarningForm> createState() => _EarningFormState();
}

class _EarningFormState extends State<EarningForm> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  Category _category = Category(name: "None");
  DateTime _date = DateTime.now();

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
                /// Add a new Earning Title
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 6.0, horizontal: 12.0),
                  child: Text(
                    "Add a new Earning",
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
                              return 'Please give the earning a title';
                            }
                            return null;
                          },
                          controller: _nameController,
                          textCapitalization: TextCapitalization.words,
                          autocorrect: false,
                          cursorColor: VilladexColors().accent,
                          maxLines: 1,
                          decoration: const InputDecoration(
                              labelText: 'Earning Title'),
                        ),
                      ),
                    ),

                    /// Add a date
                    Flexible(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6.0, horizontal: 12.0),
                        child: DateTimeSelector(
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

                /// Add a Price
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6.0,
                    horizontal: 12,
                  ),
                  child: TextFormField(
                    validator: (value) {
                      // if the value is empty
                      if (value == null || value.isEmpty) {
                        return "Please enter an amount";

                        // If the value is not a number
                      } else if (!(double.tryParse(value) != null)) {
                        return "Please enter a number";

                        // If the value has more than one number past the decimal
                        // https://stackoverflow.com/questions/54454983/allow-only-two-decimal-number-in-flutter-input
                      } else if ((value.contains(".")) &&
                          value.substring(value.indexOf(".") + 1).length > 2) {
                        return "Please use only two decimal places";
                      }

                      return null;
                    },
                    keyboardType: TextInputType.number,
                    controller: _amountController,
                    autocorrect: false,
                    maxLines: 1,
                    textAlignVertical: TextAlignVertical.center,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.attach_money,
                        color: VilladexColors().money,
                      ),
                      labelText: "Amount Earned",
                      hintText: "100.00",
                    ),
                  ),
                ),

                /// Add a Category
                CategoryInteractor(
                  callback: _setCategory,
                ),

                /// Continue Button
                Padding(
                  padding: EdgeInsets.only(
                      left: 6.0,
                      right: 6.0,
                      top: 6.0,
                      bottom: MediaQuery.of(context).viewInsets.bottom + 6),
                  child: ElevatedButton(
                    child: const Text("Continue"),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Earning(
                          name: _nameController.text,
                          description: _descriptionController.text,
                          earningDate: _date,
                          category: _category,
                          amount: double.parse(_amountController.text),
                          propertyKey: widget.propertyKey,
                        ).insert();

                        /// Clear Controllers
                        _nameController.clear();
                        _amountController.clear();
                        _descriptionController.clear();

                        /// Return to previous screen
                        Navigator.pop(context);
                      }
                    },
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

  /// Gets the Category from the CategoryInteractor child widget
  _setCategory(Category category) {
    setState(() {
      _category = category;
    });
  }

  /// Get rid of old controllers
  @override
  void dispose() {
    super.dispose();

    _nameController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
  }
}
