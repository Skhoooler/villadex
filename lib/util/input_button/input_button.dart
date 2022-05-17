// Base code from https://github.com/funwithflutter/flutter_ui_tips/tree/master/tip_003_popup_card
import 'package:flutter/material.dart';
import 'package:villadex/Style/colors.dart';

import 'package:villadex/Util/input_button/hero_dialog_route.dart';
import 'package:villadex/Util/input_button/custom_rect_tween.dart';

const String _heroInputPopup = 'input-button';

/// Input Button Class
/*class InputButton extends StatelessWidget {
  const InputButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(HeroDialogRoute(builder: (context) {
            return const _InputPopupCard();
          }));
        },
        child: Hero(
          tag: _heroInputPopup,
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin!, end: end!);
          },
          child: Material(
            color: VillaDexColors().accent,
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: const Icon(
              Icons.add_rounded,
              size: 56,
            ),
          ),
        ),
      ),
    );
  }
}

/// Input Card Class
class _InputPopupCard extends StatelessWidget {
  const _InputPopupCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: _heroInputPopup,
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin!, end: end!);
          },
          child: Material(
            color: VillaDexColors().accent,
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),

                /// Make this modular by swapping out the column
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const TextField(
                      decoration: InputDecoration(
                        hintText: 'New Todo',
                        border: InputBorder.none,
                      ),
                      cursorColor: Colors.white,
                    ),
                    const Divider(
                      color: Colors.white,
                      thickness: 0.2,
                    ),
                    const TextField(
                      decoration: InputDecoration(
                        hintText: 'Write a note',
                        border: InputBorder.none,
                      ),
                      cursorColor: Colors.white,
                      maxLines: 6,
                    ),
                    const Divider(
                      color: Colors.white,
                      thickness: 0.2,
                    ),
                    ElevatedButton(onPressed: () {}, child: const Text('Add'))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
*/