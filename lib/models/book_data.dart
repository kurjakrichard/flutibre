import 'package:flutter/rendering.dart';

class BookData {
  final int id;
  final String author;
  final String title;
  final String series;
  final String language;
  final String publisher;
  final String content;
  final String cover;

  const BookData(this.id, this.author, this.title, this.series, this.language,
      this.publisher, this.content, this.cover);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookData &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          author == other.author &&
          title == other.title &&
          series == other.series &&
          language == other.language &&
          publisher == other.publisher &&
          content == other.content &&
          cover == other.cover;

  @override
  int get hashCode =>
      id.hashCode ^
      author.hashCode ^
      title.hashCode ^
      series.hashCode ^
      language.hashCode ^
      publisher.hashCode ^
      content.hashCode ^
      cover.hashCode;
}
