import 'dart:io';

import 'package:flutibre/model/book.dart';
import 'package:flutibre/model/booklist_item.dart';
import 'package:flutibre/repository/database_connection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../model/data.dart';

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

  void restartDatabase() async {
    _database!.close();
    _database = await _databaseConnection!.initializeDB();
  }

  // Get Booklist from database
  Future<List<BookListItem>> getBookList() async {
    String and = '&';
    Database? db = await database;
    List<Map<String, dynamic>> bookMapList = await db!.rawQuery(
        'SELECT DISTINCT books.id, (SELECT group_concat(name, " & ") from authors INNER JOIN books_authors_link on authors.id = books_authors_link.author WHERE book = books.id) as name, author_sort, title, books.sort, series_index, has_cover, path from books INNER JOIN books_authors_link on books.id = books_authors_link.book INNER JOIN authors on books_authors_link.author = authors.id ORDER BY books.sort');
    List<BookListItem> bookListItems = <BookListItem>[];

    for (var item in bookMapList) {
      BookListItem bookListItem = BookListItem.fromMap(item);

      bookListItems.add(bookListItem);
    }
    return bookListItems;
  }

  // Get Booklist from database
  Future<List<Book>> getAllBooks() async {
    Database? db = await database;
    List<Map<String, dynamic>> bookMapList =
        await db!.query('books', orderBy: 'title');
    List<Book> bookList = <Book>[];

    for (var item in bookMapList) {
      Book book = Book.fromMap(item);
      book.formats = await getFormatsById(book.id);
      bookList.add(book);
    }
    return bookList;
  }

  // Get book formats from database
  Future<List<Data>> getFormatsById(int id) async {
    Database? db = await database;
    List<Map<String, dynamic>> dataMapList =
        await db!.query('data', where: 'book = ?', whereArgs: [id]);
    List<Data> dataList = <Data>[];

    for (var item in dataMapList) {
      Data data = Data.fromMap(item);
      dataList.add(data);
    }
    return dataList;
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
