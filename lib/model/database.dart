import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:convert';

class DatabaseConnection {
  //static final DatabaseConnection instance = DatabaseConnection.init();

  DatabaseConnection._init();

  static Database? _database;
}