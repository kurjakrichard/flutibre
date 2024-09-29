import 'package:equatable/equatable.dart';
import 'package:flutibre/utils/utils.dart';

class Book extends Equatable {
  final int? id;
  final String title;
  final String note;
  final BookCategory category;
  final String time;
  final String date;
  final bool isCompleted;

  const Book({
    this.id,
    required this.title,
    required this.category,
    required this.time,
    required this.date,
    required this.note,
    required this.isCompleted,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      Bookkeys.id: id,
      Bookkeys.title: title,
      Bookkeys.note: note,
      Bookkeys.category: category.name,
      Bookkeys.time: time,
      Bookkeys.date: date,
      Bookkeys.isCompleted: isCompleted ? 1 : 0,
    };
  }

  factory Book.fromJson(Map<String, dynamic> map) {
    return Book(
      id: map[Bookkeys.id],
      title: map[Bookkeys.title],
      note: map[Bookkeys.note],
      category: BookCategory.stringToTaskCategory(map[Bookkeys.category]),
      time: map[Bookkeys.time],
      date: map[Bookkeys.date],
      isCompleted: map[Bookkeys.isCompleted] == 1 ? true : false,
    );
  }

  @override
  List<Object> get props {
    return [
      title,
      note,
      category,
      time,
      date,
      isCompleted,
    ];
  }

  Book copyWith({
    int? id,
    String? title,
    String? note,
    BookCategory? category,
    String? time,
    String? date,
    bool? isCompleted,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      note: note ?? this.note,
      category: category ?? this.category,
      time: time ?? this.time,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
