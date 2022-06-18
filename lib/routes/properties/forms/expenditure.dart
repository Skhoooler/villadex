// Returns a form for adding an earning
import 'package:flutter/material.dart';
import 'package:villadex/Style/text_styles.dart';
import '../../../style/colors.dart';
import 'category_interactor.dart';

class ExpenditureForm {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _numberUnits = TextEditingController();
  final _descriptionController = TextEditingController();

  // Add category here?
  // Add date here?

  get(BuildContext context) {
    return Container(
      height: 500,
      color: VilladexColors().background,
      child: Center(
        child: SingleChildScrollView(
          child: Form(
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
                    "Add a new Expenditure",
                    style: VilladexTextStyles().getSecondaryTextStyle(),
                  ),
                ),
                const CategoryInteractor(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
