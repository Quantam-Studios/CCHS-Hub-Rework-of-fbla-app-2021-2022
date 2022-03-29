// General
import 'package:cchs_hub/model/class.dart';
import 'package:cchs_hub/model/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Hive Database
import 'package:hive_flutter/hive_flutter.dart';
// App pages
import 'HomePage.dart';
import 'ClassesPage.dart';
import 'PlannerPage.dart';
import 'SocialsPage.dart';
// Theme Info
import 'theme.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive Initialization
  await Hive.initFlutter();
  // Classes
  Hive.registerAdapter(ClassAdapter());
  await Hive.openBox<Class>('classes');
  // Events
  Hive.registerAdapter(EventAdapter());
  await Hive.openBox<Event>('events');

  // run App
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
// Bottom Navigation
int _selectedIndex = 0;

// this class handles the page switching
class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    // load active class
    updateActiveClass();
    // General Initialization (flutter method)
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
      const HomePage(),
      // PLANNER
      const PlannerPage(),
      //CLASSES PAGE
      const ClassesPage(),
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
          items: const [
            BottomNavigationBarItem(
              backgroundColor: Color(0xFF212121),
              icon: Icon(
                Icons.house_rounded,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              backgroundColor: Color(0xFF212121),
              icon: Icon(
                Icons.event_note_rounded,
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
      body: _pages.elementAt(_selectedIndex),
    );
  }

  //Bottom Bar Functionality
  void _onNewPageSelected(int index) {
    if (!mounted) return;
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) updateActiveClass();
    });
  }

  // Hive Closing
  @override
  void dispose() {
    Hive.box('classes').close();
    Hive.box('events').close();
  }
}
