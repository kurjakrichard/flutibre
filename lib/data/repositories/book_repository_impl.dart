import '../datasource/book_datasource.dart';
import '../models/book.dart';
import 'book_repository.dart';

class BookRepositoryImpl implements BookRepository {
  final BookDatasource _datasource;
  BookRepositoryImpl(this._datasource);

  @override
  Future<int?> addBook(Book book) async {
    int bookId;
    try {
      bookId = await _datasource.addBook(book);
    } catch (e) {
      throw '$e';
    }
    return bookId;
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
  Future<Book?> getBook(int bookId) async {
    try {
      return _datasource.getBook(bookId);
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
