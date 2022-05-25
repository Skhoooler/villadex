import 'package:flutter/material.dart';

class Property {

  Property({
    required String name,
    required String streetAddress,
    required String city,
    required String state,
    required String zip,
    required String country }) :
        _name = name,
        _streetAddress = streetAddress,
        _city = city,
        _state = state,
        _zip = zip,
        _country = country;


  final String _name;
  final String _streetAddress;
  final String _city;
  final String _state;
  final String _zip;
  final String _country;

  String get name => _name;

  String get streetAddress => _streetAddress;

  String get city => _city;

  String get state => _state;

  String get zip => _zip;

  String get country => _country;
}