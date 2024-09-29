import '../models/book.dart';

abstract class BookRepository {
  Future<void> addBook(Book book);
  Future<void> updateBook(Book book);
  Future<void> deleteBook(Book book);
  Future<List<Book>> getAllBooks();
}
