// ignore_for_file: depend_on_referenced_packages
import 'dart:async';
import 'dart:io';
import '../main.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import '../model/author.dart';
import '../model/book.dart';
import '../model/booklist_item.dart';
import '../model/comment.dart';
import '../model/data.dart';

class DatabaseHandler {
  static DatabaseHandler? _databaseHelper;
  static Database? _database;

  DatabaseHandler.createInstance();

  Future<Database> get database async {
    _database ??= await initialDatabase();
    return _database!;
  }

  factory DatabaseHandler() {
    _databaseHelper ??= DatabaseHandler.createInstance();
    return _databaseHelper!;
  }

  Future<Database> initialDatabase() async {
    if (prefs.getString('path') == null ||
        await Directory(prefs.getString('path')!).list().isEmpty) {
      return sqlite3.openInMemory();
    } else {
      return sqlite3.open('${prefs.getString('path')!}/metadata.db');
    }
  }

  // Get Booklist from database
  Future<List<BookListItem>> getBookItemList() async {
    _database = await initialDatabase();
    var resultSet = await _database!.select('SELECT COUNT(*) FROM books');
    int? count = resultSet.length;

    List<BookListItem> bookListItems = <BookListItem>[];

    if (count != 0) {
      var resultSet = await _database!.select(
          'SELECT DISTINCT books.id, (SELECT group_concat(name) from authors INNER JOIN books_authors_link on authors.id = books_authors_link.author WHERE book = books.id) as name, author_sort, title, books.sort, series_index, timestamp, has_cover, path from books INNER JOIN books_authors_link on books.id = books_authors_link.book INNER JOIN authors on books_authors_link.author = authors.id ORDER BY books.sort');
      print(resultSet.length);
      for (var item in resultSet) {
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
    List<Map<String, dynamic>> bookMapList = _database!.select(
        'SELECT DISTINCT books.id, (SELECT group_concat(name) from authors INNER JOIN books_authors_link on authors.id = books_authors_link.author WHERE book = books.id) as name, author_sort, title, books.sort, series_index, timestamp, has_cover, path from books INNER JOIN books_authors_link on books.id = books_authors_link.book INNER JOIN authors on books_authors_link.author = authors.id WHERE title LIKE ? OR name LIKE ? ORDER BY books.sort',
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
        _database!.select('SELECT * FROM books WHERE id = $id');

    Book bookById = Book.fromMap(bookMapById[0]);
    return bookById;
  }

  // Get book by id
  Future<Comment> getCommentById(int id) async {
    List<Map<String, dynamic>> dataMapList =
        await _database!.select('SELECT * FROM comments WHERE book = $id');
    Comment comment =
        dataMapList.isEmpty ? const Comment() : Comment.fromMap(dataMapList[0]);
    return comment;
  }

  // Get authors by bookid
  Future<List<Author>> getAuthorsByBookId(int bookId) async {
    List<Map<String, dynamic>> dataMapList = _database!.select(
        'SELECT authors.id, authors.name, authors.sort, authors.link from authors INNER JOIN books_authors_link on authors.id = books_authors_link.author WHERE books_authors_link.book = $bookId ');
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
        _database!.select('SELECT * FROM data WHERE book = $id');
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

  // Delete Operation: Delete record from database
  void deleteBook(int id) async {
    _database!.execute('DELETE FROM books WHERE id = $id');
  }
/*
  // Insert Operation: Insert new record to database
  Future<int> insertBook(Book book) async {
    if (Platform.isWindows || Platform.isLinux) {
      try {
        await _database!.execute('DROP TRIGGER books_insert_trg');
        return await _database!.insert('books', book.toMap());
      } catch (e) {
        throw Exception('Some error$e');
      } finally {
         _database!.select(
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

  

  // Get the numbers of the records in database
  Future<int> getCountBooks() async {
    List<Map<String, dynamic>> records =
        await _database!.rawQuery('SELECT COUNT (*) FROM books');
    int result = Sqflite.firstIntValue(records) ?? 0;
    return result;
  }*/
}
