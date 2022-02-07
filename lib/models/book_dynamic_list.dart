import 'package:flutibre/models/book_data.dart';

class DynamicList {
  List<BookData> _list = [];
  DynamicList(this._list);

  List get list => _list;
}
