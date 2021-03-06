import 'package:flutter/material.dart';

import 'package:villadex/Routes/properties/properties.dart' as properties;
import '../routes/finances/finances.dart' as finances;
import '../routes/scheduling/calendar.dart' as scheduling;
import '../routes/marketing/marketing.dart' as marketing;

import '../style/colors.dart';

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
    const scheduling.VilladexCalendar(),
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
      selectedItemColor: VilladexColors().accent,

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
          backgroundColor: VilladexColors().background,
          icon: Icon(
            Icons.home,
            color: VilladexColors().accent,
          ),
          label: 'Properties',
        ),

        /// Finances
        BottomNavigationBarItem(
          backgroundColor: VilladexColors().background,
          icon: Icon(
            Icons.attach_money_rounded,
            color: VilladexColors().accent,
          ),
          label: 'Finances',
        ),

        /// Calendar
        BottomNavigationBarItem(
          backgroundColor: VilladexColors().background,
          icon: Icon(
            Icons.event_rounded,
            color: VilladexColors().accent,
          ),
          label: 'Calendar',
        ),

        /// Marketing
        BottomNavigationBarItem(
          backgroundColor: VilladexColors().background,
          icon: Icon(
            Icons.group_rounded,
            color: VilladexColors().accent,
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
