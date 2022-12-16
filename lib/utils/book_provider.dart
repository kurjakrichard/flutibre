import 'package:flutter/material.dart';
import '../model/booklist_item.dart';
import '../repository/database_handler.dart';

import '../model/book.dart';

class BookProvider with ChangeNotifier {
  List<Book> _books = [];
  List<Book> get books => _books;
  DatabaseHandler? _databaseHandler;

  BookProvider() {
    _databaseHandler = DatabaseHandler();
  }

  void addBook(Book book) async {
    await _databaseHandler!.insertBook(book);
    _books = await _databaseHandler!.getAllBooks();
    notifyListeners();
  }

  Future<List<Book>> getAllBooks() async {
    return await _databaseHandler!.getAllBooks();
  }

  Future<List<BookListItem>> getBookList() async {
    return await _databaseHandler!.getBookList();
  }

  void getBooks() async {
    _books = await _databaseHandler!.getAllBooks();
    notifyListeners();
  }

  void deleteBook(int id) async {
    await _databaseHandler!.deleteBook(id);
    _books = await _databaseHandler!.getAllBooks();
    notifyListeners();
  }
}
