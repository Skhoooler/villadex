import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';


class DatabaseConnection {
  //static final DatabaseConnection instance = DatabaseConnection.init();

  DatabaseConnection._init();

  /// Database variable
  static Database? _database;

  /// Getter for the database
  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await _initDB('database');
    return _database;
  }

  /// Initialize database
  Future<Database?> _initDB(String dbname) async {
    final dbPath = await getApplicationDocumentsDirectory();
    final path = join(dbPath.toString(), dbname);

    var dbInstance = await openDatabase(path, version: 1, onCreate: _createDatabase);

    return dbInstance;
  }

  /// Create the database
  Future _createDatabase(Database database, int version) async {
    // Todo: Create the database
    return await database.execute('''sql''');
  }

  Future close() async {
    _database?.close;
  }
}