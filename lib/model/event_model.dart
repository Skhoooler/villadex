import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:villadex/model/database.dart' as db;
import 'package:villadex/model/address_model.dart';

class Event {
  /// Constructors
  Event({
    required this.name,
    required this.date,
    this.description,
    this.address,
    int? propertyKey,
    this.notification = false,
  })  : _propertyKey = propertyKey,
        _primaryKey = null,
        _dateCreated = DateTime.now();

  Event.existing({
    required this.name,
    this.description,
    this.address,
    required this.date,
    int? propertyKey,
    required int primaryKey,
    required DateTime dateCreated,
    required this.notification,
  })  : _primaryKey = primaryKey,
        _propertyKey = propertyKey,
        _dateCreated = dateCreated;

  Event.fromJSON({required Map<String, dynamic> json})
      : name = json['name'],
        description = json['description'],
        address = Address.fromJSON(json: jsonDecode(json['address'])),
        date = DateTime.parse(json['date']),
        notification = json['notification'] == 0 ? false : true,
        _primaryKey = json['event_id'],
        _propertyKey = json['property_id'],
        _dateCreated = DateTime.parse(json['dateCreated']);

  /// Data
  String name;
  String? description;
  Address? address;
  DateTime date;
  bool notification;

  final int? _primaryKey;
  final int? _propertyKey;
  final DateTime _dateCreated;

  /// Methods
  Future<void> insert() async {
    Map<String, dynamic> data = {
      'name': name,
      'description': description,
      'date': date.toIso8601String(),
      'address': address?.toJSON(),
      'property_id': _propertyKey,
      'dateCreated': _dateCreated.toIso8601String(),
      'notification': notification ? 1 : 0
    };

    db.DatabaseConnection.database.then(
        (databaseConnection) => {databaseConnection?.insert('events', data)});
  }

  static Future<Event?> fetchById(int id) async {
    String sql = "SELECT * FROM events WHERE event_id = $id";

    Future<List<Map<String, dynamic>>>? rawData;
    db.DatabaseConnection.database.then(
        (databaseConnection) => {rawData = databaseConnection?.rawQuery(sql)});

    return rawData?.then((data) {
      return Event.fromJSON(json: data[0]);
    });
  }

  static Future<List<Event?>?> fetchAllByProperty(int id) async {
    String sql;
    if (id < 0) {
      sql = "SELECT * FROM events";
    } else {
      sql = "SELECT * FROM events WHERE property_id = $id";
    }

    return db.DatabaseConnection.database.then((databaseConnection) {
      return databaseConnection?.rawQuery(sql).then((data) {
        return data.map((json) => Event.fromJSON(json: json)).toList();
      });
    });
  }

  static Future<List<Event?>?> fetchAll() async {
    String sql = "SELECT * FROM events";

    return db.DatabaseConnection.database.then((databaseConnection) {
      return databaseConnection?.rawQuery(sql).then((data) {
        return data.map((json) => Event.fromJSON(json: json)).toList();
      });
    });
  }

  String toJSON() {
    return jsonEncode({
      'name': name,
      'description': description,
      'address': address?.toJSON(),
      'date': date.toIso8601String(),
      'event_id': _primaryKey,
      'property_id': _propertyKey,
      'dateCreated': _dateCreated.toIso8601String(),
      'notification': notification ? 1 : 0,
    });
  }

  /// Getters
  int get key => _primaryKey ?? 0;

  int? get propertyKey => _propertyKey;

  DateTime get dateCreated => _dateCreated;
}
