import 'package:equatable/equatable.dart';

class Comment extends Equatable {
  final int id;
  final int book;
  final String text;

  const Comment({this.id = 0, this.book = 0, this.text = ''});

  Comment.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        book = res['book'],
        text = res['text'];

  Map<String, Object?> toMap() {
    return {'book': book, 'text': text};
  }

  @override
  List<Object?> get props => [id, book, text];
}
