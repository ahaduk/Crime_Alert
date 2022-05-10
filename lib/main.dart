import 'package:crime_alert/pages/home/home_feed.dart';
import 'package:crime_alert/pages/leaflet/leaflet_feed.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'pages/setting/morepage.dart';
import 'pages/stats/statistics_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
    if (index == 2) {
      return;
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  final List<Widget> _pages = [
    const HomeFeed(),
    const LeafletFeed(),
    Container(), //Empty container to balance index number
    const Stats(),
    const SettingPage(),
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
        body: _pages[_selectedIndex],
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.black,
          child: const Icon(Icons.add, size: 30),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _navigatBottomBar,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Feed'),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications), label: 'Leaflet'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings,
                  size: 0,
                ),
                label: ''),
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
