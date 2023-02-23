import '../model/book.dart';
import '../model/data.dart';
import '../repository/database_handler.dart';

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

  //Load book formats as a list
  Future<List<Data>> readBookFormats(int bookId) async {
    return await _databaseHandler!.getFormatsById(bookId);
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
