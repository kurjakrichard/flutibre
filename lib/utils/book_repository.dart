import 'package:flutibre/models/book_data.dart';
import 'package:flutter/material.dart';

class BookRepositoryData {
  final List<BookData> books;
  final void Function(int) onDeleteBook;
  final void Function(BookData) onBookAdded;

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
        BookData(
          1,
          'R.R. Tolkien',
          'A gyűrűk ura',
          'Idő kerek',
          'magyar',
          'Marvel',
          '',
          'images/1.jpg',
        ),
        BookData(
          2,
          'Robert Jordan',
          'Az alkony keresztútján',
          'Idő kereke',
          'magyar',
          'Marvel',
          'Ide egy nagyon hosszú szoveget fogok írni. Megnézzük, hogy tördeli be',
          'images/2.jpg',
        ),
        BookData(
          3,
          'Stephen King',
          'Ragyogás',
          '',
          'magyar',
          'Marvel',
          '',
          'images/3.jpg',
        ),
        BookData(
          4,
          'Robert Jordan',
          'Újjászületett sárkány',
          'Idő kerek',
          'magyar',
          'Marvel',
          '',
          'images/4.jpg',
        ),
        BookData(
          5,
          'Robert Jordan',
          'Újjászületett sárkány',
          'Idő kerek',
          'magyar',
          'Marvel',
          '',
          'images/5.jpg',
        ),
        BookData(
          6,
          'Robert Jordan',
          'Újjászületett sárkány',
          'Idő kerek',
          'magyar',
          'Marvel',
          '',
          'images/6.jpg',
        ),
        BookData(
          7,
          'Robert Jordan',
          'Újjászületett sárkány',
          'Idő kerek',
          'magyar',
          'Marvel',
          '',
          'images/7.jpg',
        ),
        BookData(
          8,
          'Robert Jordan',
          'Újjászületett sárkány',
          'Idő kerek',
          'magyar',
          'Marvel',
          '',
          'images/8.jpg',
        ),
        BookData(
          9,
          'Robert Jordan',
          'Újjászületett sárkány',
          'Idő kerek',
          'magyar',
          'Marvel',
          '',
          'images/9.jpg',
        ),
        BookData(
          10,
          'Robert Jordan',
          'Újjászületett sárkány',
          'Idő kerek',
          'magyar',
          'Marvel',
          '',
          'images/10.jpg',
        ),
        BookData(
          11,
          'Robert Jordan',
          'Újjászületett sárkány',
          'Idő kerek',
          'magyar',
          'Marvel',
          '',
          'images/11.jpg',
        ),
        BookData(
          12,
          'Robert Jordan',
          'Újjászületett sárkány',
          'Idő kerek',
          'magyar',
          'Marvel',
          '',
          'images/12.jpg',
        ),
        BookData(
          13,
          'Robert Jordan',
          'Újjászületett sárkány',
          'Idő kerek',
          'magyar',
          'Marvel',
          '',
          'images/13.jpg',
        ),
        BookData(
          14,
          'Robert Jordan',
          'Újjászületett sárkány',
          'Idő kerek',
          'magyar',
          'Marvel',
          '',
          'images/14.jpg',
        ),
        BookData(
          15,
          'Robert Jordan',
          'Újjászületett sárkány',
          'Idő kerek',
          'magyar',
          'Marvel',
          '',
          'images/15.jpg',
        ),
        BookData(
          16,
          'Robert Jordan',
          'Újjászületett sárkány',
          'Idő kerek',
          'magyar',
          'Marvel',
          '',
          'images/16.jpg',
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

  void _onAddBook(BookData modifiedBook) => setState(() {
        _repositoryData = BookRepositoryData(
          _repositoryData.books.toList()..add(modifiedBook),
          _onDelete,
          _onAddBook,
        );
      });
}
