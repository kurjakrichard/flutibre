import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'book_datasource.dart';

final bookDatasourceProvider = Provider<BookDatasource>((ref) {
  return BookDatasource();
});
