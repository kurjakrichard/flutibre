import 'package:flutibre/model/books_authors_link.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/author.dart';
import '../model/book.dart';
import '../repository/database_handler.dart';
import 'book_list_state.dart';

final databaseProvider = Provider((ref) => DatabaseHandler.createInstance());

final bookListProvider = StateNotifierProvider<BookListNotifier, BookListState>(
    (ref) => BookListNotifier(ref));

class BookListNotifier extends StateNotifier<BookListState> {
  BookListNotifier(this.ref)
      : _databaseProvider = ref.watch(databaseProvider),
        super(BookListInitial()) {
    loadBookItemList();
  }
  final Ref ref;
  final DatabaseHandler _databaseProvider;

  Future<void> loadBookItemList() async {
    state = BookListLoading();
    try {
      //await Future.delayed(const Duration(seconds: 2));

      final bookList = await _databaseProvider.getBookItemList();
      if (bookList.isEmpty) {
        state = BookListEmpty();
      } else {
        state = BookListLoaded(
          bookList: bookList,
        );
      }
    } catch (e) {
      state = BookListFailure();
      throw Exception();
    }
  }

  Future<void> filteredBookItemList(String searchItem) async {
    state = BookListLoading();
    try {
      //await Future.delayed(const Duration(seconds: 2));

      final bookList = await _databaseProvider.getResultBookList(searchItem);
      if (bookList.isEmpty) {
        state = BookListEmpty();
      } else {
        state = FilteredBookListLoaded(
          bookList: bookList,
        );
      }
    } catch (e) {
      state = BookListFailure();
      throw Exception(e);
    }
  }

  Future<void> deleteBook(book) async {
    state = BookListLoading();
    await Future.delayed(const Duration(seconds: 2));
    try {
      _databaseProvider.deleteBook(book);
      loadBookItemList();
    } on Exception {
      state = BookListFailure();
    }
  }

  Future<void> insertBook(Book book) async {
    Book newBook = book;
    state = BookListLoading();
    try {
      await Future.delayed(const Duration(seconds: 2));
      if (book.id == null) {
        _databaseProvider.insertBook(newBook);
        _databaseProvider.insertAuthor(
            Author(name: 'Brandon Sanderson', sort: 'Sanderson, Brandon'));
        _databaseProvider
            .insertBooksAuthorsLink(BooksAuthorsLink(book: 22, author: 10));
      } else {
        _databaseProvider.updateBook(newBook);
      }
      state = BookListSuccess();
    } on Exception {
      state = BookListFailure();
    }
  }
}
