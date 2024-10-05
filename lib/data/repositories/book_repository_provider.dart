import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data_export.dart';

final bookRepositoryProvider = Provider<BookRepository>((ref) {
  final datasource = ref.read(bookDatasourceProvider);
  return BookRepositoryImpl(datasource);
});
