import 'package:flutibre/screens/settingspage.dart';
import 'package:flutibre/repositories/database_connection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/book_details_page.dart';
import 'screens/mainwindow.dart';
import 'utils/custom_scroll_behavior.dart';

void main() async {
  //Check path
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isPath = await prefs.containsKey("path");
  //Check database
  DatabaseConnection db = DatabaseConnection();
  await db.initializeDB();
  bool isDb = await db.isDatabaseExist;
  runApp(Flutibre(isPath, isDb));
}

class Flutibre extends StatelessWidget {
  Flutibre(this.isPath, this.isDb, {Key? key}) : super(key: key);

  final bool isPath;
  final bool isDb;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          AppLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('hu', ''),
        ],
        locale: const Locale('hu'),
        routes: {
          '/BookDetailsPage': (context) => const BookDetailsPage(),
          '/MainWindow': (context) => MainWindow(),
          '/SettingsPage': (context) => SettingsPage()
        },
        theme: ThemeData(
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
          textTheme: textTheme(),
        ),
        scrollBehavior: CustomScrollBehavior(),
        debugShowCheckedModeBanner: false,
        //Load SettingsPage if database not set or not exist
        home: isPath && isDb ? MainWindow() : SettingsPage());
  }

  TextTheme textTheme() {
    return const TextTheme(
      //fejléc szövegek
      headline1: TextStyle(
          fontWeight: FontWeight.normal, color: Colors.white, fontSize: 18),
      //belső fejléc szövegek
      subtitle1: TextStyle(
          fontWeight: FontWeight.normal, color: Colors.black, fontSize: 16),
      subtitle2: TextStyle(
          fontWeight: FontWeight.normal, color: Colors.black, fontSize: 15),
      //gombszövegek
      headline3: TextStyle(
          fontWeight: FontWeight.normal, color: Colors.white, fontSize: 15),
      //nagyobb lista szövegek
      bodyText1: TextStyle(
          fontWeight: FontWeight.normal, color: Colors.black, fontSize: 15),
      //kisebb lista szövegek
      bodyText2: TextStyle(
          fontWeight: FontWeight.normal, color: Colors.black, fontSize: 12),
      //vastag belső szövegek
      headline2: TextStyle(
          fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15),
    );
  }
}
