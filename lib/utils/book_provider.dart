import 'package:flutibre/models/book.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutibre/utils/database_handler.dart';

class BookProvider with ChangeNotifier {
  final handler = DatabaseHandler();

  Future<List<Book>?> bookss() async {
    return await handler.retrieveBooks();
  }

  List<Book> books = [
    const Book(
      1,
      'R.R. Tolkien',
      'A gyűrűk ura',
      1,
      'images/1.jpg',
    ),
    const Book(
      2,
      'Robert Jordan',
      'Az alkony keresztútján',
      1,
      'images/2.jpg',
    ),
    const Book(
      3,
      'Stephen King',
      'Ragyogás',
      1,
      'images/3.jpg',
    ),
    const Book(
      4,
      'Robert Jordan',
      'Újjászületett sárkány',
      1,
      'images/4.jpg',
    ),
    const Book(
      5,
      'Robert Jordan',
      'Újjászületett sárkány',
      1,
      'images/5.jpg',
    ),
    const Book(
      6,
      'Robert Jordan',
      'Újjászületett sárkány',
      1,
      'images/6.jpg',
    ),
    const Book(
      7,
      'Robert Jordan',
      'Újjászületett sárkány',
      1,
      'images/7.jpg',
    ),
    const Book(
      8,
      'Robert Jordan',
      'Újjászületett sárkány',
      1,
      'images/8.jpg',
    ),
    const Book(
      9,
      'Robert Jordan',
      'Újjászületett sárkány',
      1,
      'images/9.jpg',
    ),
    const Book(
      10,
      'Robert Jordan',
      'Újjászületett sárkány',
      1,
      'images/10.jpg',
    ),
    const Book(
      11,
      'Robert Jordan',
      'Újjászületett sárkány',
      1,
      'images/11.jpg',
    ),
    const Book(
      12,
      'Robert Jordan',
      'Újjászületett sárkány',
      1,
      'images/12.jpg',
    ),
    const Book(
      13,
      'Robert Jordan',
      'Újjászületett sárkány',
      1,
      'images/13.jpg',
    ),
    const Book(
      14,
      'Robert Jordan',
      'Újjászületett sárkány',
      1,
      'images/14.jpg',
    ),
    const Book(
      15,
      'Robert Jordan',
      'Újjászületett sárkány',
      1,
      'images/15.jpg',
    ),
    const Book(
      16,
      'Robert Jordan',
      'Újjászületett sárkány',
      1,
      'images/16.jpg',
    ),
  ];

  void onDelete(int bookId) {
    books.removeWhere((item) => item.id == bookId);
    notifyListeners();
  }

  void onAddBook(Book newBook) {
    books.add(newBook);
    notifyListeners();
  }
}
