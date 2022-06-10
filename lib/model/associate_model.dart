import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:villadex/model/database.dart' as db;
import 'package:villadex/model/expenditure_model.dart';
import 'package:villadex/model/contact_model.dart';

class Associate {
  /// Constructors
  Associate({
    required this.name,
    this.contact,
    this.role = '',
    List<Expenditure>? payments,
    required int propertyKey,
  })  : _dateCreated = DateTime.now(),
        _primaryKey = null,
        _propertyKey = propertyKey,
        payments = payments ?? [];

  Associate.existing({
    required this.name,
    required this.contact,
    this.role = '',
    List<Expenditure>? payments,
    required DateTime dateCreated,
    required int propertyKey,
    required int key,
  })  : _dateCreated = dateCreated,
        _primaryKey = key,
        _propertyKey = propertyKey,
        payments = payments ?? [];

  Associate.fromJSON({required Map<String, dynamic> json})
      : name = json['name'],
        role = json['owner'],
        payments = jsonDecode(json['payments'])
            .map((data) => Expenditure.fromJSON(json: data))
            .toList(),
        contact = Contact.fromJSON(json: json['contact']),
        _primaryKey = json['associate_id'],
        _propertyKey = json['property_id'],
        _dateCreated = DateTime.parse(json['dateCreated']);

  /// Data
  final String name;
  final String? role;
  List<Expenditure?>? payments;
  final Contact? contact;

  final int? _primaryKey;
  final int _propertyKey;
  final DateTime _dateCreated;

  /// Methods
  Future<void> insert() async {
    Map<String, dynamic> data = {
      'associate_id': _primaryKey,
      'property_id': _propertyKey,
      'dateCreated': _dateCreated.toIso8601String(),
      'name': name,
      'contact': contact?.toJSON,
      'role': role,
      // JSON encode the list of expenditure objects. Turn each object into json, turn that
      // into a list and then json encode it.
      'payments': json.encode(
          payments?.map((expenditure) => expenditure?.toJSON()).toList())
    };

    db.DatabaseConnection.database.then(
        (databaseConnection) => {databaseConnection?.insert('associates', data)});
  }

  static Future<Associate?> fetchById(int id) async {
    String sql = "SELECT * FROM associate WHERE associate_id = $id";

    Future<List<Map<String, dynamic>>>? rawData;
    db.DatabaseConnection.database.then(
        (databaseConnection) => {rawData = databaseConnection?.rawQuery(sql)});

    return rawData?.then((data) {
      return Associate.fromJSON(json: data[0]);
    });
  }

  Map<String, dynamic> toJSON() {
    return {
      'associate_id': _primaryKey,
      'property_id': _propertyKey,
      'dateCreated': _dateCreated.toIso8601String(),
      'name': name,
      'contact': contact?.toJSON,
      'role': role,
      // JSON encode the list of expenditure objects. Turn each object into json, turn that
      // into a list and then json encode it.
      'payments': json.encode(
          payments?.map((expenditure) => expenditure?.toJSON()).toList())
    };
  }

  /// Getters
  DateTime get dateCreated => _dateCreated;

  int get key => _primaryKey ?? 0;

  int get propertyKey => _propertyKey;
}
