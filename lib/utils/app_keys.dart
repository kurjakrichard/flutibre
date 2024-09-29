import 'package:flutter/foundation.dart' show immutable;

@immutable
class AppKeys {
  const AppKeys._();
  static const String isDarkMode = 'isDarkMode';
  static const String dbTable = 'books';
  static const String dbName = 'metadata.db';
}
