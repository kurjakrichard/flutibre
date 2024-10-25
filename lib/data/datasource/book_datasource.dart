// ignore: depend_on_referenced_packages
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io' show Platform;
import '../../utils/utils.dart';
import '../models/book.dart';

class BookDatasource {
  static BookDatasource? _databaseHandler;
  static Database? _database;
  BookDatasource._createInstance();

  Future<Database> get database async {
    if (Platform.isAndroid || Platform.isIOS) {
      _database ??= await _initDbMobile();
      // Mobile-specific code
    } else {
      _database ??= await _initDbDesktop();
      // Desktop-specific code
    }
    return _database!;
  }

  factory BookDatasource() {
    _databaseHandler ??= BookDatasource._createInstance();
    return _databaseHandler!;
  }

  Future<Database> _initDbMobile() async {
    final dbPath = await getApplicationDocumentsDirectory();
    final path = join(dbPath.path, AppKeys.dbName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<Database> _initDbDesktop() async {
    final dbPath = await getApplicationDocumentsDirectory();
    final path = join(dbPath.path, AppKeys.dbName);
    sqfliteFfiInit();
    final databaseFactory = databaseFactoryFfi;
    return await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: _onCreate,
      ),
    );
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${AppKeys.dbTable} (
        ${Bookkeys.id} ${DbTypekeys.idType},
        ${Bookkeys.title} ${DbTypekeys.stringType},
        ${Bookkeys.author} ${DbTypekeys.stringType},
        ${Bookkeys.price} ${DbTypekeys.stringType},
        ${Bookkeys.image} ${DbTypekeys.stringType},
        ${Bookkeys.path} ${DbTypekeys.stringType},
        ${Bookkeys.last_modified} ${DbTypekeys.stringType},
        ${Bookkeys.description} ${DbTypekeys.stringType},
        ${Bookkeys.pages} ${DbTypekeys.integerType},
        ${Bookkeys.rating} ${DbTypekeys.doubleType}

      )
    ''');
  }

  Future<int> addBook(Book book) async {
    final db = await database;
    return db.transaction((txn) async {
      return await txn.insert(
        AppKeys.dbTable,
        book.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  Future<Book?> getBook(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> map = await db.query(
      AppKeys.dbTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (map.isNotEmpty) {
      return Book.fromJson(map.first);
    } else {
      throw Exception('ID $id not found!');
    }
  }

  Future<List<Book>> getAllBooks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      AppKeys.dbTable,
      orderBy: "id DESC",
    );
    return List.generate(
      maps.length,
      (index) {
        return Book.fromJson(maps[index]);
      },
    );
  }

  Future<int> updateBook(Book book) async {
    final db = await database;
    return db.transaction((txn) async {
      return await txn.update(
        AppKeys.dbTable,
        book.toJson(),
        where: 'id = ?',
        whereArgs: [book.id],
      );
    });
  }

  Future<int> deleteBook(Book book) async {
    final db = await database;
    return db.transaction(
      (txn) async {
        return await txn.delete(
          AppKeys.dbTable,
          where: 'id = ?',
          whereArgs: [book.id],
        );
      },
    );
  }

  Future close() async {
    final db = await _databaseHandler!.database;
    db.close();
  }
}
