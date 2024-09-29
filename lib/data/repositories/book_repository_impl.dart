import '../datasource/book_datasource.dart';
import '../models/book.dart';
import 'book_repository.dart';

class BookRepositoryImpl implements BookRepository {
  final BookDatasource _datasource;
  BookRepositoryImpl(this._datasource);

  @override
  Future<void> addBook(Book book) async {
    try {
      await _datasource.addBook(book);
    } catch (e) {
      throw '$e';
    }
  }

  @override
  Future<void> deleteBook(Book book) async {
    try {
      await _datasource.deleteBook(book);
    } catch (e) {
      throw '$e';
    }
  }

  @override
  Future<List<Book>> getAllBooks() async {
    try {
      return await _datasource.getAllBooks();
    } catch (e) {
      throw '$e';
    }
  }

  @override
  Future<void> updateBook(Book book) async {
    try {
      await _datasource.updateBook(book);
    } catch (e) {
      throw '$e';
    }
  }
}
