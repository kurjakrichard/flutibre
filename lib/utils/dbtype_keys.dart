import 'package:flutter/foundation.dart' show immutable;

@immutable
class DbTypekeys {
  const DbTypekeys._();
  static const String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  static const String stringType = 'TEXT NOT NULL';
  static const String integerType = 'INTEGER NOT NULL';
  static const String doubleType = 'REAl NOT NULL';
  static const String boolType = 'BOOLEAN NOT NULL';
}
