import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:villadex/Style/theme.dart' as villadex_theme;
import 'package:villadex/routes/properties/properties.dart';
import 'package:villadex/util/notification_service.dart';
import 'package:villadex/util/splash.dart';

void main() async {
  // Set it to only portrait mode
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await NotificationService().init();

  runApp(const Villadex());
}

class Villadex extends StatelessWidget {
  const Villadex({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: villadex_theme.getTheme(),
      //initialRoute: '/home',
      home: const SplashScreen(),
      routes: {
        '/home': (context) => const PropertiesPage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      /// Body
      body: PropertiesPage(),
    );
  }
}
