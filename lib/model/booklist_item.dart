class BookListItem {
  int id;
  // ignore: non_constant_identifier_names
  String name;
  String author_sort;

  String title;
  String sort;
  int has_cover;
  // ignore: non_constant_identifier_names
  double series_index;
  String path;

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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookListItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          author_sort == other.author_sort &&
          title == other.title &&
          sort == other.sort &&
          has_cover == other.has_cover &&
          series_index == other.series_index &&
          path == other.path;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      author_sort.hashCode ^
      title.hashCode ^
      sort.hashCode ^
      has_cover.hashCode ^
      series_index.hashCode ^
      path.hashCode;

  BookListItem.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        name = res['name'],
        author_sort = res['author_sort'],
        title = res['title'],
        sort = res['sort'],
        has_cover = res['has_cover'],
        series_index = res['series_index'],
        path = res['path'];

  Map<String, Object?> toMap() {
    return {
      'name': name,
      'author_sort': author_sort,
      'title': title,
      'sort': sort,
      'has_cover': has_cover,
      'series_index': series_index,
      'path': path,
    };
  }
}
