// Returns a form for adding an earning
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:villadex/Style/text_styles.dart';
import 'package:villadex/model/associate_model.dart';
import 'package:villadex/model/expenditure_model.dart';
import 'package:villadex/routes/properties/forms/date_selector.dart';
import '../../../model/category_model.dart';
import '../../../style/colors.dart';
import 'category_interactor.dart';

class ExpenditureForm extends StatefulWidget {
  final int propertyKey;

  const ExpenditureForm({Key? key, required this.propertyKey})
      : super(key: key);

  @override
  State<ExpenditureForm> createState() => _ExpenditureFormState();
}

class _ExpenditureFormState extends State<ExpenditureForm> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _numberUnitsController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool isPaid = false; // todo: Implement isPaid
  List<Associate> associates = []; // todo: implement Associates
  DateTime _date = DateTime.now();
  Category _category = Category(name: "Blank");

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
                /// Expenditure Title
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 6.0, horizontal: 12.0),
                    child: Text(
                      "Add a new Expenditure",
                      style: VilladexTextStyles().getSecondaryTextStyle(),
                    ),
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
                              return 'Please give the expenditure a name';
                            }
                            return null;
                          },
                          controller: _nameController,
                          textCapitalization: TextCapitalization.words,
                          autocorrect: true,
                          cursorColor: VilladexColors().accent,
                          maxLines: 1,
                          decoration: const InputDecoration(
                              labelText: 'Expenditure Name'),
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

                /// Add a price and the number of units
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6.0,
                    horizontal: 12.0,
                  ),
                  child: Row(
                    children: [
                      /// Add a Price
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 6.0),
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
                                  value
                                          .substring(value.indexOf(".") + 1)
                                          .length >
                                      2) {
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
                              labelText: "Price per Unit",
                              hintText: "100.00",
                            ),
                          ),
                        ),
                      ),

                      /// Add a number of units
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 6.0),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter an amount";
                              } else if (int.parse(value) < 1) {
                                return "Please enter an amount greater than 0";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            controller: _numberUnitsController,
                            autocorrect: false,
                            maxLines: 1,
                            decoration: const InputDecoration(
                                labelText: 'Number of Units'),
                            // Only allow the user to enter an int
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9]'),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
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
                    child: const Text('Continue'),
                    onPressed: (() {
                      if (_formKey.currentState!.validate()) {
                        // Insert an Expenditure into the database
                        Expenditure(
                          name: _nameController.text,
                          amount: double.parse(_amountController.text),
                          numUnits: int.parse(_numberUnitsController.text),
                          description: _descriptionController.text,
                          category: _category,
                          expenditureDate: _date,
                          associates: [],
                          //todo: Add associates
                          propertyKey: widget.propertyKey,
                        ).insert();

                        // Clear the controllers
                        _nameController.clear();
                        _amountController.clear();
                        _numberUnitsController.clear();
                        _descriptionController.clear();

                        // Return to the previous screen
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

  /// Gets the Category from the CategoryInteractor child widget
  _setCategory(Category category) {
    setState(() {
      _category = category;
    });
  }
}
