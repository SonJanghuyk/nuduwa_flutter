import 'package:flutter/material.dart';

class NuduwaThemes {
  // static ThemeData get lightTheme => ThemeData(
  //       primarySwatch: NuduwaColors.primaryMaterialColor,
  //       fontFamily: 'OmyuPretty',
  //       scaffoldBackgroundColor: Colors.white,
  //       // splashColor: Colors.white,
  //       textTheme: _textTheme,
  //       appBarTheme: _appBarTheme,
  //       brightness: Brightness.light,
  //       useMaterial3: true,
  //       floatingActionButtonTheme: FloatingActionButtonThemeData(
  //         elevation: 0,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(100),
  //         ),
  //       ),
  //       popupMenuTheme: const PopupMenuThemeData(
  //         enableFeedback: false,
  //       ),
  //     );
  // static ThemeData get dartTheme => ThemeData(
  //       primarySwatch: NuduwaColors.primaryMaterialColor,
  //       fontFamily: 'OmyuPretty',
  //       // splashColor: Colors.white,
  //       textTheme: _textTheme,
  //       brightness: Brightness.dark,
  //       useMaterial3: true,
  //     );
  static ThemeData get darkTheme => _nuduwaThemes.copyWith(
  );

  static ThemeData get _nuduwaThemes => ThemeData(
        fontFamily: 'OmyuPretty',
      );
}
