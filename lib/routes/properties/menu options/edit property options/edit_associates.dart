import 'package:flutter/material.dart';
import 'package:villadex/routes/properties/menu%20options/edit%20property%20options/associate_list_item.dart';

import '../../../../Style/colors.dart';
import '../../../../Style/text_styles.dart';
import '../../../../Util/nav_bar.dart';
import '../../../../model/associate_model.dart';
import '../../forms/associate.dart';

class EditAssociates extends StatefulWidget {
  final int propertyKey;

  const EditAssociates({required this.propertyKey, Key? key}) : super(key: key);

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

                const Spacer(),

                /// Add a new Associate
                IconButton(
                    icon: Icon(
                      Icons.add_rounded,
                      color: VilladexColors().accent,
                      size: 40,
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
                            return AssociateForm(
                              propertyKey: widget.propertyKey,
                            );
                          });
                    }),
                const SizedBox(
                  width: 15,
                ),
              ],
            ),

            const SizedBox(
              height: 25,
            ),

            Text(
              "Select an Associate",
              style: VilladexTextStyles().getSecondaryTextStyle(),
            ),

            const SizedBox(
              height: 25,
            ),

            Container(
              width: MediaQuery.of(context).size.width,
              color: VilladexColors().background,
              //todo: fix the Associate future builder
              child: FutureBuilder<List<Associate?>?>(
                  future: Associate.fetchAll(),
                  builder: (context, snapshot) {
                    List<Widget> data = [];

                    if (snapshot.hasData) {
                      data = snapshot.data?.map((associate) {
                            return AssociateListItem(
                                associate: associate ??
                                    Associate(
                                        firstName: '',
                                        lastName: '',
                                        propertyKey: widget.propertyKey),
                                propertyKey: widget.propertyKey);
                          }).toList() ??
                          [];
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return data[index];
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}
