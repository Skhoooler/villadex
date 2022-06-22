import 'package:flutter/material.dart';
import 'package:villadex/Style/colors.dart';

import '../../../../Style/text_styles.dart';
import '../../../../Util/nav_bar.dart';

class EditCategories extends StatefulWidget {
  final int propertyId;
  const EditCategories({required this.propertyId, Key? key}) : super(key: key);

  @override
  State<EditCategories> createState() => _EditCategoriesState();
}

class _EditCategoriesState extends State<EditCategories> {
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
                  "Edit Categories",
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
