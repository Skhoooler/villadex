// Returns a form for adding an earning
import 'package:flutter/material.dart';
import 'package:villadex/Style/colors.dart';
import 'package:villadex/Style/text_styles.dart';

class EventForm {
  final _formKey = GlobalKey<FormState>();

  get() {
    return Container(
      height: 500,
      color: VillaDexColors().background,
      child: Center(
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// Add a new Event Title
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 6.0,
                      horizontal: 12.0
                  ),
                  child: Text(
                    "Add a new Event",
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
