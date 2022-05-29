import 'package:sqflite/sqflite.dart';

import 'package:villadex/model/address_model.dart';
import 'package:villadex/model/database.dart' as db;

class Contact {
  /// Constructors
  Contact({
    required int associateKey,
    this.phoneNumber = '',
    this.email = '',
    this.address,
  })  : _contactKey = null,
        _associateKey = associateKey,
        _dateCreated = DateTime.now();

  Contact.existing(
      {required int associateKey,
      this.phoneNumber = '',
      this.email = '',
      this.address,
      required DateTime dateCreated,
      required int contactKey})
      : _associateKey = associateKey,
        _contactKey = contactKey,
        _dateCreated = dateCreated;

  Contact.fromJSON({required Map<String, dynamic> json})
      : phoneNumber = json['phoneNumber'],
        email = json['email'],
        address = Address.fromJSON(json: json['address']),
        _contactKey = json['contact_id'],
        _associateKey = json['associate_id'],
        _dateCreated = json['dateCreated'];

  /// Data
  String phoneNumber;
  String email;
  Address? address;

  final int? _contactKey;
  final int _associateKey;
  final DateTime _dateCreated;

  /// Methods
  Future<void> insert() async {
    Map<String, dynamic> data = {
      'contact_id': _contactKey,
      'associate_id':_associateKey,
      'dateCreated': _dateCreated.toIso8601String(),
      'phoneNumber':phoneNumber,
      'email': email,
      'address': address?.toJSON(),
    };

    await db.DatabaseConnection.database.then((databaseConnection) => {
      databaseConnection?.insert('contact', data,
          conflictAlgorithm: ConflictAlgorithm.replace)
    });
  }

  static Future<Contact?> fetchById(int id) async {
    String sql = "SELECT * FROM contact WHERE contact_id = $id";

    Future<List<Map<String, dynamic>>>? rawData;
    await db.DatabaseConnection.database.then(
            (databaseConnection) => {rawData = databaseConnection?.rawQuery(sql)});

    return rawData?.then((data) {
      return Contact.fromJSON(json: data[0]);
    });
  }

  Map<String, dynamic> toJSON() {
    return {
      'contact_id': _contactKey,
      'associate_id':_associateKey,
      'dateCreated': _dateCreated.toIso8601String(),
      'phoneNumber':phoneNumber,
      'email': email,
      'address': address?.toJSON(),
    };
  }

  /// Getters
  DateTime get dateCreated => _dateCreated;

  int get key => _contactKey ?? 0;

  int get associateKey => _associateKey;
}
