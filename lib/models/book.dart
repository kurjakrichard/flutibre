import 'package:flutibre/utils/database_helper.dart';

class Book {
  int? _id;
  String? _title;
  String? _author_sort;

  Book(
    this._title,
    this._author_sort,
  );

  Book.withId(
    this._id,
    this._title,
    this._author_sort,
  );

  get id => this._id;
  set id(value) => this._id = value;
  get title => this._title;
  set title(value) => this._title = value;
  get author_sort => this._author_sort;
  set author_sort(value) => this._author_sort = value;

  // Convert a Book object into a Map object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['autor_sort'] = _author_sort;

    return map;
  }

  // Convert a Map object into a Book object
  Book.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._author_sort = map['author_sort'];
  }
}
