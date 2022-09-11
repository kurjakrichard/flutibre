import 'package:flutibre/screens/settingspage.dart';
import 'package:flutibre/utils/database_handler.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/mainwindow.dart';

void main() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isPath = await prefs.containsKey("path");
  DatabaseHandler db = DatabaseHandler();
  bool isDb = db.isDb();
  runApp(Flutibre(isPath, isDb));
}

class Flutibre extends StatelessWidget {
  Flutibre(this.isPath, this.isDb, {Key? key}) : super(key: key);

  final bool isPath;
  final bool isDb;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: isPath && isDb ? MyApp() : SettingsPage());
  }
}
