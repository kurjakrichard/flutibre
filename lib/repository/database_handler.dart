import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../model/book.dart';
import '../model/booklist_item.dart';
import '../model/data.dart';

class DatabaseHandler {
  static DatabaseHandler? _databaseHelper;
  static Database? _database;

  DatabaseHandler._createInstance();

  Future<Database> get database async {
    _database ??= await initialDatabase();
    return _database!;
  }

  void restartDatabase() async {
    _database = await initialDatabase();
  }

  factory DatabaseHandler() {
    _databaseHelper ??= DatabaseHandler._createInstance();
    return _databaseHelper!;
  }

  Future<Database> initialDatabase() async {
    String? path = await getPath();

    if (path == null) {
      return await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    }
    if (Platform.isWindows || Platform.isLinux) {
      return await desktopDatabase(path);
    } else {
      return await mobileDatabase(path);
    }
  }

  Future<String?> getPath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? path = prefs.getString('path');
    return path;
  }

  Future<Database> desktopDatabase(String? path) async {
    sqfliteFfiInit();
    DatabaseFactory databaseFactory = databaseFactoryFfi;
    String dbpath = '$path/metadata.db';
    Database database = await databaseFactory.openDatabase(dbpath);

    return database;
  }

  Future<Future<Database>> mobileDatabase(String? path) async {
    return openDatabase(
      p.join(path!, '/metadata.db'),
      onCreate: (database, version) async {
        //never run
        await database.execute(
          "CREATE TABLE books(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, series_index REAL, author_sort TEXT NOT NULL )",
        );
      },
      version: 1,
    );
  }

  // Get Booklist from database
  Future<List<BookListItem>> getBookList() async {
    _database = await initialDatabase();
    List<Map<String, dynamic>> bookMapList = await _database!.rawQuery(
        'SELECT DISTINCT books.id, (SELECT group_concat(name, " & ") from authors INNER JOIN books_authors_link on authors.id = books_authors_link.author WHERE book = books.id) as name, author_sort, title, books.sort, series_index, has_cover, path from books INNER JOIN books_authors_link on books.id = books_authors_link.book INNER JOIN authors on books_authors_link.author = authors.id ORDER BY books.sort');
    List<BookListItem> bookListItems = <BookListItem>[];

    for (var item in bookMapList) {
      BookListItem bookListItem = BookListItem.fromMap(item);

      bookListItems.add(bookListItem);
    }
    return bookListItems;
  }

  // Get Booklist from database
  Future<List<BookListItem>> getResultBookList(String searchItem) async {
    _database = await initialDatabase();
    List<Map<String, dynamic>> bookMapList = await _database!.rawQuery(
        'SELECT DISTINCT books.id, (SELECT group_concat(name, " & ") from authors INNER JOIN books_authors_link on authors.id = books_authors_link.author WHERE book = books.id) as name, author_sort, title, books.sort, series_index, has_cover, path from books INNER JOIN books_authors_link on books.id = books_authors_link.book INNER JOIN authors on books_authors_link.author = authors.id WHERE title LIKE ? OR name LIKE ? ORDER BY books.sort',
        ['%${searchItem.toLowerCase()}%', '%${searchItem.toLowerCase()}%']);
    List<BookListItem> bookListItems = <BookListItem>[];

    for (var item in bookMapList) {
      BookListItem bookListItem = BookListItem.fromMap(item);

      bookListItems.add(bookListItem);
    }
    return bookListItems;
  }

  // Get Booklist from database
  Future<List<Book>> getAllBooks() async {
    List<Map<String, dynamic>> bookMapList =
        await _database!.query('books', orderBy: 'title');
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
    List<Map<String, dynamic>> dataMapList =
        await _database!.query('data', where: 'book = ?', whereArgs: [id]);
    List<Data> dataList = <Data>[];

    for (var item in dataMapList) {
      Data data = Data.fromMap(item);
      dataList.add(data);
    }
    return dataList;
  }

  // Insert Operation: Insert new record to database
  Future<int> insertBook(Book book) async {
    if (Platform.isWindows || Platform.isLinux) {
      try {
        await _database!.execute('DROP TRIGGER books_insert_trg');
        return await _database!.insert('books', book.toMap());
      } catch (e) {
        throw Exception('Some error$e');
      } finally {
        await _database!.rawQuery(
            'CREATE TRIGGER books_insert_trg AFTER INSERT ON books BEGIN UPDATE books SET sort=title_sort(NEW.title),uuid=uuid4() WHERE id=NEW.id; END');
      }
    } else {
      return await _database!.insert('books', book.toMap());
    }
  }

  // Update Operation: Update record in the database
  Future<int> updateBook(Book book) async {
    var result = await _database!
        .update('books', book.toMap(), where: 'id = ?', whereArgs: [book.id]);
    return result;
  }

  // Delete Operation: Delete record from database
  Future<int> deleteBook(int id) async {
    int result =
        await _database!.delete('books', where: 'id = ?', whereArgs: [id]);
    return result;
  }

  // Get the numbers of the records in database
  Future<int> getCountBooks() async {
    List<Map<String, dynamic>> records =
        await _database!.rawQuery('SELECT COUNT (*) FROM books');
    int result = Sqflite.firstIntValue(records) ?? 0;
    return result;
  }

  Future<String> getCoverPath(String dbPath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? path = prefs.getString('path');
    String coverPath = '${path!}/$dbPath/cover.jpg';
    return await File(coverPath).exists() ? coverPath : 'images/cover.jpg';
  }
}
