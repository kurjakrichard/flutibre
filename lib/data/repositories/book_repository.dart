import '../models/book.dart';

abstract class BookRepository {
  Future<int?> addBook(Book book);
  Future<void> updateBook(Book book);
  Future<void> deleteBook(Book book);
  Future<List<Book>> getAllBooks();
  Future<Book?> getBook(int bookId);
}
