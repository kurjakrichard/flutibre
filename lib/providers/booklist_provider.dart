import 'package:flutibre_pro/model/booklist_item.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../repository/database_handler.dart';

class BookListProvider with ChangeNotifier {
  BookListProvider() {
    databaseHandler = DatabaseHandler();
    if (prefs.containsKey("path")) {
      initialBookItemList();
      _allBooks2 = databaseHandler!.getBookList();
      _currentBooks2 = _allBooks2;
    }
  }

  late Future<List<BookListItem>>? _allBooks2;
  late Future<List<BookListItem>>? _currentBooks2;
  List<BookListItem> _allBooks = [];
  List<BookListItem> _currentBooks = [];
  Future<List<BookListItem>>? get currentBooks2 => _currentBooks2;
  List<BookListItem> get currentBooks => _currentBooks;
  DatabaseHandler? databaseHandler;

  Future<void> filteredBookList(String? searchItem) async {
    if (searchItem == null) {
      initialBookItemList();
    } else {
      List<BookListItem> filteredBookList = [];
      late Future<List<BookListItem>> filteredBookList2;
      filteredBookList = await databaseHandler!.getResultBookList(searchItem);
      filteredBookList2 = databaseHandler!.getResultBookList(searchItem);
      _currentBooks2 = filteredBookList2;
      _currentBooks = filteredBookList;
    }

    notifyListeners();
  }

  void initialBookItemList() async {
    _allBooks.clear();
    _allBooks2 = databaseHandler!.getBookList();
    _allBooks = await databaseHandler!.getBookList();
    _currentBooks2 = _allBooks2;
    _currentBooks = _allBooks;
    notifyListeners();
  }

  Future<List<BookListItem>> getBookList() async {
    await databaseHandler!.initialDatabase();
    return await databaseHandler!.getBookList();
  }

  void toggleAllBooks() {
    _currentBooks = _allBooks;
    _currentBooks2 = _allBooks2;
    notifyListeners();
  }
}
