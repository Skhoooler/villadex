
import 'dart:async';

import '../model/earning_model.dart';
import '../model/property_model.dart';
import '../model/expenditure_model.dart';

class VilladexAnalysis {

  VilladexAnalysis({required this.property}) {
    // Set expenditures
    unawaited(
        Expenditure.fetchAll().then((list) => expenditures = list ?? [])
    );

    // Set earnings
    unawaited(
        Earning.fetchAll().then((list) => earnings= list ?? [])
    );
  }

  Property property;

  late List<Expenditure?> expenditures;
  late List<Earning?> earnings;

  /// Reload expenditure and earning data
  reload() {
    // Set expenditures
    unawaited(
        Expenditure.fetchAll().then((list) => expenditures = list ?? [])
    );

    // Set earnings
    unawaited(
        Earning.fetchAll().then((list) => earnings= list ?? [])
    );
  }
}