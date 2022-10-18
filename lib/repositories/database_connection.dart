import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';

class DatabaseConnection {
  static DatabaseConnection? _databaseConnection;
  DatabaseConnection._createInstance();
  Map table = {
    'tableName': 'categories',
    'colId': 'id',
    'colName': 'name',
    'colDescription': 'description'
  };

  bool _isDatabaseExist = false;

  bool get isDatabaseExist => _isDatabaseExist;

  factory DatabaseConnection() {
    _databaseConnection ??= DatabaseConnection._createInstance();
    return _databaseConnection!;
  }

  set isDatabaseExist(bool isDatabaseExist) {
    _isDatabaseExist = isDatabaseExist;
  }

  Future<Database> initializeDB() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? path = await prefs.getString('path');
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      DatabaseFactory databaseFactory = databaseFactoryFfi;
      String dbpath = '${path}/metadata.db';
      Database database = await databaseFactory.openDatabase(dbpath);
      _isDatabaseExist = true;
      return database;
    } else {
      return openDatabase(
        join(path!, '/metadata.db'),
        onCreate: (database, version) async {
          _isDatabaseExist = true;
          //never run
          await database.execute(
            "CREATE TABLE books(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, series_index REAL, author_sort TEXT NOT NULL )",
          );
        },
        version: 1,
      );
    }
  }
}
