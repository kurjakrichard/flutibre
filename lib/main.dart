import 'package:flutibre/screens/settingspage.dart';
import 'package:flutibre/repositories/database_connection.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.cyan,
            foregroundColor: Colors.white,
          ),
          scaffoldBackgroundColor: Colors.cyan[50],
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.cyan, foregroundColor: Colors.white),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.cyan,
            ),
          ),
        ),
        scrollBehavior: CustomScrollBehavior(),
        debugShowCheckedModeBanner: false,
        //Settingspage if database not set or not exist
        home: isPath && isDb ? MainWindow() : SettingsPage());
  }
}
