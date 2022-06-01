import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:convert';

import 'package:villadex/model/database.dart' as db;
import 'package:villadex/model/address_model.dart';
import 'package:villadex/model/event_model.dart';
import 'package:villadex/model/expenditure_model.dart';
import 'package:villadex/model/earning_model.dart';
import 'package:villadex/model/associate_model.dart';

class Property {
  /// Constructors
  Property({
    required this.name,
    required Address address,
    List<Event>? events,
    List<Expenditure>? expenditures,
    List<Associate>? associates,
    List<Earning>? earnings,
    required this.owner,
  })  : calendar = events ?? [],
        expenditures = expenditures ?? [],
        associates = associates ?? [],
        earnings = earnings ?? [],
        _address = address,
        _primaryKey = null,
        _dateCreated = DateTime.now();

  Property.existing({
    required this.name,
    required Address address,
    required this.owner,
    List<Event>? events,
    List<Expenditure>? expenditures,
    List<Associate>? associates,
    List<Earning>? earnings,
    required int? primaryKey,
    required DateTime dateCreated,
  })  : calendar = events ?? [],
        expenditures = expenditures ?? [],
        associates = associates ?? [],
        earnings = earnings ?? [],
        _address = address,
        _primaryKey = primaryKey,
        _dateCreated = dateCreated;

  Property.fromJSON({required Map<String, dynamic> json})
      : name = json['name'],
        owner = json['owner'],
        calendar = jsonDecode(json['calendar'])
            .map((data) => Event.fromJSON(json: data))
            .toList(),
        expenditures = jsonDecode(json['expenditures'])
            .map((data) => Expenditure.fromJSON(json: data))
            .toList(),
        associates = jsonDecode(json['associates'])
            .map((data) => Associate.fromJSON(json: data))
            .toList(),
        earnings = jsonDecode(json['earnings'])
            .map((data) => Earning.fromJSON(json: data))
            .toList(),
        _address = Address.fromJSON(json: json['location']),
        _primaryKey = json['property_id'],
        _dateCreated = DateTime.fromMillisecondsSinceEpoch(json['dateCreated']);

  /// Data
  String name;
  String? owner;

  final List<Event?>? calendar;
  final List<Expenditure?>? expenditures;
  final List<Associate?>? associates;
  final List<Earning?>? earnings;

  final Address _address;
  final int? _primaryKey;
  final DateTime _dateCreated;

  ///Methods
  Future<void> insert() async {
    Map<String, dynamic> data = {
      // SQFlite sets the primary key
      'name': name,
      'owner': owner,
      'calendar':
          json.encode(calendar?.map((event) => event?.toJSON()).toList()),
      'expenditures': json.encode(
          expenditures?.map((expenditure) => expenditure?.toJSON()).toList()),
      'associates': json
          .encode(associates?.map((associate) => associate?.toJSON()).toList()),
      'earnings':
          json.encode(earnings?.map((earning) => earning?.toJSON()).toList()),
      'location': address.toJSON(),
      'dateCreated': _dateCreated.toIso8601String().trim()
    };

    db.DatabaseConnection.database.then((databaseConnection) =>
        databaseConnection?.insert('properties', data,
            conflictAlgorithm: ConflictAlgorithm.replace));
  }

  static Future<Property?> fetchById(int id) async {
    String sql = "SELECT * FROM properties WHERE property_id = $id";

    Future<List<Map<String, dynamic>>>? rawData;
    db.DatabaseConnection.database.then(
        (databaseConnection) => rawData = databaseConnection?.rawQuery(sql));

    return rawData?.then((data) {
      return Property.fromJSON(json: data[0]);
    });
  }

  Map<String, dynamic> toJSON() {
    return {
      'name': name,
      'owner': owner,
      'location': address.toJSON(),
      'calendar':
          json.encode(calendar?.map((event) => event?.toJSON()).toList()),
      'expenditures': json.encode(
          expenditures?.map((expenditure) => expenditure?.toJSON()).toList()),
      'associates': json
          .encode(associates?.map((associate) => associate?.toJSON()).toList()),
      'earnings':
          json.encode(earnings?.map((earning) => earning?.toJSON()).toList()),
      'dateCreated': _dateCreated.toIso8601String().trim(),
      'property_id': _primaryKey,
    };
  }

  /// Getters
  DateTime get dateCreated => _dateCreated;

  int get key => _primaryKey ?? 0;

  Address get address => _address;
}