import 'package:flutibre/models/book.dart';
import 'package:flutibre/repositories/database_connection.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHandler {
  DatabaseConnection? _databaseConnection;

  Map table = {
    'tableName': 'books',
    'colId': 'id',
    'colTitle': 'title',
    'colDescription': 'description'
  };

  DatabaseHandler() {
    _databaseConnection = DatabaseConnection();
  }

  static Database? _database;

  Future<Database>? get database async {
    if (_database != null) {
      _database = await _databaseConnection!.initializeDB();
      return _database!;
    }
    return _database!;
  }

// Fetch Operation: Get all data from database
  Future<List<Map<String, dynamic>>> getData(String table, String order) async {
    Database? db = await database;
    //var result = await db.rawQuery('SELECT * FROM ${table['tablename']} order by ${table['colPriority']} ASC');
    var result = await db!.query(table, orderBy: order);
    return result;
  }

  // Insert Operation: Insert new record to database
  Future<int> insert(String table, Map<String, dynamic> book) async {
    Database db = await database!;
    return await db.insert(table, book);
  }

  // Update Operation: Update record in the database
  Future<int> update(Book book) async {
    var db = await database;
    var result = await db!.update(table['tableName'], book.toMap(),
        where: '${table['colId']} = ?', whereArgs: [book.id]);
    return result;
  }

  // Delete Operation: Delete record from database
  Future<int> delete(int id) async {
    var db = await database;
    int result =
        await db!.delete(table['tableName'], where: 'id = ?', whereArgs: [id]);
    return result;
  }

  // Get the numbers of the records in database
  Future<int> getCount() async {
    Database db = await database!;
    List<Map<String, dynamic>> records =
        await db.rawQuery('SELECT COUNT (*) FROM ${table['tablename']}');
    int result = Sqflite.firstIntValue(records) ?? 0;
    return result;
  }

  // Get the MapList and convert it to NoteList
  Future<List<Book>> getBookList(String table, String order) async {
    List<Map<String, dynamic>> bookMapList = await getData(table, order);
    int count = bookMapList.length;
    List<Book> bookList = <Book>[];
    for (int i = 0; i < count; i++) {
      bookList.add(Book.fromMap(bookMapList[i]));
    }
    return bookList;
  }
}
