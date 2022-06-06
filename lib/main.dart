import 'package:crime_alert/pages/home/home_feed.dart';
import 'package:crime_alert/pages/leaflet/leaflet_feed.dart';
import 'package:crime_alert/pages/post%20alert/post_alert.dart';
import 'package:crime_alert/pages/setting/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        //Use Indexed stack to have persisting data
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
        floatingActionButton: FirebaseAuth.instance.currentUser != null
            ? FloatingActionButton(
                heroTag: null,
                onPressed: () {
                  Get.to(() => const PostAlertPage());
                },
                backgroundColor: Colors.black,
                child: const Icon(Icons.add, size: 30),
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          currentIndex: _selectedIndex,
          onTap: _navigatBottomBar,
          backgroundColor: Colors.white,
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
