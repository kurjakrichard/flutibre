//import 'package:equatable/equatable.dart';
import '../../data/data_export.dart';

class BookState /*extends Equatable*/ {
  final List<Book> books;

  const BookState({
    required this.books,
  });
  const BookState.initial({
    this.books = const [],
  });

  BookState copyWith({
    List<Book>? books,
  }) {
    return BookState(
      books: books ?? this.books,
    );
  }

  @override
  List<Object> get props => [books];
}
