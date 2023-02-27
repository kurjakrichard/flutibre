import 'dart:async';

import 'package:flutibre/model/booklist_item.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../repository/database_handler.dart';

class BookListProvider extends ChangeNotifier {
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
    String? path = prefs.getString('path');
    if (path == "/home/sire/Letöltések/Ebooks") {
      prefs.setString('path', "/mnt/Data/Menteni/Ebooks");
    } else {
      prefs.setString('path', "/home/sire/Letöltések/Ebooks");
    }
    databaseHandler!.initialDatabase();
    getBookItemList();
    notifyListeners();
  }
}
