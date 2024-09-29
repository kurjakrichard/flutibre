import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/data.dart';
import 'task.dart';

final booksProvider = StateNotifierProvider<BookNotifier, BookState>((ref) {
  final repository = ref.watch(bookRepositoryProvider);
  return BookNotifier(repository);
});
