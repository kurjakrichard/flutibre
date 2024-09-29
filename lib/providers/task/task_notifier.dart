import 'package:flutibre/data/data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'task.dart';

class BookNotifier extends StateNotifier<BookState> {
  final BookRepository _repository;

  BookNotifier(this._repository) : super(const BookState.initial()) {
    getBooks();
  }

  Future<void> createBook(Book book) async {
    try {
      await _repository.addBook(book);
      getBooks();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> deleteBook(Book book) async {
    try {
      await _repository.deleteBook(book);
      getBooks();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> updateBook(Book book) async {
    try {
      final isCompleted = !book.isCompleted;
      final updatedBook = book.copyWith(isCompleted: isCompleted);
      await _repository.updateBook(updatedBook);
      getBooks();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void getBooks() async {
    try {
      final books = await _repository.getAllBooks();
      state = state.copyWith(books: books);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
