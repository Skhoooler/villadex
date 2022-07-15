import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:villadex/Style/colors.dart';
import 'package:villadex/Style/text_styles.dart';

import '../properties/properties.dart';

class IntroductionPage extends StatefulWidget {
  const IntroductionPage({Key? key}) : super(key: key);

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  final _ownerController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    const String logo = 'lib/res/villadexLogo.svg';
    double iconSize = MediaQuery.of(context).size.width * .25;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [VilladexColors().primary, VilladexColors().fadedPrimary],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(2, 2),
              stops: const [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .08,
              ),
              Wrap(
                direction: Axis.vertical,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 0,
                children: [
                  SizedBox(
                    width: iconSize,
                    height: iconSize,
                    child: SvgPicture.asset(
                      logo,
                      color: VilladexColors().background,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  Text(
                    "Villadex",
                    style: GoogleFonts.cormorantGaramond(
                      textStyle: TextStyle(
                          color: VilladexColors().background,
                          fontWeight: FontWeight.w300,
                          fontSize: 70),
                    ),
                  ),
                  Text(
                    "The Property Management App",
                    style: VilladexTextStyles().getTertiaryTextStyleWhite(),
                  ),
                ],
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height * .05,
              ),

              Text(
                "Welcome",
                style: VilladexTextStyles().getSecondaryTextStyle().copyWith(
                      color: Colors.white,
                    ),
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height * .05,
              ),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          value = "Please type your name";
                        }
                        return null;
                      },
                      controller: _ownerController,
                      textCapitalization: TextCapitalization.sentences,
                      autocorrect: false,
                      cursorColor: Colors.white,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: VilladexTextStyles()
                          .getSecondaryTextStyle()
                          .copyWith(color: Colors.white),
                      decoration: InputDecoration(
                          label: const Center(
                            child: Text("What is your name?"),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          labelStyle: VilladexTextStyles()
                              .getSecondaryTextStyle()
                              .copyWith(color: Colors.white),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          errorBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: VilladexColors().error))),
                    ),
                  ],
                ),
              ),

              // Continue Button
              Padding(
                padding: EdgeInsets.only(
                    left: 6.0,
                    right: 6.0,
                    top: 6.0,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 6),
                child: ElevatedButton(
                  child: const Text('Continue'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final String owner = _ownerController.text;
                      _setOwner(owner);

                      _ownerController.clear();

                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PropertiesPage()));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _ownerController.dispose();
  }

  _setOwner(String owner) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("owner", owner);
    prefs.setBool("seen", true);
  }
}
