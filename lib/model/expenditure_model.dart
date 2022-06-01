import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:villadex/model/associate_model.dart';
import 'package:villadex/model/database.dart' as db;
import 'package:villadex/model/category_model.dart';

class Expenditure {
  /// Constructors
  Expenditure({
    required this.name,
    this.description,
    required this.expenditureDate,
    required this.category,
    required this.amount,
    required this.numUnits,
    this.isPaid = false,
    required int propertyKey,
    List<Associate>? associates,
  })  : _propertyKey = propertyKey,
        _primaryKey = null,
        _dateCreated = DateTime.now(),
        associates = associates ?? [];

  Expenditure.existing({
    required this.name,
    this.description,
    required this.expenditureDate,
    required this.category,
    required this.amount,
    required this.numUnits,
    required this.isPaid,
    required int propertyKey,
    required int primaryKey,
    required DateTime dateCreated,
    List<Associate>? associates,
  })  : _primaryKey = primaryKey,
        _propertyKey = propertyKey,
        _dateCreated = dateCreated,
        associates = associates ?? [];

  Expenditure.fromJSON({required Map<String, dynamic> json})
      : name = json['name'],
        amount = json['amount'],
        numUnits = json['numberUnits'],
        isPaid = json['isPaid'] == 0 ? false : true,
        description = json['description'],
        category = json['category'],
        expenditureDate = DateTime.parse(json['date']),
        associates = jsonDecode(json['associates'])
            .map((data) => Associate.fromJSON(json: data))
            .toList(),
        _primaryKey = json['expenditure_id'],
        _propertyKey = json['property_id'],
        _dateCreated = DateTime.parse(json['dateCreated']);

  /// Data
  final String name;
  final String? description;
  final DateTime expenditureDate;
  final Category category;
  final double amount;
  final int numUnits;
  bool isPaid;
  List<Associate?>? associates;

  final int? _primaryKey;
  final int _propertyKey;
  final DateTime _dateCreated;

  /// Methods
  Future<void> insert() async {
    Map<String, dynamic> data = {
      'name': name,
      'amount': amount, 'numberUnits': numUnits,
      'isPaid': isPaid ? 1 : 0, // Set boolean to one or zero
      'description': description,
      'category': category.toJSON(),
      'date': expenditureDate.toIso8601String(),
      'associates': associates.toString(),
      'property_id': _propertyKey,
      'dateCreated': _dateCreated.toIso8601String()
    };

    db.DatabaseConnection.database.then((databaseConnection) =>
        databaseConnection?.insert('expenditures', data));
  }

  static Future<Expenditure?> fetchById(int id) async {
    String sql = "SELECT * FROM expenditures WHERE expenditure_id = $id";

    Future<List<Map<String, dynamic>>>? rawData;
    db.DatabaseConnection.database.then(
        (databaseConnection) => rawData = databaseConnection?.rawQuery(sql));

    return rawData?.then((data) {
      return Expenditure.fromJSON(json: data[0]);
    });
  }

  Map<String, dynamic> toJSON() {
    return {
      'name': name,
      'amount': amount,
      'numberUnits': numUnits,
      'isPaid': isPaid ? 1 : 0, // Set boolean to one or zero
      'description': description,
      'category': category.toJSON(),
      'date': expenditureDate.toIso8601String(),
      'associates': json.encode(
          associates?.map((expenditure) => expenditure?.toJSON()).toList()),
      'expenditure_id': _primaryKey,
      'property_id': _propertyKey,
      'dateCreated': _dateCreated.toIso8601String()
    };
  }

  /// Getters
  DateTime get dateCreated => _dateCreated;

  int get key => _primaryKey ?? 0;

  int get propertyKey => _propertyKey;
}
