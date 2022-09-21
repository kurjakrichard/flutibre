import 'package:flutibre/repositories/database_handler.dart';
import '../models/book.dart';

class EbookService {
  DatabaseHandler? _databaseHandler;

  EbookService() {
    _databaseHandler = DatabaseHandler();
  }

  saveBook(Book book) async {
    return await _databaseHandler!.insert('books', book.toMap());
  }
}
