import 'package:sqflite/sqflite.dart';
import 'dart:convert';

import 'package:villadex/model/database.dart' as db;
import 'package:villadex/model/address_model.dart';
import 'package:villadex/model/event_model.dart';
import 'package:villadex/model/expenditure_model.dart';
import 'package:villadex/model/earning_model.dart';
import 'package:villadex/model/associate_model.dart';
import '../routes/properties/menu options/generate_report_options.dart';

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
    required this.calendar,
    required this.expenditures,
    required this.associates,
    required this.earnings,
    required int? primaryKey,
    required DateTime dateCreated,
  })  : _address = address,
        _primaryKey = primaryKey,
        _dateCreated = dateCreated;

  Property.fromJSON({required Map<String, dynamic> json})
      : name = json['name'],
        owner = json['owner'],
        calendar = jsonDecode(json['calendar'])
                .forEach((data) => Event.fromJSON(json: data)) ??
            [],
        expenditures = jsonDecode(json['expenditures'])
                .forEach((data) => Expenditure.fromJSON(json: data)) ??
            [],
        associates = jsonDecode(json['associates'])
                .forEach((data) => Associate.fromJSON(json: data)) ??
            [],
        earnings = jsonDecode(json['earnings'])
                .forEach((data) => Earning.fromJSON(json: data)) ??
            [],
        _address = Address.fromJSON(json: jsonDecode(json['location'])),
        //Address.fromJSON(json: jsonDecode(json['location'])),
        _primaryKey = json['property_id'],
        _dateCreated = DateTime.parse(json['dateCreated']);

  /// Data
  String name;
  String? owner;

  final List<Event?> calendar;
  final List<Expenditure?> expenditures;
  final List<Associate?> associates;
  final List<Earning?> earnings;

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
          json.encode(calendar.map((event) => event?.toJSON()).toList()),
      'expenditures': json.encode(
          expenditures.map((expenditure) => expenditure?.toJSON()).toList()),
      'associates': json
          .encode(associates.map((associate) => associate?.toJSON()).toList()),
      'earnings':
          json.encode(earnings.map((earning) => earning?.toJSON()).toList()),
      'location': address.toJSON(),
      'dateCreated': _dateCreated.toIso8601String().trim()
    };

    db.DatabaseConnection.database.then((databaseConnection) => {
          databaseConnection?.insert('properties', data,
              conflictAlgorithm: ConflictAlgorithm.replace)
        });
  }

  Future<void> update() async {
    Map<String, dynamic> data = {
      // SQFlite sets the primary key
      'name': name,
      'owner': owner,
      'calendar':
          json.encode(calendar.map((event) => event?.toJSON()).toList()),
      'expenditures': json.encode(
          expenditures.map((expenditure) => expenditure?.toJSON()).toList()),
      'associates': json
          .encode(associates.map((associate) => associate?.toJSON()).toList()),
      'earnings':
          json.encode(earnings.map((earning) => earning?.toJSON()).toList()),
      'location': address.toJSON(),
      'dateCreated': _dateCreated.toIso8601String().trim()
    };

    db.DatabaseConnection.database.then((databaseConnection) {
      databaseConnection?.update(
        'properties',
        data,
        where: 'property_id = ?',
        whereArgs: [_primaryKey],
      );
    });
  }

  static Future<Property?> fetchById(int id) async {
    String sql = "SELECT * FROM properties WHERE property_id = $id";

    Future<List<Map<String, dynamic>>>? rawData;
    return db.DatabaseConnection.database.then((databaseConnection) {
      rawData = databaseConnection?.rawQuery(sql);
      return rawData?.then((data) => Property.fromJSON(json: data[0]));
    });
  }

  static Future<List<Property?>?> fetchAll() async {
    String sql = "SELECT * FROM properties";

    return db.DatabaseConnection.database.then((databaseConnection) {
      return databaseConnection?.rawQuery(sql).then((data) {
        return data.map((json) => Property.fromJSON(json: json)).toList();
      });
    });
  }

  static Future<void> deleteById(int id) async {
    db.DatabaseConnection.database.then((databaseConnection) {
      databaseConnection
          ?.rawDelete('DELETE FROM properties WHERE property_id = ?', [id]);
    });
  }

  String toJSON() {
    return jsonEncode({
      'name': name,
      'owner': owner,
      'location': address.toJSON(),
      'calendar':
          json.encode(calendar.map((event) => event?.toJSON()).toList()),
      'expenditures': json.encode(
          expenditures.map((expenditure) => expenditure?.toJSON()).toList()),
      'associates': json
          .encode(associates.map((associate) => associate?.toJSON()).toList()),
      'earnings':
          json.encode(earnings.map((earning) => earning?.toJSON()).toList()),
      'dateCreated': _dateCreated.toIso8601String().trim(),
      'property_id': _primaryKey,
    });
  }

  /// Getters
  DateTime get dateCreated => _dateCreated;

  int get key => _primaryKey ?? 0;

  Address get address => _address;

  /// Returns a list of change in income (previous income + (earning - expenditures)) by
  /// taking two DateTime objects (a starting point, and an ending point)
  /// and an optional interval (defaults to monthly)
  Future<List<double>> getIncomeByInterval(DateTime start, DateTime end,
      {DataInterval interval = DataInterval.monthly}) async {
    List<double> data = [0]; // Return value. It has a 0 in it to help calculations
                             // later on. It gets removed at the end.
    int dayInterval; // Interval to search in

    /// Set up the interval to select data from
    if (interval == DataInterval.weekly) {
      dayInterval = 7;
    } else if (interval == DataInterval.biWeekly) {
      dayInterval = 14;
    } else if (interval == DataInterval.biYearly) {
      dayInterval = 181;
    } else if (interval == DataInterval.yearly) {
      dayInterval = 365;
    } else if (interval == DataInterval.yearToDate) {
      dayInterval = start.difference(end).inDays;
    } else {
      dayInterval = 30; // Monthly interval is default
    }

    /// Fetch expenditures and earnings from database
    List<Expenditure?> expenditures =
        await Expenditure.fetchAllByProperty(_primaryKey ?? 0) ?? [];
    List<Earning?> earnings = await Earning.fetchAll() ?? [];

    /// Get all data points
    DateTime intervalStart = start;
    DateTime intervalEnd = start.add(Duration(days: dayInterval));
    bool firstLoop = true; // So it will loop at least once
    while (intervalEnd.isBefore(end) || firstLoop) {
      double expenditureTotal = 0;
      double earningTotal = 0;

      /// Loop through expenditures
      expenditures
          // Select expenditures that are between intervalStart and intervalEnd
          .where((expenditure) =>
              (expenditure?.expenditureDate.isBefore(intervalEnd) ?? false) &&
              (expenditure?.expenditureDate.isAfter(intervalStart) ?? false))
          // For each selected, add their total to the expenditure total
          .forEach((expenditure) {
        expenditureTotal += expenditure?.numericTotal ?? 0;
      });

      /// Loop through earnings
      earnings
          // Select earnings that are between intervalStart and intervalEnd
          .where((earning) =>
              (earning?.earningDate.isBefore(intervalEnd) ?? false) &&
              (earning?.earningDate.isAfter(intervalStart) ?? false))
          // For each selected, add their total to the earning total
          .forEach((earning) {
        earningTotal += earning?.amount ?? 0;
      });

      /// Add to the data list
      data.add((data.last + (earningTotal - expenditureTotal)));

      /// Increment intervalStart and intervalEnd
      intervalStart = intervalStart.add(Duration(days: dayInterval));
      intervalEnd = intervalEnd.add(Duration(days: dayInterval));
      firstLoop = false;
    }
    data.removeAt(0); // Get rid of the leading 0 at the start of the list

    print(data);
    return data;
  }
}
