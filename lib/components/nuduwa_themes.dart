import 'package:flutter/material.dart';

class NuduwaThemes {
  static ThemeData get lightTheme => ThemeData(
        fontFamily: 'OmyuPretty',
        scaffoldBackgroundColor: Colors.white,
        textTheme: _textTheme,
        // appBarTheme: _appBarTheme,
        brightness: Brightness.light,
        useMaterial3: true,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        popupMenuTheme: const PopupMenuThemeData(
          enableFeedback: false,
        ),
      );

  static const TextTheme _textTheme = TextTheme(
    displayLarge: TextStyle(
        fontSize: 96.0, fontWeight: FontWeight.w300, letterSpacing: -1.5),
    displayMedium: TextStyle(
        fontSize: 60.0, fontWeight: FontWeight.w300, letterSpacing: -0.5),
    displaySmall: TextStyle(
        fontSize: 38.0, fontWeight: FontWeight.w300, letterSpacing: 0),
    headlineLarge: TextStyle(
        fontSize: 34.0, fontWeight: FontWeight.w600, letterSpacing: 0.25),
    headlineMedium: TextStyle(
        fontSize: 24.0, fontWeight: FontWeight.w600, letterSpacing: 0.25),
    headlineSmall: TextStyle(
        fontSize: 20.0, fontWeight: FontWeight.w600, letterSpacing: 0.15),
    titleLarge: TextStyle(
        fontSize: 24.0, fontWeight: FontWeight.w500, letterSpacing: 0.15),
    titleMedium: TextStyle(
        fontSize: 18.0, fontWeight: FontWeight.w500, letterSpacing: 0.15),
    titleSmall: TextStyle(
        fontSize: 16.0, fontWeight: FontWeight.w500, letterSpacing: 0.15),
    bodyLarge: TextStyle(
        fontSize: 20.0, fontWeight: FontWeight.normal, letterSpacing: 0.5),
    bodyMedium: TextStyle(
        fontSize: 14.0, fontWeight: FontWeight.normal, letterSpacing: 0.25),
    bodySmall: TextStyle(
        fontSize: 12.0, fontWeight: FontWeight.normal, letterSpacing: 0.25),
    labelLarge: TextStyle(
        fontSize: 14.0, fontWeight: FontWeight.w500, letterSpacing: 1.25),
    labelMedium: TextStyle(
        fontSize: 12.0, fontWeight: FontWeight.w500, letterSpacing: 1.25),
    labelSmall: TextStyle(
        fontSize: 10.0, fontWeight: FontWeight.w500, letterSpacing: 1.25),
  );
}
