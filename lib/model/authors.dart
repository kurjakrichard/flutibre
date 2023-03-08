import 'package:equatable/equatable.dart';

class Authors extends Equatable {
  final int id;
  final String name;
  final String sort;
  final String link;

  const Authors({this.id = 0, this.name = '', this.sort = '', this.link = ''});

  Authors.fromMap(Map<String, dynamic> res)
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
