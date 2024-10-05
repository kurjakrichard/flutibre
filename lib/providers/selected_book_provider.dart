import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/data_export.dart';

final selectedBookProvider =
    StateNotifierProvider<SelectedBookNotifier, Book?>((ref) {
  return SelectedBookNotifier();
});

class SelectedBookNotifier extends StateNotifier<Book?> {
  SelectedBookNotifier() : super(null);

  Future<void> setSelectedBook(Book book) async {
    state = book;
  }

  Future<void> resetSelectedBook() async {
    state = null;
  }
}
