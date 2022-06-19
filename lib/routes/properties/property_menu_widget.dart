import 'dart:math';

import 'package:flutter/material.dart';

import '../../style/colors.dart';
import 'forms/earning.dart';
import 'forms/expenditure.dart';
import 'forms/associate.dart';
import 'forms/event.dart';

const double buttonSize = 70;

// https://www.youtube.com/watch?v=EdJ-43J7HgQ
// Flutter Tutorial - Animated Circular FAB Menu | The Easy Way [2021] Expandable FAB Menu

/// Property Menu creates several buttons to give the user options
class PropertyMenu extends StatefulWidget {
  final int propertyKey;

  const PropertyMenu({Key? key, required this.propertyKey}) : super(key: key);

  @override
  State<PropertyMenu> createState() => _PropertyMenu();
}

class _PropertyMenu extends State<PropertyMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) => Flow(
        delegate:
            PropertyMenuDelegate(controller: controller, context: context),
        children: <IconData>[
          Icons.monetization_on, // Money icon for Earnings
          Icons.shopping_bag, // Shopping bag icon for Expenditure
          Icons.event, // Calendar icon for Event
          Icons.person, // Person icon for Associate
          Icons.add_circle, // Add in a circle for menu
        ].map(buildPropertyMenu).toList(),
      );

  Widget buildPropertyMenu(IconData icon) => SizedBox(
        // Todo: Add tooltip for each button. Perhaps pass in a map that has the IconData and a tooltip?
        width: buttonSize,
        height: buttonSize,
        child: FloatingActionButton(
          heroTag: null,

          /// This may cause problems! For now it solves them though...
          elevation: 0,
          backgroundColor: VilladexColors().accent,
          splashColor: VilladexColors().primary,
          child: Icon(icon, color: Colors.white, size: 45),
          onPressed: () {
            /// Expand and retract the buttons
            if (controller.status == AnimationStatus.completed) {
              controller.reverse();
            } else {
              controller.forward();
            }

            /// Make the buttons do something
            if (icon == Icons.monetization_on) {
              // Add Earning
              showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return const EarningForm();
                  });
            } else if (icon == Icons.shopping_bag) {
              // Add Expenditure
              showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return ExpenditureForm(propertyKey: widget.propertyKey,);
                  });
            } else if (icon == Icons.event) {
              // Add Event
              showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return const EventForm();
                  });
            } else if (icon == Icons.person) {
              // Add Associate
              showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return const AssociateForm();
                  });
            }
          },
        ),
      );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

/// Handles drawing each icon onto the screen in the right positions
class PropertyMenuDelegate extends FlowDelegate {
  final double _width;
  final double _height;
  final Animation<double> controller;

  PropertyMenuDelegate(
      {required BuildContext context, required this.controller})
      : _width = MediaQuery.of(context).size.width,
        _height = MediaQuery.of(context).size.height,
        super(repaint: controller);

  @override
  void paintChildren(FlowPaintingContext context) {
    final n = context.childCount;
    for (int i = 0; i < n; i++) {
      final isLastItem = i == context.childCount - 1;
      final setValue = (value) => isLastItem ? 0.0 : value;

      final theta = i * pi * 0.5 / (n - 2);
      final radius = 180 * controller.value;

      final x = (_width - buttonSize) - setValue(radius * cos(theta));
      final y = (_height - buttonSize) - setValue(radius * sin(theta));
      context.paintChild(i,
          transform: Matrix4.identity()
            ..translate(x, y, 0)
            ..translate(buttonSize / 2, buttonSize / 2)
            ..rotateZ(
                isLastItem ? 0.0 : 180 * (1 - controller.value) * pi / 180)
            ..scale(isLastItem ? 1.0 : max(controller.value, 0.5))
            ..translate(-buttonSize / 2, -buttonSize / 2));
    }
  }

  @override
  bool shouldRepaint(PropertyMenuDelegate oldDelegate) => false;
}
