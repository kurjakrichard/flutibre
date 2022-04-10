import 'package:flutibre/utils/settings_provider.dart';
import 'package:flutibre/models/book.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHandler {
  final String tableName = 'books';
  SettingsProvider settingsProvider = SettingsProvider();

  Future<Database> initializeDB() async {
    String path = await settingsProvider.readJsonData();

    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      DatabaseFactory databaseFactory = databaseFactoryFfi;
      String dbpath = '${path}metadata.db';
      print(dbpath);
      Database db = await databaseFactory.openDatabase(dbpath);
      return db;
    } else {
      String path = await getDatabasesPath();
      return openDatabase(
        join(path, 'usereleven.db'),
        onCreate: (database, version) async {
          await database.execute(
            "CREATE TABLE usereleven(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, location TEXT NOT NULL)",
          );
        },
        version: 1,
      );
    }
  }

  Future<int> addBook(List<Book> books) async {
    int result = 0;
    final Database db = await initializeDB();
    for (var book in books) {
      result = await db.insert(tableName, book.toMap());
    }
    return result;
  }

  Future<List<Book>> retrieveBooks() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query(tableName);
    return queryResult.map((e) => Book.fromMap(e)).toList();
  }
}
