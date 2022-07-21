import 'package:crime_alert/components/conitional_wrapper.dart';
import 'package:crime_alert/pages/home/home_feed.dart';
import 'package:crime_alert/pages/leaflet/leaflet_feed.dart';
import 'package:crime_alert/pages/setting/settings.dart';
import 'package:crime_alert/utility/colors.dart';
import 'package:crime_alert/utility/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'firebase_options.dart';
import 'pages/stats/statistics_page.dart';
import 'dart:io';

import 'package:webview_flutter/webview_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Utils();
  //Splash screen
  // FlutterNativeSplash.removeAfter(initilization);
  runApp(const MyApp());
}

Future initilization(BuildContext? context) async {
  await Future.delayed(const Duration(seconds: 3));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  void _navigatBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    const HomeFeed(),
    const LeafletFeed(),
    const Stats(),
    const SettingsPage(),
  ];
  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      scaffoldMessengerKey: Utils.messengerKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'Montserrat',
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
              color: Colors.black,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black))),
      home: Scaffold(
        backgroundColor: AppColors.mainColor,
        //Use Indexed stack to have persisting data
        body: IndexedStack(
          sizing: StackFit.expand,
          index: _selectedIndex,
          children: _pages,
        ),
        floatingActionButton: const Wrapper(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: GNav(
          backgroundColor: Colors.black,
          color: const Color(0xF1F1F1F1),
          activeColor: AppColors.mainColor,
          padding: const EdgeInsets.all(17),
          gap: 0,
          onTabChange: _navigatBottomBar,
          tabs: const [
            GButton(
              icon: Icons.home,
              text: 'Home',
            ),
            GButton(
              icon: Icons.notifications,
              text: 'Leaflet',
            ),
            GButton(
              icon: Icons.bar_chart,
              text: 'Statistics',
            ),
            GButton(
              icon: Icons.settings,
              text: 'More',
            ),
          ],
        ),
      ),
    );
  }
}
