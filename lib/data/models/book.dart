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
      Bookkeys.id.name: id,
      Bookkeys.title.name: title,
      Bookkeys.author.name: author,
      Bookkeys.price.name: price,
      Bookkeys.image.name: image,
      Bookkeys.path.name: path,
      Bookkeys.filename.name: filename,
      Bookkeys.format.name: format,
      Bookkeys.last_modified.name: last_modified,
      Bookkeys.description.name: description,
      Bookkeys.rating.name: rating,
      Bookkeys.pages.name: pages
    };
  }

  factory Book.fromJson(Map<String, dynamic> map) {
    return Book(
      id: map[Bookkeys.id.name],
      title: map[Bookkeys.title.name],
      author: map[Bookkeys.author.name],
      price: map[Bookkeys.price.name],
      image: map[Bookkeys.image.name],
      path: map[Bookkeys.path.name],
      filename: map[Bookkeys.filename.name],
      format: map[Bookkeys.format.name],
      last_modified: map[Bookkeys.last_modified.name],
      description: map[Bookkeys.description.name],
      rating: map[Bookkeys.rating.name],
      pages: map[Bookkeys.pages.name],
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
