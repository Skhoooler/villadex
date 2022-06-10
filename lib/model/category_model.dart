import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:villadex/model/database.dart' as db;

class Category {
  /// Constructors
  Category({required this.name, int parentKey = 0})
      : _primaryKey = null,
        _parentKey = parentKey,
        _dateCreated = DateTime.now();

  Category.existing(
      {required int primaryKey,
      required this.name,
      int parentKey = 0,
      required DateTime dateCreated})
      : _dateCreated = dateCreated,
        _parentKey = parentKey,
        _primaryKey = primaryKey;

  Category.fromJSON({required Map<String, dynamic> json})
      : name = json['name'],
        _primaryKey = json['category_id'],
        _parentKey = json['parent_id'],
        _dateCreated = DateTime.parse(json['dateCreated']);

  /// Data
  final String name;

  final int? _primaryKey;
  final int? _parentKey;
  final DateTime _dateCreated;

  /// Methods
  Future<void> insert() async {
    Map<String, dynamic> data = {
      'name': name,
      'parent_id': _parentKey,
      'dateCreated': _dateCreated.toIso8601String()
    };

    db.DatabaseConnection.database.then((databaseConnection) =>
        {databaseConnection?.insert('categories', data,
            conflictAlgorithm: ConflictAlgorithm.replace)});
  }

  static Future<Category?> fetchById(int id) async {
    String sql = "SELECT * FROM categories WHERE category_id = $id";

    Future<List<Map<String, dynamic>>>? rawData;
    db.DatabaseConnection.database.then(
        (databaseConnection) => {rawData = databaseConnection?.rawQuery(sql)});

    return rawData?.then((data) {
      return Category.fromJSON(json: data[0]);
    });
  }

  String toJSON() {
    return jsonEncode({
      'name': name,
      'category_id': _primaryKey,
      'parent_id': _parentKey,
      'dateCreated': _dateCreated.toIso8601String()
    });
  }

  /// Getters
  DateTime get dateCreated => _dateCreated;

  int get key => _primaryKey ?? 0;

  int get parentKey => _parentKey ?? 0;
}
