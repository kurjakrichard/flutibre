// ignore_for_file: depend_on_referenced_packages
import 'dart:async';
import 'dart:io';
import 'package:flutibre/model/books_authors_link.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'package:sqlite3/sqlite3.dart';
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
    var resultSet = _database!.select('SELECT COUNT(*) FROM books');
    int? count = resultSet.length;

    List<BookListItem> bookListItems = <BookListItem>[];

    if (count != 0) {
      var resultSet = _database!.select(
          'SELECT DISTINCT books.id, (SELECT group_concat(name) from authors INNER JOIN books_authors_link on authors.id = books_authors_link.author WHERE book = books.id) as name, author_sort, title, books.sort, series_index, timestamp, has_cover, path from books INNER JOIN books_authors_link on books.id = books_authors_link.book INNER JOIN authors on books_authors_link.author = authors.id ORDER BY books.sort');

      for (var item in resultSet) {
        BookListItem bookListItem = BookListItem.fromMap(item);
        bookListItems.add(bookListItem);
      }
      return bookListItems;
    }
    _database!.dispose();
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
    _database = await initialDatabase();
    List<Map<String, dynamic>> bookMapById =
        _database!.select('SELECT * FROM books WHERE id = $id');

    Book bookById = Book.fromMap(bookMapById[0]);
    return bookById;
  }

  // Get book by id
  Future<Comment> getCommentById(int id) async {
    _database = await initialDatabase();
    List<Map<String, dynamic>> dataMapList =
        _database!.select('SELECT * FROM comments WHERE book = $id');
    Comment comment =
        dataMapList.isEmpty ? const Comment() : Comment.fromMap(dataMapList[0]);
    return comment;
  }

// Get Booklist from database
  Future<List<Author>> getAuthorList() async {
    _database = await initialDatabase();
    var resultSet = _database!.select('SELECT COUNT(*) FROM authors');
    int? count = resultSet.length;
    List<Author> authorList = <Author>[];

    if (count != 0) {
      var resultSet = _database!.select('SELECT * from authors');
      for (var item in resultSet) {
        Author author = Author.fromMap(item);
        authorList.add(author);
      }
      return authorList;
    }
    return authorList;
  }

  // Get authors by bookid
  Future<List<Author>> getAuthorsByBookId(int bookId) async {
    _database = await initialDatabase();
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
    _database = await initialDatabase();
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

// Check the author has a book
  Future<bool> checkAuthorBook(int id) async {
    _database = await initialDatabase();
    List<Map<String, dynamic>> authorMapById =
        _database!.select('SELECT * FROM books_authors_link WHERE id = $id');
    return authorMapById.isEmpty ? false : true;
  }

  Future<int> authorIdByAuthorsort(String authorSort) async {
    String author = "'$authorSort'";
    _database = await initialDatabase();
    List<Map<String, dynamic>> authorMapById =
        _database!.select('SELECT * FROM authors WHERE sort = $author');
    return authorMapById.isNotEmpty ? authorMapById[0]['id'] : 0;
  }

  // Delete Operation: Delete book from database
  void deleteBook(Book book) async {
    _database = await initialDatabase();
    int authorId = await authorIdByAuthorsort(book.author_sort);
    _database!.execute('DELETE FROM books WHERE id = ${book.id}');
    bool checkAuthorHasBook = await checkAuthorBook(authorId);
    if (!checkAuthorHasBook) {
      deleteAuthor(authorId);
    }
  }

  // Delete Operation: Delete author from database
  void deleteAuthor(int authorId) async {
    _database = await initialDatabase();
    _database!.execute('DELETE FROM authors WHERE id = $authorId');
  }

  // Insert Operation: Insert new record to database
  void insertBook(Book book) async {
    _database = await initialDatabase();
    try {
      _database!.execute('DROP TRIGGER books_insert_trg');
      final stmt = _database!.prepare(
          'INSERT INTO books (title, sort, author_sort) VALUES (?, ?, ?)');
      stmt.execute([book.title, book.sort, book.author_sort]);
    } catch (e) {
      throw Exception('Some error$e');
    } finally {
      _database!.execute(
          'CREATE TRIGGER books_insert_trg AFTER INSERT ON books BEGIN UPDATE books SET sort=title_sort(NEW.title),uuid=uuid4() WHERE id=NEW.id; END');
    }
  }

  void insertBooksAuthorsLink(BooksAuthorsLink booksAuthorsLink) async {
    _database = await initialDatabase();
    try {
      _database!.execute('DROP TRIGGER "main"."fkc_insert_books_authors_link"');
      final stmt = _database!.prepare(
          'INSERT INTO books_authors_link (book, author) VALUES (?, ?)');
      return stmt.execute([booksAuthorsLink.book, booksAuthorsLink.author]);
    } catch (e) {
      throw Exception('Some error$e');
    } finally {
      _database!.execute('''CREATE TRIGGER fkc_insert_books_authors_link
        BEFORE INSERT ON books_authors_link
        BEGIN
          SELECT CASE
              WHEN (SELECT id from books WHERE id=NEW.book) IS NULL
              THEN RAISE(ABORT, 'Foreign key violation: book not in books')
              WHEN (SELECT id from authors WHERE id=NEW.author) IS NULL
              THEN RAISE(ABORT, 'Foreign key violation: author not in authors')
          END;
        END''');
    }
  }

  // Insert Operation: Insert new record to database
  void insertAuthor(Author author) async {
    _database = await initialDatabase();
    try {
      final stmt = _database!
          .prepare('INSERT INTO authors (name, sort, link) VALUES (?, ?, ?)');
      return stmt.execute([author.name, author.sort, author.link]);
    } catch (e) {
      throw Exception('Some error$e');
    }
  }

  // Update Operation: Update record in the database
  void updateBook(Book book) async {
    _database = await initialDatabase();
    _database!.execute('');
  }

  // Get the numbers of the records in database
  Future<int> getCountBooks() async {
    ResultSet records = _database!.select('SELECT COUNT (*) FROM books');
    for (var element in records) {
      debugPrint(element.entries.first.toString());
    }
    return records.length;
  }
}
