import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../resources/colors.dart';

class AppTheme {
  static ThemeData lightTheme(BuildContext context) => ThemeData(
        brightness: Brightness.light,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme).apply(bodyColor: Colors.black),
        dialogBackgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
        ),
        dialogTheme: const DialogTheme(
          backgroundColor: dialogBackgroundColor,
        ),
        cardColor: containerBackgroundColor,
        splashFactory: NoSplash.splashFactory,
      );
  static ThemeData darkTheme(BuildContext context) => ThemeData(
        brightness: Brightness.dark,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme).apply(
          bodyColor: Colors.white,
        ),
        scaffoldBackgroundColor: darkScaffoldBackgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: darkScaffoldBackgroundColor,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: darkScaffoldBackgroundColor,
        ),
        dialogTheme: const DialogTheme(
          backgroundColor: darkScaffoldBackgroundColor,
        ),
        // cardColor: darkScaffoldBackgroundColor,
        cardColor: darkModeContainerBackgroundColor,
        splashFactory: NoSplash.splashFactory,
      );
}
