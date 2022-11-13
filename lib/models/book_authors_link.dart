import 'book.dart';
import 'authors.dart';

class BooksAuthorsLink {
  int id;
  Book book;
  Authors author;

  BooksAuthorsLink(
      {required this.id, required this.book, required this.author});

  BooksAuthorsLink.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        book = res["book"],
        author = res["author"];

  Map<String, Object?> toMap() {
    return {'book': book, 'author': author};
  }
}
