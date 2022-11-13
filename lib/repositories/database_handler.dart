import 'dart:io';

import 'package:flutibre/models/book.dart';
import 'package:flutibre/repositories/database_connection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHandler {
  DatabaseConnection? _databaseConnection;

  DatabaseHandler() {
    _databaseConnection = DatabaseConnection();
  }

  static Database? _database;

  Future<Database>? get database async {
    if (_database == null) {
      _database = await _databaseConnection!.initializeDB();
      return _database!;
    }
    return _database!;
  }

  // Get Booklist from database
  Future<List<Book>> getAllBooks() async {
    Database? db = await database;
    List<Map<String, dynamic>> bookMapList =
        await db!.query('books', orderBy: 'title');
    List<Book> bookList = <Book>[];

    for (var item in bookMapList) {
      Book book = Book.fromMap(item);
      bookList.add(book);
    }
    return bookList;
  }

  // Insert Operation: Insert new record to database
  Future<int> insertBook(Book book) async {
    Database db = await database!;
    if (Platform.isWindows || Platform.isLinux) {
      try {
        await db.execute('DROP TRIGGER books_insert_trg');
        return await db.insert('books', book.toMap());
      } catch (e) {
        throw Exception('Some error$e');
      } finally {
        await db.rawQuery(
            'CREATE TRIGGER books_insert_trg AFTER INSERT ON books BEGIN UPDATE books SET sort=title_sort(NEW.title),uuid=uuid4() WHERE id=NEW.id; END');
      }
    } else {
      return await db.insert('books', book.toMap());
    }
  }

  // Update Operation: Update record in the database
  Future<int> updateBook(Book book) async {
    var db = await database;
    var result = await db!
        .update('books', book.toMap(), where: 'id = ?', whereArgs: [book.id]);
    return result;
  }

  // Delete Operation: Delete record from database
  Future<int> deleteBook(int id) async {
    var db = await database;
    int result = await db!.delete('books', where: 'id = ?', whereArgs: [id]);
    return result;
  }

  // Get the numbers of the records in database
  Future<int> getCountBooks() async {
    Database db = await database!;
    List<Map<String, dynamic>> records =
        await db.rawQuery('SELECT COUNT (*) FROM books');
    int result = Sqflite.firstIntValue(records) ?? 0;
    return result;
  }

  Future<String> getCoverPath(String dbPath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? path = await prefs.getString('path');
    String coverPath = path! + '/' + dbPath + '/cover.jpg';
    return await File(coverPath).exists() ? coverPath : 'images/cover.jpg';
  }
}
