import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/utils.dart';

final categoryProvider = StateProvider.autoDispose<BookCategory>((ref) {
  return BookCategory.others;
});
