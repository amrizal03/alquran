import 'package:flutter/material.dart';

const appPurple = Color(0xFF431AA1);
const appPurpleDark = Color(0xFF1E0771);
const appPurpleLight1 = Color(0xFF9345F2);
const appPurpleLight2 = Color(0xFFB9A2D8);
const appWhite = Color(0xFFFAF8FC);
const appOrange = Color(0xFFE6704A);

ThemeData themeLight = ThemeData(
  brightness: Brightness.light,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: appPurpleDark,
  ),
  primaryColor: appPurple,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    elevation: 4,
    backgroundColor: appPurple,
  ),
  textTheme: TextTheme(
      bodyLarge: TextStyle(
        color: appPurpleDark,
      ),
      bodyMedium: TextStyle(
        color: appPurpleDark,
      )
  ),
  listTileTheme: ListTileThemeData(
    textColor: appPurpleDark,
  ),
  tabBarTheme: TabBarTheme(
    labelColor: appPurpleDark,
    unselectedLabelColor: Colors.grey,
    indicator: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: appPurpleDark,
        )
      )
    ),
  ),
);

ThemeData themeDark = ThemeData(
  brightness: Brightness.dark,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: appWhite,
  ),
  primaryColor: appPurple,
  scaffoldBackgroundColor: appPurpleDark,
  appBarTheme: AppBarTheme(
    elevation: 4,
    backgroundColor: appPurpleDark,
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(
      color: appWhite,
    ),
    bodyMedium: TextStyle(
      color: appWhite,
    )
  ),
  listTileTheme: ListTileThemeData(
    textColor: appWhite,
  ),
  tabBarTheme: TabBarTheme(
    labelColor: appWhite,
    unselectedLabelColor: Colors.grey,
    indicator: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: appWhite,
        )
      )
    ),
  ),
);