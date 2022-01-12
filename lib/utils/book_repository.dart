import 'package:flutibre/models/book.dart';
import 'package:flutter/material.dart';

class BookRepositoryData {
  final List<Book> books;
  final void Function(int) onDeleteBook;
  final void Function(Book) onBookAdded;

  BookRepositoryData(this.books, this.onDeleteBook, this.onBookAdded);
}

class BookRepository extends InheritedWidget {
  final BookRepositoryData _data;

  const BookRepository(this._data, {required Widget child})
      : super(child: child);

  @override
  bool updateShouldNotify(covariant BookRepository oldWidget) =>
      oldWidget._data != _data;

  static BookRepositoryData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<BookRepository>()!._data;
  }
}

class BookRepositoryProvider extends StatefulWidget {
  final Widget child;

  const BookRepositoryProvider({Key? key, required this.child})
      : super(key: key);

  @override
  State<BookRepositoryProvider> createState() => _BookRepositoryProviderState();
}

class _BookRepositoryProviderState extends State<BookRepositoryProvider> {
  late BookRepositoryData _repositoryData;

  @override
  void initState() {
    _repositoryData = BookRepositoryData(
      [
        Book(
          id: 1,
          author: 'Kurják Richárd',
          title: 'programozó',
          series: 'Idő kerek',
          language: 'magyar',
          publisher: 'Marvel',
          path: 'images/1.jpg',
        ),
        Book(
          id: 2,
          author: 'Kiss Jenő',
          title: 'tesztelő',
          series: 'Idő kerek',
          language: 'magyar',
          publisher: 'Marvel',
          path: 'images/2.jpg',
        ),
        Book(
          id: 3,
          author: 'Kurják Richárd',
          title: 'programozó',
          series: 'Idő kerek',
          language: 'magyar',
          publisher: 'Marvel',
          path: 'images/3.jpg',
        ),
        Book(
          id: 4,
          author: 'Kurják Richárd',
          title: 'programozó',
          series: 'Idő kerek',
          language: 'magyar',
          publisher: 'Marvel',
          path: 'images/4.jpg',
        ),
        Book(
          id: 5,
          author: 'Kurják Richárd',
          title: 'programozó',
          series: 'Idő kerek',
          language: 'magyar',
          publisher: 'Marvel',
          path: 'images/5.jpg',
        ),
        Book(
          id: 6,
          author: 'Kurják Richárd',
          title: 'programozó',
          series: 'Idő kerek',
          language: 'magyar',
          publisher: 'Marvel',
          path: 'images/6.jpg',
        ),
        Book(
          id: 7,
          author: 'Kurják Richárd',
          title: 'programozó',
          series: 'Idő kerek',
          language: 'magyar',
          publisher: 'Marvel',
          path: 'images/7.jpg',
        ),
        Book(
          id: 8,
          author: 'Kurják Richárd',
          title: 'programozó',
          series: 'Idő kerek',
          language: 'magyar',
          publisher: 'Marvel',
          path: 'images/8.jpg',
        ),
        Book(
          id: 9,
          author: 'Kurják Richárd',
          title: 'programozó',
          series: 'Idő kerek',
          language: 'magyar',
          publisher: 'Marvel',
          path: 'images/9.jpg',
        ),
        Book(
          id: 10,
          author: 'Kurják Richárd',
          title: 'programozó',
          series: 'Idő kerek',
          language: 'magyar',
          publisher: 'Marvel',
          path: 'images/10.jpg',
        ),
        Book(
          id: 11,
          author: 'Kurják Richárd',
          title: 'programozó',
          series: 'Idő kerek',
          language: 'magyar',
          publisher: 'Marvel',
          path: 'images/11.jpg',
        ),
        Book(
          id: 12,
          author: 'Kurják Richárd',
          title: 'programozó',
          series: 'Idő kerek',
          language: 'magyar',
          publisher: 'Marvel',
          path: 'images/12.jpg',
        ),
        Book(
          id: 13,
          author: 'Kurják Richárd',
          title: 'programozó',
          series: 'Idő kerek',
          language: 'magyar',
          publisher: 'Marvel',
          path: 'images/13.jpg',
        ),
        Book(
          id: 14,
          author: 'Kurják Richárd',
          title: 'programozó',
          series: 'Idő kerek',
          language: 'magyar',
          publisher: 'Marvel',
          path: 'images/14.jpg',
        ),
        Book(
          id: 15,
          author: 'Kurják Richárd',
          title: 'programozó',
          series: 'Idő kerek',
          language: 'magyar',
          publisher: 'Marvel',
          path: 'images/15.jpg',
        ),
        Book(
          id: 16,
          author: 'Kurják Richárd',
          title: 'programozó',
          series: 'Idő kerek',
          language: 'magyar',
          publisher: 'Marvel',
          path: 'images/16.jpg',
        ),
      ],
      _onDelete,
      _onAddBook,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BookRepository(_repositoryData, child: widget.child);
  }

  void _onDelete(int bookId) => setState(() {
        _repositoryData = BookRepositoryData(
          _repositoryData.books.toList()
            ..removeWhere((element) => element.id == bookId),
          _onDelete,
          _onAddBook,
        );
      });

  void _onAddBook(Book modifiedBook) => setState(() {
        _repositoryData = BookRepositoryData(
          _repositoryData.books.toList()..add(modifiedBook),
          _onDelete,
          _onAddBook,
        );
      });
}
