import 'package:flutter/material.dart';

import '../../../Style/colors.dart';
import '../../../Style/text_styles.dart';
import '../../../model/property_model.dart';

//////////////////////////////////////////////////////////////
/// Displays the net and gross profits of the property
//////////////////////////////////////////////////////////////
class Profits extends StatefulWidget {
  final Property property;

  const Profits({
    required this.property,
    Key? key,
  }) : super(key: key);

  @override
  State<Profits> createState() => _ProfitState();
}

class _ProfitState extends State<Profits> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Material(
        elevation: 20,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            color: VilladexColors().background2,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "Profits",
                  style: VilladexTextStyles().getTertiaryTextStyle(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}