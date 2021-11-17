import 'dart:html';

import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:flutibre/models/book.dart';

class DatabaseHelper {
  // ignore: unused_field
  static late final DatabaseHelper _databaseHelper;
  static late Database _database;

  String bookTable = 'books';
  String colId = 'id';
  String colTitle = 'title';
  String colAuthorSort = 'author_sort';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initialDatabase();
    }

    return _database;
  }

  Future<Database> initialDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'metadata.db';
    var bookDatabase = await databaseFactoryFfi.openDatabase(path);
    return bookDatabase;
  }

  void createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $bookTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT,'
        '$colAuthorSort TEXT)');
  }

  getBookMapList() async {
    Database db = await this.database;
    var result =
        await db.rawQuery('SELECT * FROM $bookTable order by $colTitle');
  }
}
