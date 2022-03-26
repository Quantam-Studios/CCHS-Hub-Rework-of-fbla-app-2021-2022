// General
import 'package:flutter/material.dart';

// Create a ThemeObject() to be called in other scripts (mainly main.dart)
ThemeData defaultTheme = _buildDefaultTheme();
// Give the object data
ThemeData _buildDefaultTheme() {
  return _themeData();
}

// THEME
// The Actual Theme Data
ThemeData _themeData() {
  ThemeData base = ThemeData(
    backgroundColor: Colors.amber,
    primaryColor: Colors.amber,
    splashColor: Colors.blue,
    appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF333333)),
    canvasColor: const Color(0xFF121212),
    scaffoldBackgroundColor: const Color(0xFF121212),
    // TEXT
    textTheme: const TextTheme(
      bodyText1: TextStyle(),
      bodyText2: TextStyle(),
    ).apply(
      bodyColor: Colors.white,
    ),
  );
  return base;
}
