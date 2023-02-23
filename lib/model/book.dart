// ignore_for_file: non_constant_identifier_names

import 'data.dart';

class Book {
  int id;
  String author_sort;
  String title;
  double series_index;
  int has_cover;
  String path;
  List<Data>? formats;

  Book(
      {this.id = 0,
      this.author_sort = '',
      this.title = '',
      this.series_index = 1.0,
      this.has_cover = 0,
      this.path = '',
      this.formats});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Book &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          author_sort == other.author_sort &&
          title == other.title &&
          has_cover == other.has_cover &&
          series_index == other.series_index &&
          path == other.path;

  @override
  int get hashCode =>
      id.hashCode ^
      author_sort.hashCode ^
      title.hashCode ^
      has_cover.hashCode ^
      series_index.hashCode ^
      path.hashCode;

  Book.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        author_sort = res["author_sort"],
        title = res["title"],
        has_cover = res["has_cover"],
        series_index = res["series_index"],
        path = res["path"];

  Map<String, Object?> toMap() {
    return {
      'author_sort': author_sort,
      'title': title,
      'has_cover': has_cover,
      'series_index': series_index,
      'path': path,
    };
  }
}
