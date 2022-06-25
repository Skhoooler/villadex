import 'package:flutter/material.dart';

import '../../../../Style/colors.dart';
import '../../../../Style/text_styles.dart';
import '../../../../model/associate_model.dart';

class AssociateListItem extends StatefulWidget {
  final Associate associate;
  final int propertyKey;

  const AssociateListItem({
    required this.associate,
    required this.propertyKey,
    Key? key,
  }) : super(key: key);

  @override
  State<AssociateListItem> createState() => _AssociateListItemState();
}

class _AssociateListItemState extends State<AssociateListItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {},
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
                "${widget.associate.firstName} ${widget.associate.lastName}",
                style: VilladexTextStyles().getTertiaryTextStyle(),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
