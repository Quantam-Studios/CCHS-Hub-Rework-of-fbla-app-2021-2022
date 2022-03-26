// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'HomePage.dart';
import 'ClassesPage.dart';
import 'PlannerPage.dart';
import 'SocialsPage.dart';
import 'theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // disable the debug banner
      debugShowCheckedModeBanner: false,
      title: 'CCHS Hub',
      theme: defaultTheme,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// MAIN DYNAMIC CLASS OF THE APP
// this class handles the page switching
class _MyHomePageState extends State<MyHomePage> {
  // Bottom Navigation
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // STYLE OF SYSTEM SPECIFIC THINGS
    // styles the System's navigation bar, and status bar
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarColor: const Color(0xFF212121),
        statusBarColor: const Color(0xFF212121)));
    // LIMIT ROTATION
    // this ensures the app can not be forced to render horizontally.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    List<Widget> _pages = <Widget>[
      // HOME PAGE STUFF
      HomePage(),
      // PLANNER
      PlannerPage(),
      //CLASSES PAGE
      ClassesPage(),
      // SOCIALS
      SocialPage(),
    ];

    return Scaffold(
      // Bottom Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 10),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: const Color(0xFF212121),
          currentIndex: _selectedIndex,
          showSelectedLabels: true,
          onTap: _onNewPageSelected,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.white,
          type: BottomNavigationBarType.shifting,
          items: [
            const BottomNavigationBarItem(
              backgroundColor: Color(0xFF212121),
              icon: Icon(
                Icons.house_rounded,
              ),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              backgroundColor: Color(0xFF212121),
              icon: Icon(
                Icons.calendar_today_rounded,
              ),
              label: 'Planner',
            ),
            const BottomNavigationBarItem(
              backgroundColor: Color(0xFF212121),
              icon: Icon(
                Icons.format_list_bulleted_rounded,
              ),
              label: 'Classes',
            ),
            const BottomNavigationBarItem(
              backgroundColor: Color(0xFF212121),
              icon: Icon(
                Icons.share,
              ),
              label: 'Social',
            ),
          ],
        ),
      ),
      body: _pages.elementAt(_selectedIndex),
    );
  }

  //Bottom Bar Functionality
  void _onNewPageSelected(int index) {
    if (!mounted) return;
    setState(() {
      _selectedIndex = index;
    });
  }
}

//Global Bottom Bar Functionality
// This allows for the page to be changed from other scripts.
void globalNewPageSelected(int index) {
  _MyHomePageState()._onNewPageSelected(index);
}
