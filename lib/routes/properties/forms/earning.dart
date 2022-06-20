// Returns a form for adding an earning
import 'package:flutter/material.dart';
import 'package:villadex/Style/text_styles.dart';

import '../../../model/category_model.dart';
import '../../../style/colors.dart';

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
  bool isPaid = false;
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// Add a new Earning Title
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6.0,
                    horizontal: 12.0
                  ),
                  child: Text(
                    "Add a new Earning",
                    style: VilladexTextStyles().getSecondaryTextStyle(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
