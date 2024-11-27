// ignore_for_file: non_constant_identifier_names
import 'package:equatable/equatable.dart';
import 'package:flutibre/utils/utils.dart';

class Book extends Equatable {
  final int? id;
  final String title;
  final String author;
  final String price;
  final String image;
  final String path;
  final String filename;
  final String format;
  final String last_modified;
  final String description;
  final double rating;
  final int pages;

  const Book(
      {this.id,
      required this.title,
      required this.author,
      required this.price,
      required this.image,
      required this.path,
      required this.filename,
      required this.format,
      required this.last_modified,
      required this.description,
      required this.rating,
      required this.pages});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      Bookkeys.id: id,
      Bookkeys.title: title,
      Bookkeys.author: author,
      Bookkeys.price: price,
      Bookkeys.image: image,
      Bookkeys.path: path,
      Bookkeys.filename: filename,
      Bookkeys.format: format,
      Bookkeys.last_modified: last_modified,
      Bookkeys.description: description,
      Bookkeys.rating: rating,
      Bookkeys.pages: pages
    };
  }

  factory Book.fromJson(Map<String, dynamic> map) {
    return Book(
      id: map[Bookkeys.id],
      title: map[Bookkeys.title],
      author: map[Bookkeys.author],
      price: map[Bookkeys.price],
      image: map[Bookkeys.image],
      path: map[Bookkeys.path],
      filename: map[Bookkeys.filename],
      format: map[Bookkeys.format],
      last_modified: map[Bookkeys.last_modified],
      description: map[Bookkeys.description],
      rating: map[Bookkeys.rating],
      pages: map[Bookkeys.pages],
    );
  }

  @override
  List<Object> get props {
    return [
      title,
      author,
      price,
      image,
      path,
      filename,
      format,
      last_modified,
      description,
      rating,
      pages
    ];
  }

  Book copyWith({
    int? id,
    String? title,
    String? author,
    String? price,
    String? image,
    String? path,
    String? filename,
    String? format,
    String? last_modified,
    String? description,
    double? rating,
    int? pages,
  }) {
    return Book(
        id: id ?? this.id,
        title: title ?? this.title,
        author: author ?? this.author,
        price: price ?? this.price,
        image: image ?? this.image,
        path: path ?? this.path,
        filename: filename ?? this.filename,
        format: format ?? this.format,
        last_modified: last_modified ?? this.last_modified,
        description: description ?? this.description,
        rating: rating ?? this.rating,
        pages: pages ?? this.pages);
  }
}
