import 'package:flutter/material.dart';

import 'package:villadex/model/database.dart' as db;

class Address {
  /// Constructors
  Address(
      {required this.street1,
      this.street2 = '',
      required this.city,
      this.state = '',
      this.zip = '',
      required this.country})
      : _dateCreated = DateTime.now(),
        _primaryKey = null,
        _propertyId = null,
        _associateId = null;

  Address.existing({
    required this.street1,
    this.street2 = '',
    required this.city,
    this.state = '',
    this.zip = '',
    required this.country,
    required DateTime dateCreated,
    required int primaryKey,
    int? propertyKey,
    int? associateKey,
  })  : _dateCreated = dateCreated,
        _primaryKey = primaryKey,
        _propertyId = propertyKey,
        _associateId = associateKey;

  Address.fromJson({required Map<String, dynamic> json})
      : street1 = json['street1'],
        street2 = json['street2'],
        city = json['city'],
        state = json['state'],
        zip = json['zip'],
        country = json['country'],
        _primaryKey = json['address_id'],
        _propertyId = json['property_id'],
        _associateId = json['associate_id'],
        _dateCreated = DateTime.parse(json['_dateCreated']);

  /// Data
  final String street1;
  final String street2;
  final String city;
  final String state;
  final String zip;
  final String country;

  final int? _primaryKey;
  final int? _propertyId;
  final int? _associateId;
  final DateTime _dateCreated;

  /// Methods
  Future<void> insert() async {
    Map<String, dynamic> data = {
      // SQFlite sets the primaryKey
      'property_id': _propertyId,
      'associate_id': _associateId,
      'dateCreated': _dateCreated.toIso8601String().trim(),
      'street1': street1,
      'street2': street2,
      'city': city,
      'zip': zip,
      'country': country
    };

    await db.DatabaseConnection.database.then((databaseConnection) =>
        {databaseConnection?.insert('addresses', data)});
  }

  // Returns an address by ID
  static Future<Address?> fetchById(int id) async {
    String sql = "SELECT * FROM addresses WHERE address_id = $id";

    Future<List<Map<String, dynamic>>>? rawData;
    await db.DatabaseConnection.database.then(
        (databaseConnection) => {rawData = databaseConnection?.rawQuery(sql)});

    return rawData?.then((data) {
      return Address.fromJson(json: data[0]);
    });
  }

  Map<String, dynamic> toJson() {
    return {
      'street1': street1,
      'street2': street2,
      'city': city,
      'state': state,
      'zip': zip,
      'country': country,
      'address_id': _primaryKey,
      'property_id': _propertyId,
      'associate_id': _associateId,
      'dateCreated': _dateCreated.toIso8601String()
    };
  }

  /// Getters
  String get fullAddress =>
      street1 +
      " " +
      street2 +
      ", " +
      city +
      " " +
      state +
      " " +
      zip +
      ", " +
      country;

  DateTime get dateCreated => _dateCreated;

  int get key => _primaryKey ?? 0;

  /// Setters
}
