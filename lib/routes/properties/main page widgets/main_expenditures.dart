import 'package:flutter/material.dart';

import '../../../Style/colors.dart';
import '../../../Style/text_styles.dart';
import '../../../model/property_model.dart';

//////////////////////////////////////////////////////////////
///
//////////////////////////////////////////////////////////////
class MainExpenditures extends StatefulWidget {
  final Property property;

  const MainExpenditures({required this.property, Key? key}) : super(key: key);

  @override
  State<MainExpenditures> createState() => _MainExpendituresState();
}

class _MainExpendituresState extends State<MainExpenditures> {
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
                  "Main Expenses",
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