import 'package:flutibre/repositories/database_handler.dart';
import '../models/book.dart';

class EbookService {
  DatabaseHandler? _databaseHandler;

  EbookService() {
    _databaseHandler = DatabaseHandler();
  }
  //Save data to table
  saveBook(Book book) async {
    return await _databaseHandler!.insertBook(book);
  }

  //Read books as a list
  Future<List<Book>> readBooks(String order) async {
    return await _databaseHandler!.getAllBooks();
  }

  //Insert new book
  Future<int> insertBook(Book book) async {
    return await _databaseHandler!.insertBook(book);
  }

  //Insert new book
  void deleteBook(int id) async {
    await _databaseHandler!.deleteBook(id);
  }
}
