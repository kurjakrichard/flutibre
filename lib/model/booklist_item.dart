// ignore_for_file: non_constant_identifier_names

import '../main.dart';

class BookListItem {
  int id;
  String name;
  String author_sort;
  String title;
  String sort;
  int has_cover;
  double series_index;
  String path;
  String? fullPath = prefs.getString('path');

  BookListItem({
    this.id = 0,
    this.name = '',
    this.author_sort = '',
    this.title = '',
    this.sort = '',
    this.has_cover = 0,
    this.series_index = 1.0,
    this.path = '',
  });

  BookListItem.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        name = res['name'],
        author_sort = res['author_sort'],
        title = res['title'],
        sort = res['sort'],
        has_cover = res['has_cover'],
        series_index = res['series_index'],
        path = res['path'];
}
