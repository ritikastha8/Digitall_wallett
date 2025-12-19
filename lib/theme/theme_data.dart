import 'package:flutter/material.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    // primarySwatch: Colors.orange,
    // scaffoldBackgroundColor: Colors.grey[200],
    // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    useMaterial3: false,
    // fontFamily: 'Open Sans',

    // APP BAR
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      // foregroundColor: Colors.white,
      titleTextStyle: const TextStyle(
        fontSize: 36,
        color: Color(0xFFD87920),
        // fontWeight: FontWeight.w500,
        fontWeight: FontWeight.bold,
        fontFamily: 'Great Vibes',
      ),
    ),

    // BUTTON
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontFamily: 'Roboto Semibold',
        ),
        backgroundColor: Color(0xFFD87920),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
    ),

    // // Operation and logo label
    // textTheme: const TextTheme(
    //   // Operation button label
    //   bodySmall: TextStyle(
    //     fontFamily: 'Roboto',
    //     fontSize: 12,
    //     fontWeight: FontWeight.w600, // Semibold
    //     color: Colors.black,
    //   ),
    // ),

    // TEXT THEME (for titles, body, etc.)
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontFamily: 'Roboto Semibold', // Login title and big headers
        fontSize: 32,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Roboto Regular', // body text
        fontSize: 16,
        // fontWeight: FontWeight.w400,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Roboto Regular', // body text
        fontSize: 12,
      ),
      bodySmall: TextStyle(
        fontFamily: 'Roboto Regular',
        color: Color(0xFFD87920),
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),
    // TEXTFIELDS
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: Colors.grey),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: Colors.grey),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: Color(0xFFD87920), width: 2),
      ),

      // labelStyle: TextStyle(
      //   color: const Color.fromARGB(255, 12, 146, 230),
      //   // fontFamily: 'Open Sans Italic',
      // ),
      hintStyle: TextStyle(
        color: Color(0xFFD87920),
        fontFamily: 'Roboto Regular',
        fontWeight: FontWeight.w600,
      ),
    ),

    //BOTTOM NAVIGATION
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Color(0xFFD87920),
      unselectedItemColor: Colors.black,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,

      selectedLabelStyle: TextStyle(
        fontFamily: 'Roboto Semibold', //  Roboto
        fontSize: 13,
        fontWeight: FontWeight.w800,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: 'Roboto Semibold',
        fontSize: 12,
        fontWeight: FontWeight.w200,
      ),
    ),
  );
}


//theme, font, bottom navigation 