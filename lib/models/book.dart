class Book {
  final int id;
  final String title;
  final String author;
  final String series;
  final String language;
  final String publisher;
  final String path;

  Book(
      {required this.id,
      required this.title,
      required this.author,
      required this.series,
      required this.language,
      required this.publisher,
      required this.path});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Book &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          author == other.author &&
          series == other.series &&
          language == other.language &&
          path == other.path;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      author.hashCode ^
      series.hashCode ^
      language.hashCode ^
      path.hashCode;
}
