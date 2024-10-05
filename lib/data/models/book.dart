import 'package:equatable/equatable.dart';
import 'package:flutibre/utils/utils.dart';

class Book extends Equatable {
  final int id;
  final String title;
  final String writer;
  final String price;
  final String image;
  final String description;
  final double rating;
  final int pages;

  Book(
      {required this.id,
      required this.title,
      required this.writer,
      required this.price,
      required this.image,
      required this.description,
      required this.rating,
      required this.pages});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      Bookkeys.id: id,
      Bookkeys.title: title,
      Bookkeys.writer: writer,
      Bookkeys.price: price,
      Bookkeys.image: image,
      Bookkeys.description: description,
      Bookkeys.rating: rating,
      Bookkeys.pages: pages
    };
  }

  factory Book.fromJson(Map<String, dynamic> map) {
    return Book(
      id: map[Bookkeys.id],
      title: map[Bookkeys.title],
      writer: map[Bookkeys.writer],
      price: map[Bookkeys.price],
      image: map[Bookkeys.image],
      description: map[Bookkeys.description],
      rating: map[Bookkeys.rating],
      pages: map[Bookkeys.pages],
    );
  }

  @override
  List<Object> get props {
    return [title, writer, price, image, description, rating, pages];
  }

  Book copyWith({
    int? id,
    String? title,
    String? writer,
    String? price,
    String? image,
    String? description,
    double? rating,
    int? pages,
  }) {
    return Book(
        id: id ?? this.id,
        title: title ?? this.title,
        writer: writer ?? this.writer,
        price: price ?? this.price,
        image: image ?? this.image,
        description: description ?? this.description,
        rating: rating ?? this.rating,
        pages: pages ?? this.pages);
  }
}
