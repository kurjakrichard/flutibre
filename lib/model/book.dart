// ignore_for_file: non_constant_identifier_names
import 'package:equatable/equatable.dart';
import 'author.dart';
import 'comment.dart';
import 'data.dart';

// ignore: must_be_immutable
class Book extends Equatable {
  final int? id;
  final String title;
  final String sort;
  final String timestamp;
  final String pubdate;
  final double series_index;
  final String author_sort;
  final String isbn;
  final String lccn;
  final String path;
  final int has_cover;
  final String last_modified;
  //Related classes
  List<Data>? formats;
  List<Author>? authors;
  Comment? comment;

  Book(
      {this.id = 0,
      this.title = '',
      this.sort = '',
      this.timestamp = '',
      this.pubdate = '',
      this.series_index = 1.0,
      this.author_sort = '',
      this.isbn = '',
      this.lccn = '',
      this.path = '',
      this.has_cover = 0,
      this.last_modified = '',
      this.formats,
      this.authors,
      this.comment});

  Book.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        title = res['title'],
        sort = res['sort'],
        timestamp = res['timestamp'],
        pubdate = res['pubdate'],
        author_sort = res['author_sort'],
        series_index = res['series_index'],
        isbn = res['isbn'],
        lccn = res['lccn'],
        path = res['path'],
        has_cover = res['has_cover'],
        last_modified = res['last_modified'];

  Map<String, Object?> toMap() {
    return {
      'title': title,
      'sort': sort,
      'timestamp': timestamp,
      'pubdate': pubdate,
      'author_sort': author_sort,
      'series_index': series_index,
      'isbn': isbn,
      'lccn': lccn,
      'path': path,
      'has_cover': has_cover,
      'last_modified': last_modified
    };
  }

  @override
  List<Object?> get props => [id, title, sort, author_sort, isbn];
}
