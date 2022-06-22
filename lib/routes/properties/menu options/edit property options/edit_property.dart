import 'package:flutter/material.dart';

import '../../../../Style/colors.dart';
import '../../../../Style/text_styles.dart';
import '../../../../Util/nav_bar.dart';

class EditProperty extends StatefulWidget {
  final int propertyId;
  final String name;

  const EditProperty({
    required this.propertyId,
    required this.name,
    Key? key,
  }) : super(key: key);

  @override
  State<EditProperty> createState() => _EditPropertyState();
}

class _EditPropertyState extends State<EditProperty> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: VilladexColors().background,
        child: Column(
          children: [
            /// Spacing
            const SizedBox(
              height: 15,
            ),

            /// Back button and Name
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// Back Button
                IconButton(
                  iconSize: 35,
                  color: VilladexColors().accent,
                  icon: const Icon(
                    Icons.arrow_back,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),

                const SizedBox(
                  width: 10,
                ),

                /// Page Name
                Text(
                  "Edit ${widget.name}",
                  style: VilladexTextStyles().getSecondaryTextStyle(),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}
