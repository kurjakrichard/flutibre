import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      await Future.delayed(const Duration(seconds: 2));

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
      throw Exception();
    }
  }

  Future<void> editBook(Book book) async {
    Book newBook = book;
    state = BookListLoading();
    try {
      await Future.delayed(const Duration(seconds: 2));
      if (book.id == null) {
        await _databaseProvider.insertBook(newBook);
      } else {
        await _databaseProvider.updateBook(newBook);
      }
      state = BookListSuccess();
    } on Exception {
      state = BookListFailure();
    }
  }

  Future<void> deleteBook(id) async {
    state = BookListLoading();
    await Future.delayed(const Duration(seconds: 2));
    try {
      await _databaseProvider.deleteBook(id);
      loadBookItemList();
    } on Exception {
      state = BookListFailure();
    }
  }
}
