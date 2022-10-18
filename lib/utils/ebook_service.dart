import 'package:flutibre/repositories/database_handler.dart';
import '../models/book.dart';

class EbookService {
  DatabaseHandler? _databaseHandler;

  EbookService() {
    _databaseHandler = DatabaseHandler();
  }
  //Save data to table
  saveBook(Book book) async {
    return await _databaseHandler!.insert('books', book.toMap());
  }

  //Read books as a list
  Future<List<Book>> readBooks(String table, String order) async {
    return await _databaseHandler!.getBookList(table, order);
  }

  //Insert new category
  Future<int> insertBook(String table, Book book) async {
    return await _databaseHandler!.insert(table, book.toMap());
  }
}
