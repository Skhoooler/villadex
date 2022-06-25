import 'package:flutter/material.dart';
import 'package:villadex/Style/colors.dart';
import 'package:villadex/Util/nav_bar.dart';
import 'package:villadex/routes/properties/menu%20options/edit%20property%20options/edit_associates.dart';

import '../../../Style/text_styles.dart';
import 'edit property options/edit_categories.dart';
import 'edit property options/edit_property.dart';

class EditPropertyAttributes extends StatefulWidget {
  final int propertyId;
  final String name;

  const EditPropertyAttributes({
    required this.propertyId,
    required this.name,
    Key? key,
  }) : super(key: key);

  @override
  State<EditPropertyAttributes> createState() => _EditPropertyAttributesState();
}

class _EditPropertyAttributesState extends State<EditPropertyAttributes> {
  Color iconColor = VilladexColors().primary;

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
                  "Edit Property",
                  style: VilladexTextStyles().getSecondaryTextStyle(),
                ),
              ],
            ),

            SizedBox(
              height: MediaQuery.of(context).size.height * .05,
            ),

            Center(
              child: Text(
                "What would you like to edit?",
                style: VilladexTextStyles().getTertiaryTextStyle(),
              ),
            ),

            SizedBox(
              height: MediaQuery.of(context).size.height * .05,
            ),

            /// Edit Categories
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditCategories(
                        propertyKey: widget.propertyId,
                      ),
                    ),
                  );
                },
                child: _EditPropertyOption(
                  icon: Icon(
                    Icons.category,
                    color: iconColor,
                    size: 45,
                  ),
                  text: "Categories",
                ),
              ),
            ),

            /// Edit Associates
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditAssociates(
                        propertyKey: widget.propertyId,
                      ),
                    ),
                  );
                },
                child: _EditPropertyOption(
                  icon: Icon(
                    Icons.person,
                    color: iconColor,
                    size: 45,
                  ),
                  text: "Associates",
                ),
              ),
            ),

            /// Edit the Property
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProperty(
                        name: widget.name,
                        propertyId: widget.propertyId,
                      ),
                    ),
                  );
                },
                child: _EditPropertyOption(
                  icon: Icon(
                    Icons.home,
                    color: iconColor,
                    size: 45,
                  ),
                  text: widget.name,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}

class _EditPropertyOption extends StatelessWidget {
  final Icon icon;
  final String text;

  const _EditPropertyOption({
    required this.icon,
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: VilladexColors().background2,
        border: Border.all(
          color: VilladexColors().accent,
          width: 5,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      height: 80,
      width: MediaQuery.of(context).size.width * .75,
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          /// Icon
          icon,

          /// Text
          Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.fade,
            style: VilladexTextStyles().getSecondaryTextStyle(),
          )
        ],
      ),
    );
  }
}
