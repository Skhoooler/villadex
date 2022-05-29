import 'package:flutter/material.dart';

import 'package:villadex/model/expenditure_model.dart';
import 'package:villadex/model/contact_model.dart';

class Associate {
  /// Constructors
  Associate({
    required this.name,
    required this.contact,
    this.role = '',
    List<Expenditure>? payments,
  })  : _dateCreated = DateTime.now(),
        _primaryKey = null,
        payments = payments ?? [];

  Associate.existing({
    required this.name,
    required this.contact,
    this.role = '',
    List<Expenditure>? payments,
    required DateTime dateCreated,
    required int key,
  })  : _dateCreated = dateCreated,
        _primaryKey = key,
        payments = payments ?? [];

  /// Data
  final String name;
  final String role;
  List<Expenditure> payments;
  final Contact contact;

  final int? _primaryKey;
  final DateTime _dateCreated;

  /// Getters
  DateTime get dateCreated => _dateCreated;

  int get key => _primaryKey ?? 0;
}
