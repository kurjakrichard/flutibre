import 'package:flutibre/screens/settingspage.dart';
import 'package:flutibre/utils/book_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'screens/book_details_page.dart';
import 'screens/mainwindow.dart';
import 'utils/custom_scroll_behavior.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Provider.debugCheckInvalidValueType = null;

  //Check path
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isPath = await prefs.containsKey("path");

  //Check database
  bool isDb = false;
  isPath
      ? isDb = await databaseFactory
          .databaseExists(await prefs.getString("path")! + '/metadata.db')
      : isDb = false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BookProvider()),
      ],
      child: Flutibre(isPath, isDb),
    ),
  );
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
    return TextTheme(
      //appbar text
      displayLarge: TextStyle(
          fontWeight: FontWeight.normal, color: Colors.white, fontSize: 20),
      //belső fejléc szövegek
      titleMedium: TextStyle(
          fontWeight: FontWeight.normal, color: Colors.black, fontSize: 16),
      titleSmall: TextStyle(
          fontWeight: FontWeight.normal, color: Colors.black, fontSize: 15),
      //gombszövegek
      displaySmall: TextStyle(
          fontWeight: FontWeight.normal, color: Colors.white, fontSize: 15),
      //nagyobb lista szövegek
      bodyLarge: TextStyle(
          fontWeight: FontWeight.normal, color: Colors.black, fontSize: 15),
      //kisebb lista szövegek
      bodyMedium: TextStyle(
          fontWeight: FontWeight.normal, color: Colors.black, fontSize: 12),
      //vastag belső szövegek
      displayMedium: TextStyle(
          fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15),
    );
  }
}
