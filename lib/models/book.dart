import 'package:flutibre/utils/database_helper.dart';

class Book {
  int? _id;
  String? _title;
  String? _path;

  Book(
    this._title,
    this._path,
  );

  Book.withId(
    this._id,
    this._title,
    this._path,
  );

  get id => this._id;
  set id(value) => this._id = value;
  get title => this._title;
  set title(value) => this._title = value;
  get path => this._path;
  set path(value) => this._path = value;

  // Convert a Book object into a Map object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['path'] = _path;

    return map;
  }

  // Convert a Map object into a Book object
  Book.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._path = map['path'];
  }
}
