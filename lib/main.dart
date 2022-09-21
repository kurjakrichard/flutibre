import 'package:flutibre/screens/settingspage.dart';
import 'package:flutibre/repositories/database_connection.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/mainwindow.dart';

void main() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isPath = await prefs.containsKey("path");
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
        debugShowCheckedModeBanner: false,
        home: isPath && isDb ? MainWindow() : SettingsPage());
  }
}
