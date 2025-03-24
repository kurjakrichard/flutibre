// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class BooksAuthorsLink extends Equatable {
  int? id;
  final int book;
  final int author;

  BooksAuthorsLink({this.id, required this.book, required this.author});

  //Convert a Map object to a model object
  BooksAuthorsLink.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        book = res['book'],
        author = res['author'];

  //Convert a model object to a Map opject
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    if (id != null) {
      map['id'] = id;
    }
    map['book'] = book;
    map['author'] = author;
    return map;
  }

  @override
  String toString() {
    return 'BooksAuthorsLink(id : $id, book : $book, author : $author)';
  }

  @override
  List<Object?> get props => [book, author];
}
