// Returns a form for adding an earning
import 'package:flutter/material.dart';
import 'package:villadex/Style/text_styles.dart';
import '../../../style/colors.dart';

class AssociateForm extends StatefulWidget {
  const AssociateForm({Key? key}) : super(key: key);

  @override
  State<AssociateForm> createState() => _AssociateFormState();
}

class _AssociateFormState extends State<AssociateForm> {
  final _formKey = GlobalKey<FormState>();

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
                /// Add a new Associate Title
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 6.0,
                      horizontal: 12.0
                  ),
                  child: Text(
                    "Add a new Associate",
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
}
