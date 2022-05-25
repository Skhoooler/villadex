import 'package:flutter/material.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    /// LayoutBuilder to make the info page based on the parent's size
    return Container(
      width: 50,
      height: 90,
      color: Colors.blue,
    );
    /*return FractionallySizedBox(
      widthFactor: .75,
      heightFactor: .93,
      child: Material(
        // Todo: Stop shadow from going over the edge of its container (at the bottom)
        elevation: 50,
        shadowColor: Colors.black,
        borderRadius: const BorderRadius.all(Radius.circular(32)),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(32)),),
        ),
      ),
    );*/
  }
}
