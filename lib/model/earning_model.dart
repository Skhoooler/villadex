import 'dart:convert';

import 'package:villadex/model/database.dart' as db;
import 'package:villadex/model/category_model.dart';

class Earning {
  /// Constructors
  Earning({
    required this.name,
    this.description,
    required this.earningDate,
    required this.category,
    required this.amount,
    required int propertyKey,
  })  : _propertyKey = propertyKey,
        _primaryKey = null,
        _dateCreated = DateTime.now();

  Earning.existing({
    required this.name,
    this.description,
    required this.earningDate,
    required this.category,
    required this.amount,
    required int propertyKey,
    required int primaryKey,
    required DateTime dateCreated,
  })  : _propertyKey = propertyKey,
        _primaryKey = primaryKey,
        _dateCreated = dateCreated;

  Earning.fromJSON({required Map<String, dynamic> json})
      : name = json['name'],
        description = json['description'],
        earningDate = DateTime.parse(json['date']),
        category = Category.fromJSON(json: jsonDecode(json['category'])),
        amount = json['amount'],
        _primaryKey = json['earning_id'],
        _propertyKey = json['property_id'],
        _dateCreated = DateTime.parse(json['dateCreated']);

  /// Data
  final String name;
  final String? description;
  final DateTime earningDate;
  final Category? category;
  final double amount;

  final int? _primaryKey;
  final int _propertyKey;
  final DateTime _dateCreated;

  /// Methods
  Future<void> insert() async {
    Map<String, dynamic> data = {
      'name': name,
      'description': description,
      'date': earningDate.toIso8601String().trim(),
      'category': category?.toJSON(),
      'amount': amount,
      'property_id': _propertyKey,
      'dateCreated': _dateCreated.toIso8601String().trim(),
    };

    db.DatabaseConnection.database.then(
        (databaseConnection) => {databaseConnection?.insert('earnings', data)});
  }

  static Future<Earning?> fetchById(int id) async {
    String sql = "SELECT * FROM earnings WHERE earning_id = $id";

    Future<List<Map<String, dynamic>>>? rawData;
    db.DatabaseConnection.database.then(
        (databaseConnection) => {rawData = databaseConnection?.rawQuery(sql)});

    return rawData?.then((data) {
      return Earning.fromJSON(json: data[0]);
    });
  }

  static Future<List<Earning?>?> fetchAll() async {
    String sql = "SELECT * FROM earnings";

    return db.DatabaseConnection.database.then((databaseConnection) {
      return databaseConnection?.rawQuery(sql).then((data) {
        return data.map((json) => Earning.fromJSON(json: json)).toList();
      });
    });
  }

  static Future<List<Earning?>?> fetchAllByProperty(int id) async {
    String sql;
    if (id < 0) {
      sql = "SELECT * FROM earnings";
    } else {
      sql = "SELECT * FROM earnings WHERE property_id = $id";
    }

    return db.DatabaseConnection.database.then((databaseConnection) {
      return databaseConnection?.rawQuery(sql).then((data) {
        return data.map((json) => Earning.fromJSON(json: json)).toList();
      });
    });
  }

  String toJSON() {
    return jsonEncode({
      'name': name,
      'amount': amount,
      'description': description,
      'category': category?.toJSON(),
      'date': earningDate.toIso8601String(),
      'expenditure_id': _primaryKey,
      'property_id': _propertyKey,
      'dateCreated': _dateCreated.toIso8601String()
    });
  }

  /// Getters
  DateTime get dateCreated => _dateCreated;

  int get key => _primaryKey ?? 0;

  int get propertyKey => _propertyKey;
}
