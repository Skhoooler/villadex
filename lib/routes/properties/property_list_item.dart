import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marquee/marquee.dart';

import 'package:villadex/routes/properties/property_page.dart';
import 'package:villadex/style/colors.dart';
import 'package:villadex/model/property.dart';

// Marquee Guide: https://medium.com/codechai/anatomy-of-flutter-marquee-extensions-scroll-that-text-73951395a564

class PropertyListItem extends StatelessWidget {
  final String name;
  final String street;
  final String city;
  final String state;
  final String zip;
  final String country;

  final TextStyle nameStyle = const TextStyle(fontSize: 18);
  final TextStyle addressStyle = const TextStyle(fontSize: 16);

  const PropertyListItem(
      {required this.name,
      required this.street,
      required this.city,
      required this.state,
      required this.zip,
      required this.country,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double textMaxWidth = MediaQuery.of(context).size.width * .54;
    const String assetName = 'lib/res/default_house.svg';

    return GestureDetector(
      onTap: () {
        Property property = Property(
          name: name,
          streetAddress: street,
          city: city,
          state: state,
          zip: zip,
          country: country,
        );

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PropertyPage(propertyData: property)),
        );
      },

      child: Container(
        height: 120,
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Image
            Container(
              width: 150,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  bottomLeft: Radius.circular(32),
                ),
                child: SvgPicture.asset(
                  assetName,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Builder(
                  /// Name of Property
                  builder: (context) {
                    if (_willTextOverflow(
                        text: name,
                        style: nameStyle,
                        marqueeWidth: textMaxWidth)) {
                      return Marquee(
                        text: name,
                        style: nameStyle,
                        blankSpace: 50,
                        velocity: 30,
                        pauseAfterRound: const Duration(milliseconds: 2000),
                        decelerationCurve: Curves.decelerate,
                        decelerationDuration:
                            const Duration(milliseconds: 2500),
                      );
                    } else {
                      return SizedBox(
                        height: 20,
                        width: textMaxWidth,
                        child: Text(name, style: nameStyle),
                      );
                    }
                  },
                ),

                const Text(""),

                /// Street Address of Property
                Builder(
                  builder: (context) {
                    if (_willTextOverflow(
                        text: name,
                        style: addressStyle,
                        marqueeWidth: textMaxWidth)) {
                      return Marquee(
                        text: street,
                        style: addressStyle,
                        blankSpace: textMaxWidth / 3,
                        velocity: 37,
                        pauseAfterRound: const Duration(milliseconds: 3000),
                        decelerationCurve: Curves.decelerate,
                        decelerationDuration:
                            const Duration(milliseconds: 2500),
                      );
                    } else {
                      return SizedBox(
                        height: 20,
                        width: textMaxWidth,
                        child: Text(
                          street,
                          style: addressStyle,
                          maxLines: 1,
                        ),
                      );
                    }
                  },
                ),

                /// City, State, Zip
                Builder(
                  builder: (context) {
                    if (_willTextOverflow(
                        text: name,
                        style: addressStyle,
                        marqueeWidth: textMaxWidth)) {
                      return Marquee(
                        text: city + ", " + state + " " + zip,
                        style: addressStyle,
                        blankSpace: 50,
                        velocity: 37,
                        pauseAfterRound: const Duration(milliseconds: 3000),
                        decelerationCurve: Curves.decelerate,
                        decelerationDuration:
                            const Duration(milliseconds: 2500),
                      );
                    } else {
                      return SizedBox(
                        height: 20,
                        width: textMaxWidth,
                        child: Text(city + ", " + state + " " + zip,
                            style: addressStyle),
                      );
                    }
                  },
                ),

                /// Country
                Builder(
                  builder: (context) {
                    if (_willTextOverflow(
                        text: name,
                        style: addressStyle,
                        marqueeWidth: textMaxWidth)) {
                      return Marquee(
                        text: country,
                        style: addressStyle,
                        blankSpace: 50,
                        velocity: 37,
                        pauseAfterRound: const Duration(milliseconds: 3000),
                        decelerationCurve: Curves.decelerate,
                        decelerationDuration:
                            const Duration(milliseconds: 2500),
                      );
                    } else {
                      return SizedBox(
                        height: 20,
                        width: textMaxWidth,
                        child: Text(country, style: addressStyle),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool _willTextOverflow({
    // Todo: Fix _willTextOverflow so it does not cut off important information
    required String text,
    required TextStyle style,
    required double marqueeWidth,
  }) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: marqueeWidth);

    return textPainter.didExceedMaxLines;
  }
}
