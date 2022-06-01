import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

import 'package:villadex/model/property_model.dart';


class DatabaseConnection {
  //static final DatabaseConnection instance = DatabaseConnection.init();

  //DatabaseConnection._init();

  /// Database variable
  static Database? _database;

  /// Getter for the database
  static Future<Database?> get database async {
    // If _database is null, set it equal to the return value of _initDB
    _database ??= await _initDB('database4');

    return _database;
  }

  /// Initialize database
  static Future<Database?> _initDB(String dbname) async {
    final dbPath = await getApplicationDocumentsDirectory();
    final path = join(dbPath.toString(), dbname);

    var dbInstance = await openDatabase(path, version: 1, onCreate: _createDatabase);

    return dbInstance;
  }

  /// Create the database
  static Future _createDatabase(Database database, int version) async {
    Batch batch = database.batch();

    /// CREATE PROPERTIES TABLE
    batch.execute('''CREATE TABLE properties(
      property_id INTEGER PRIMARY KEY,
      dateCreated TEXT NOT NULL,

      name TEXT NOT NULL,
      location TEXT NOT NULL,
      owner TEXT NOT NULL,
    
      calendar TEXT,
      expenditures TEXT,
      associates TEXT,
      earnings TEXT
      );''');

    /// CREATE EXPENDITURES TABLE
    batch.execute('''CREATE TABLE expenditures(
      expenditure_id INTEGER PRIMARY KEY,
      property_id INTEGER NOT NULL,
      dateCreated TEXT NOT NULL,

      name TEXT NOT NULL,
      amount REAL NOT NULL,
      numberUnits INTEGER NOT NULL,
      isPaid INTEGER NOT NULL,

      description TEXT,
      category TEXT,
      date TEXT,
      associates TEXT,

      FOREIGN KEY (property_id)
        REFERENCES properties(property_id)
      );''');

    /// CREATE EARNINGS TABLE
    batch.execute(''' CREATE TABLE earnings(
      earning_id INTEGER PRIMARY KEY,
      property_id INTEGER NOT NULL,
      dateCreated TEXT NOT NULL,

      name TEXT NOT NULL,
      amount REAL NOT NULL,

      description TEXT,
      category TEXT,
      date TEXT NOT NULL,

      FOREIGN KEY (property_id)
        REFERENCES properties(property_id)
      );''');

    /// CREATE CATEGORIES TABLE
    batch.execute(''' CREATE TABLE categories(
      category_id INTEGER NOT NULL,
      parent_id INTEGER,
      dateCreated TEXT NOT NULL,

      name TEXT NOT NULL
      );''');

    /// CREATE ASSOCIATES TABLE
    batch.execute(''' CREATE TABLE associates(
      associate_id INTEGER PRIMARY KEY,
      property_id INTEGER NOT NULL,
      dateCreated TEXT NOT NULL,

      name TEXT NOT NULL,

      contact TEXT,
      role TEXT,
      payments TEXT,
      FOREIGN KEY (property_id)
        REFERENCES properties (property_id)
      );''');

    /// CREATE CONTACTS TABLE
    batch.execute(''' CREATE TABLE contact (
      contact_id INTEGER PRIMARY KEY,
      associate_id INTEGER NOT NULL,
      dateCreated TEXT NOT NULL

      phoneNumber TEXT,
      email TEXT,
      address TEXT,
      FOREIGN KEY (associate_id)
        REFERENCES associates (associate_id)
      );''');

    /// CREATE ADDRESSES TABLE
    batch.execute(''' CREATE TABLE addresses (
      address_id INTEGER PRIMARY KEY,
      property_id INTEGER,
      associate_id INTEGER,
      dateCreated TEXT NOT NULL,

      street1 TEXT NOT NULL,
      street2 TEXT,
      city TEXT NOT NULL,
      zip TEXT,
      state TEXT,
      country TEXT NOT NULL,
      FOREIGN KEY (property_id)
        REFERENCES properties (property_id),
      FOREIGN KEY (associate_id)
        REFERENCES associates (associate_id)
      );''');

    /// CREATE EVENT TABLE
    batch.execute(''' CREATE TABLE events (
      event_id INTEGER PRIMARY KEY,
      property_id INTEGER NOT NULL,
      dateCreated TEXT NOT NULL,

      name TEXT NOT NULL,

      description TEXT,
      address TEXT,

      FOREIGN KEY (property_id)
        REFERENCES properties (property_id)
      );''');

    batch.commit();
  }

  Future close() async {
    _database?.close;
  }
}