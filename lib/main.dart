import 'package:crime_alert/components/conitional_wrapper.dart';
import 'package:crime_alert/pages/home/home_feed.dart';
import 'package:crime_alert/pages/leaflet/leaflet_feed.dart';
import 'package:crime_alert/pages/setting/settings.dart';
import 'package:crime_alert/utility/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'firebase_options.dart';
import 'pages/stats/statistics_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
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
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
              color: Colors.black,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black))),
      home: Scaffold(
        backgroundColor: AppColors.mainColor,
        //Use Indexed stack to have persisting data
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
        floatingActionButton: const Wrapper(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          currentIndex: _selectedIndex,
          onTap: _navigatBottomBar,
          backgroundColor: Colors.black,
          unselectedItemColor: Colors.white,
          selectedItemColor: AppColors.iconColor2,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Feed'),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications), label: 'Leaflet'),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Statistics',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'More'),
          ],
        ),
      ),
    );
  }
}
