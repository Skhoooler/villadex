import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'package:villadex/model/database.dart' as db;
import 'package:villadex/model/address_model.dart';

class Property {
  /// Constructors
  Property({
    required this.name,
    required Address address,
    required this.owner,
  })  : _address = address,
        _primaryKey = null,
        _dateCreated = DateTime.now();

  Property.existing(
      {required this.name,
      required Address address,
      required this.owner,
      required int? primaryKey,
      required DateTime dateCreated})
      : _address = address,
        _primaryKey = primaryKey,
        _dateCreated = dateCreated;

  Property.fromJSON({required Map<String, dynamic> json})
      : name = json['name'],
        owner = json['owner'],
        _address = Address.fromJson(json: json['location']),
        _primaryKey = json['property_id'],
        _dateCreated = DateTime.fromMillisecondsSinceEpoch(json['dateCreated']);

  /// Data
  String name;
  String? owner;
  final Address _address;

  /*final List<Event> calendar;
  final List<Expenditure> expenditures;
  final List<Associate> associates;
  final List<Earning> earnings;*/

  final int? _primaryKey;
  final DateTime _dateCreated;

  ///Methods
  Future<void> insert() async {
    String dateCreated = _dateCreated.toIso8601String().trim();

    Map<String, dynamic> data = {
      // SQFlite sets the primary key
      'name': name,
      'owner': owner,
      'location': address.toJson(),
      'dateCreated': dateCreated,
    };

    await db.DatabaseConnection.database.then((databaseConnection) => {
          databaseConnection?.insert('properties', data,
              conflictAlgorithm: ConflictAlgorithm.replace)
        });
  }

  static Future<Property?> fetchById(int id) async {
    String sql = "SELECT * FROM properties WHERE property_id = $id";

    Future<List<Map<String, dynamic>>>? rawData;
    await db.DatabaseConnection.database.then(
        (databaseConnection) => {rawData = databaseConnection?.rawQuery(sql)});

    return rawData?.then((data) {
      return Property.fromJSON(json: data[0]);
    });
  }

  /// Getters
  Address get address => _address;
}
