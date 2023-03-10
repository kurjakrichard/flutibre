import 'package:equatable/equatable.dart';

class Author extends Equatable {
  final int id;
  final String name;
  final String sort;
  final String link;

  const Author({this.id = 0, this.name = '', this.sort = '', this.link = ''});

  Author.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        name = res['name'],
        sort = res['sort'],
        link = res['link'];

  Map<String, Object?> toMap() {
    return {'name': name, 'sort': sort, 'link': link};
  }

  @override
  List<Object?> get props => [id, name, sort, link];
}
