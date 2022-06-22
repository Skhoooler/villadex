import 'package:flutter/material.dart';

import '../../../../Style/colors.dart';
import '../../../../Style/text_styles.dart';
import '../../../../Util/nav_bar.dart';

class EditAssociates extends StatefulWidget {
  final int propertyId;
  const EditAssociates({required this.propertyId, Key? key}) : super(key: key);

  @override
  State<EditAssociates> createState() => _EditAssociatesState();
}

class _EditAssociatesState extends State<EditAssociates> {
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
                  "Edit Associates",
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
