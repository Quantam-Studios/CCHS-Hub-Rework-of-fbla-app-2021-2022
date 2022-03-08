import 'package:flutter/material.dart';
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
      title: 'Flutter Demo',
      theme: defaultTheme,
      home: const MyHomePage(title: 'CCHS Hub'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Bottom Navigation
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = <Widget>[
      // HOME PAGE STUFF
      HomePage(),
      //CLASSES PAGE
      ClassesPage(),
      // PLANNER
      PlannerPage(),
      // SOCIALS
      SocialsPage(),
    ];

    return Scaffold(
      // Bottom Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 0,
                blurRadius: 10),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          child: BottomNavigationBar(
            backgroundColor: Color(0xFF212121),
            currentIndex: _selectedIndex,
            showSelectedLabels: true,
            onTap: _onNewPageSelected,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.white,
            type: BottomNavigationBarType.shifting,
            items: [
              BottomNavigationBarItem(
                backgroundColor: Color(0xFF212121),
                icon: const Icon(
                  Icons.house_rounded,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                backgroundColor: Color(0xFF212121),
                icon: const Icon(
                  Icons.calendar_today_rounded,
                ),
                label: 'Planner',
              ),
              BottomNavigationBarItem(
                backgroundColor: Color(0xFF212121),
                icon: Icon(
                  Icons.format_list_bulleted_rounded,
                ),
                label: 'Classes',
              ),
              BottomNavigationBarItem(
                backgroundColor: Color(0xFF212121),
                icon: Icon(
                  Icons.share,
                ),
                label: 'Social',
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: _pages.elementAt(_selectedIndex), //New
      ),
    );
  }

  //Bottom Bar functionaity
  void _onNewPageSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
