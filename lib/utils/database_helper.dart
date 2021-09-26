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
  String colAuthor_sort = 'author_sort';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> initialDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'metadata.db';
    var bookDatabase = await databaseFactoryFfi.openDatabase(path);
    await bookDatabase.execute(
        'CREATE TABLE $colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT,'
        '$colAuthor_sort TEXT');
    return bookDatabase;
  }
}
