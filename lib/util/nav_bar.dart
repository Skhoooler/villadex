import 'package:flutter/material.dart';

import 'package:villadex/Style/colors.dart';

import 'package:villadex/Routes/properties/properties.dart' as properties;
import 'package:villadex/Routes/finances.dart' as finances;
import 'package:villadex/Routes/scheduling.dart' as scheduling;
import 'package:villadex/Routes/marketing.dart' as marketing;

/// NAV BAR
/// Bottom Navigation bar. It is included in every page of the app
class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NavBarState();
}

/// Nav Bar State
class _NavBarState extends State<NavBar> {
  static int selectedPage = 0;

  final _pageOptions = [
    const properties.PropertiesPage(),
    const finances.FinancesPage(),
    const scheduling.SchedulingPage(),
    const marketing.MarketingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 0,
      enableFeedback: true,
      iconSize: 35.0,
      type: BottomNavigationBarType.shifting,
      showSelectedLabels: true,
      showUnselectedLabels: false,
      selectedFontSize: 15,
      selectedLabelStyle: const TextStyle(
        color: Colors.red,
      ),

      /// Navigate between pages
      currentIndex: selectedPage,
      onTap: (index) {
        setState(() {
          selectedPage = index;
        });
        _onTap();
      },

      items: [
        /// Properties
        BottomNavigationBarItem(
          backgroundColor: VillaDexColors().background,
          icon: Icon(
            Icons.home,
            color: VillaDexColors().accent,
          ),
          label: 'Properties',
        ),

        /// Finances
        BottomNavigationBarItem(
          backgroundColor: VillaDexColors().background,
          icon: Icon(
            Icons.attach_money_rounded,
            color: VillaDexColors().accent,
          ),
          label: 'Finances',
        ),

        /// Calendar
        BottomNavigationBarItem(
          backgroundColor: VillaDexColors().background,
          icon: Icon(
            Icons.event_rounded,
            color: VillaDexColors().accent,
          ),
          label: 'Calendar',
        ),

        /// Marketing
        BottomNavigationBarItem(
          backgroundColor: VillaDexColors().background,
          icon: Icon(
            Icons.group_rounded,
            color: VillaDexColors().accent,
          ),
          label: 'Marketing',
        )
      ],
    );
  }

  /// Navigates to a separate page on tap
  _onTap() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => _pageOptions[selectedPage]));
  }
}
