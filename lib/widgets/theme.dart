import 'package:flutter/material.dart';

ThemeData darkTheme =
    ThemeData(brightness: Brightness.dark, fontFamily: 'Roboto');
ThemeData darkTheme2 = ThemeData.dark();
ThemeData darkTheme3 = ThemeData(
  textTheme: textTheme().copyWith(
    displayMedium: const TextStyle(
        fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.grey,
  ),
  scaffoldBackgroundColor: Colors.black87,
  colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
      .copyWith(secondary: Colors.blueAccent, brightness: Brightness.dark),
);
ThemeData baseTheme = ThemeData(
  useMaterial3: true,
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.cyan,
      unselectedItemColor: Colors.grey,
      selectedItemColor: Colors.white),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.cyan,
    foregroundColor: Colors.white,
  ),
  scaffoldBackgroundColor: Colors.cyan[50],
  fontFamily: 'Roboto',
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.cyan, foregroundColor: Colors.white),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Colors.cyan,
    ),
  ),
);
ThemeData lightTheme = ThemeData.light();
ThemeData lightTheme2 = ThemeData(
    textTheme: textTheme().copyWith(
      displayMedium: const TextStyle(
          fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15),
    ),
    scaffoldBackgroundColor: Colors.grey[100],
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.blue,
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(
        secondary: Colors.lightBlueAccent, brightness: Brightness.light));
ThemeData lightTheme3 = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.green[100],
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
        .copyWith(secondary: Colors.lightBlueAccent));
ThemeData customTheme = ThemeData.light().copyWith(
  textTheme: textTheme().copyWith(
    displayMedium: const TextStyle(
        fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15),
  ),
);
TextTheme textTheme() {
  return const TextTheme(
    //appbar text
    displayLarge: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
    //vastag belső szövegek
    displayMedium: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
    //gombszövegek
    displaySmall: TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
    //nagyobb lista szövegek
    //belső fejléc szövegek
    titleMedium: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
    titleSmall: TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
    bodyLarge: TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
    //kisebb lista szövegek
    bodyMedium: TextStyle(
        fontWeight: FontWeight.normal, color: Colors.black, fontSize: 12),
  );
}
