class Book {
  final int id;
  final String author_sort;
  final String title;
  final double series_index;
  final String path;

  const Book(
      this.id, this.author_sort, this.title, this.series_index, this.path);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Book &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          author_sort == other.author_sort &&
          title == other.title &&
          series_index == other.series_index &&
          path == other.path;

  @override
  int get hashCode =>
      id.hashCode ^
      author_sort.hashCode ^
      title.hashCode ^
      series_index.hashCode ^
      path.hashCode;

  Book.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        author_sort = res["author_sort"],
        title = res["title"],
        series_index = res["series_index"],
        path = res["path"];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'author_sort': author_sort,
      'title': title,
      'series_index': series_index,
      'path': path,
    };
  }
}
