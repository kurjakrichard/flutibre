import 'package:flutibre_pro/model/booklist_item.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../repository/database_handler.dart';

class BookListProvider with ChangeNotifier {
  BookListProvider() {
    databaseHandler = DatabaseHandler();
    if (prefs.containsKey("path")) {
      getBookItemList();
    }
  }

  late Future<List<BookListItem>>? _allBooks;
  late Future<List<BookListItem>>? _currentBooks;
  Future<List<BookListItem>>? get currentBooks => _currentBooks;

  DatabaseHandler? databaseHandler;

  Future<void> getBookItemList() async {
    _allBooks = databaseHandler!.getBookList();
    _currentBooks = _allBooks;
    notifyListeners();
  }

  Future<void> filteredBookList(String? searchItem) async {
    if (searchItem == null) {
      getBookItemList();
    } else {
      Future<List<BookListItem>> filteredBookList =
          databaseHandler!.getResultBookList(searchItem);
      _currentBooks = filteredBookList;
    }
    notifyListeners();
  }

  void toggleAllBooks() {
    _currentBooks = _allBooks;
    notifyListeners();
  }
}
