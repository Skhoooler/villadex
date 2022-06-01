import 'package:flutter/material.dart';

import 'package:villadex/model/database.dart' as db;
import 'package:villadex/model/address_model.dart';

class Event {
  /// Constructors
  Event({
    required this.name,
    this.description,
    this.address,
    int? propertyKey,
  })
      : _propertyKey = propertyKey,
        _primaryKey = null,
        _dateCreated = DateTime.now();

  Event.existing({
    required this.name,
    this.description,
    this.address,
    int? propertyKey,
    required int primaryKey,
    required DateTime dateCreated,
  })
      : _primaryKey = primaryKey,
        _propertyKey = propertyKey,
        _dateCreated = dateCreated;

  Event.fromJSON({required Map<String, dynamic> json})
      : name = json['name'],
        description = json['description'],
        address = Address.fromJSON(json: json['address']),
        _primaryKey = json['event_id'],
        _propertyKey = json['property_id'],
        _dateCreated = DateTime.parse(json['dateCreated']);

  /// Data
  String name;
  String? description;
  Address? address;

  final int? _primaryKey;
  final int? _propertyKey;
  final DateTime _dateCreated;

  /// Methods
  Future<void> insert() async {
    Map<String, dynamic> data = {
      'name': name,
      'description': description,
      'address': address?.toJSON(),
      'property_id': _propertyKey,
      'dateCreated': _dateCreated.toIso8601String()
    };

    db.DatabaseConnection.database.then(
            (databaseConnection) => databaseConnection?.insert('events', data));
  }

  static Future<Event?> fetchById(int id) async {
    String sql = "SELECT * FROM events WHERE event_id = $id";

    Future<List<Map<String, dynamic>>>? rawData;
    db.DatabaseConnection.database.then(
            (databaseConnection) =>
        rawData = databaseConnection?.rawQuery(sql));

    return rawData?.then((data) {
      return Event.fromJSON(json: data[0]);
    });
  }

  Map<String, dynamic> toJSON() {
    return {
      'name': name,
      'description': description,
      'address': address?.toJSON(),
      'event_id': _primaryKey,
      'property_id': _propertyKey,
      'dateCreated': _dateCreated.toIso8601String()
    };
  }

  /// Getters
  int get key => _primaryKey ?? 0;

  int? get propertyKey => _propertyKey;

  DateTime get dateCreated => _dateCreated;
}
