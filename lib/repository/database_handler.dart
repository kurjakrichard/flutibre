// ignore_for_file: depend_on_referenced_packages
import 'package:flutibre/model/author.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../main.dart';
import '../model/book.dart';
import '../model/booklist_item.dart';
import '../model/comment.dart';
import '../model/data.dart';

class DatabaseHandler {
  static DatabaseHandler? _databaseHelper;
  static Database? _database;

  DatabaseHandler._createInstance();

  Future<Database> get database async {
    _database ??= await initialDatabase();
    return _database!;
  }

  factory DatabaseHandler() {
    _databaseHelper ??= DatabaseHandler._createInstance();
    return _databaseHelper!;
  }

  Future<Database> initialDatabase() async {
    if (prefs.getString('path') == null ||
        await Directory(prefs.getString('path')!).list().isEmpty) {
      return await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    }
    if (Platform.isWindows || Platform.isLinux) {
      return await desktopDatabase();
    } else {
      return await mobileDatabase();
    }
  }

  Future<Database> desktopDatabase() async {
    sqfliteFfiInit();
    DatabaseFactory databaseFactory = databaseFactoryFfi;
    _database = await databaseFactory
        .openDatabase('${prefs.getString('path')!}/metadata.db');

    return database;
  }

  Future<Future<Database>> mobileDatabase() async {
    return openDatabase(
      ('${prefs.getString('path')!}/metadata.db'),
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
  Future<List<BookListItem>> getBookItemList() async {
    _database = await initialDatabase();

    int? count = Sqflite.firstIntValue(
        await _database!.rawQuery('SELECT COUNT(*) FROM books'));

    List<Map<String, dynamic>> bookMapList = count != 0
        ? await _database!.rawQuery(
            'SELECT DISTINCT books.id, (SELECT group_concat(name, " & ") from authors INNER JOIN books_authors_link on authors.id = books_authors_link.author WHERE book = books.id) as name, author_sort, title, books.sort, series_index, timestamp, has_cover, path from books INNER JOIN books_authors_link on books.id = books_authors_link.book INNER JOIN authors on books_authors_link.author = authors.id ORDER BY books.sort')
        : [];
    List<BookListItem> bookListItems = <BookListItem>[];

    if (bookMapList.isNotEmpty) {
      for (var item in bookMapList) {
        BookListItem bookListItem = BookListItem.fromMap(item);

        bookListItems.add(bookListItem);
      }
      return bookListItems;
    }

    return bookListItems;
  }

  // Get Booklist from database
  Future<List<BookListItem>> getResultBookList(String searchItem) async {
    _database = await initialDatabase();
    List<Map<String, dynamic>> bookMapList = await _database!.rawQuery(
        'SELECT DISTINCT books.id, (SELECT group_concat(name, " & ") from authors INNER JOIN books_authors_link on authors.id = books_authors_link.author WHERE book = books.id) as name, author_sort, title, books.sort, series_index, timestamp, has_cover, path from books INNER JOIN books_authors_link on books.id = books_authors_link.book INNER JOIN authors on books_authors_link.author = authors.id WHERE title LIKE ? OR name LIKE ? ORDER BY books.sort',
        ['%${searchItem.toLowerCase()}%', '%${searchItem.toLowerCase()}%']);
    List<BookListItem> bookListItems = <BookListItem>[];

    if (bookMapList.isNotEmpty) {
      for (var item in bookMapList) {
        BookListItem bookListItem = BookListItem.fromMap(item);

        bookListItems.add(bookListItem);
      }
      return bookListItems;
    }

    return bookListItems;
  }

  // Get book by id
  Future<Book> getBookById(int id) async {
    List<Map<String, dynamic>> bookMapById =
        await _database!.query('books', where: 'id = ?', whereArgs: [id]);

    Book bookById = Book.fromMap(bookMapById[0]);
    return bookById;
  }

  // Get book by id
  Future<Comment> getCommentById(int id) async {
    List<Map<String, dynamic>> dataMapList =
        await _database!.query('comments', where: 'id = ?', whereArgs: [id]);

    Comment comment =
        dataMapList.isEmpty ? const Comment() : Comment.fromMap(dataMapList[0]);

    return comment;
  }

  // Get authors by bookid
  Future<List<Author>> getAuthorsByBookId(int bookId) async {
    List<Map<String, dynamic>> dataMapList = await _database!.rawQuery(
        'SELECT authors.id, authors.name, authors.sort, authors.link from authors INNER JOIN books_authors_link on authors.id = books_authors_link.author WHERE books_authors_link.book = ? ',
        [bookId]);
    List<Author> dataList = <Author>[];

    for (var item in dataMapList) {
      Author author = Author.fromMap(item);
      dataList.add(author);
    }
    return dataList;
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

  //Get book by id
  Future<Book> selectedBook(int id) async {
    Book? selectedBook = await getBookById(id);
    List<Data>? formats = await getFormatsById(id);
    selectedBook.formats = formats;
    List<Author> authors = await getAuthorsByBookId(id);
    selectedBook.authors = authors;
    Comment comment = await getCommentById(id);
    selectedBook.comment = comment;

    return selectedBook;
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
}
