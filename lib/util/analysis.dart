import 'dart:async';

import '../model/earning_model.dart';
import '../model/property_model.dart';
import '../model/expenditure_model.dart';

enum DataInterval { weekly, biWeekly, monthly, biYearly, yearly, yearToDate }

class VilladexAnalysis {
  ////////////////////////////////////////////////////////////////////
  /// Constructors
  ////////////////////////////////////////////////////////////////////
  /// Private so users go through the create() factory.
  VilladexAnalysis._create({
    required this.property,
    required this.expenditures,
    required this.earnings,
  });

  /// Public factory initializes the VilladexAnalysis._create() constructor
  static Future<VilladexAnalysis> create(Property property) async {
    // Get Expenditures and Elements from database
    List<Expenditure?> expenditures =
        await Expenditure.fetchAllByProperty(property.key) ?? [];
    List<Earning?> earnings =
        await Earning.fetchAllByProperty(property.key) ?? [];

    // Sort them
    expenditures.sort((a, b) =>
        a?.expenditureDate.compareTo(b?.expenditureDate ?? DateTime.now()) ??
        -1);
    earnings.sort((a, b) =>
        a?.earningDate.compareTo(b?.earningDate ?? DateTime.now()) ?? -1);

    // Create an analyzer object and return it with the correct data
    VilladexAnalysis analyzer = VilladexAnalysis._create(
        property: property, expenditures: expenditures, earnings: earnings);
    return analyzer;
  }

  ////////////////////////////////////////////////////////////////////
  /// DATA
  ////////////////////////////////////////////////////////////////////
  Property property;

  late List<Expenditure?> expenditures;
  late List<Earning?> earnings;

  ////////////////////////////////////////////////////////////////////
  /// METHODS
  ////////////////////////////////////////////////////////////////////
  /// Gets the gross income (just earnings) within a specific window of time
  Future<double> getGrossByInterval(DateTime start, DateTime end) async {
    double gross = 0;

    earnings
        .where((earning) =>
            (earning?.earningDate.isBefore(end) ?? false) &&
            (earning?.earningDate.isAfter(start) ?? false))
        .forEach((earning) => gross += earning?.amount ?? 0);

    return gross;
  }

  /// Gets the net income (earnings - expenditures within a specific window of time
  Future<double> getNetByInterval(DateTime start, DateTime end) async {
    /// Set net to gross
    double net = await getGrossByInterval(start, end);

    /// Subtract the gross by the expenditures within that same interval0
    expenditures
        .where((expenditure) =>
            (expenditure?.expenditureDate.isBefore(end) ?? false) &&
            (expenditure?.expenditureDate.isAfter(start) ?? false))
        .forEach((expenditure) => net -= expenditure?.amount ?? 0);

    return net;
  }

  /// Gets the change in income (earnings - expenditure) within a specific
  /// window of time (between start and end)
  Future<List<double>> getIncomeByInterval(DateTime start, DateTime end,
      {DataInterval interval = DataInterval.monthly}) async {
    // Total holds the total income. It is used to calculate the change in income
    double total = 0;

    return _getDataByInterval(start, end, (intervalStart, intervalEnd) {
      // Holds the total for this round of the loop
      double currentExpenditures = total;
      double currentEarnings = total;

      /// Loop through expenditures
      expenditures
          // Select expenditures that are between intervalStart and intervalEnd
          .where((expenditure) =>
              (expenditure?.expenditureDate.isBefore(intervalEnd) ?? false) &&
              (expenditure?.expenditureDate.isAfter(intervalStart) ?? false))
          // For each selected, add their total to the expenditure total
          .forEach((expenditure) {
        currentExpenditures += expenditure?.numericTotal ?? 0;
      });

      /// Loop through earnings
      earnings
          // Select earnings that are between intervalStart and intervalEnd
          .where((earning) =>
              (earning?.earningDate.isBefore(intervalEnd) ?? false) &&
              (earning?.earningDate.isAfter(intervalStart) ?? false))
          // For each selected, add their total to the earning total
          .forEach((earning) {
        currentEarnings += earning?.amount ?? 0;
      });

      total = currentEarnings - currentExpenditures;

      return total;
    }, interval: interval)
        .then((incomingData) {
      return incomingData.cast<double>();
    });
  }

  /// Get data within an interval of time by specifying a start and end date,
  /// a DataInterval (how often the data should be queried within those bounds),
  /// as well as a function to
  Future<List<dynamic>> _getDataByInterval(
      DateTime start, DateTime end, Function search,
      {DataInterval interval = DataInterval.monthly}) async {
    // List of data to be returned
    List<dynamic> data = [];

    // The number of days between each interval
    int dayInterval = _setIntervalDays(interval);

    // Controls the window that the expenditures and earnings are searched with
    DateTime intervalStart = start;
    DateTime intervalEnd = start.add(Duration(days: dayInterval));

    // Ensures that the earnings and expenditures are looped through at least once
    bool firstLoop = true;

    // Loop through until the startingInterval is after the end of the selected
    // window of time to search through
    while (intervalStart.isBefore(end) || firstLoop) {
      var result = search(intervalStart, intervalEnd);

      data.add(result);

      intervalStart = intervalStart.add(Duration(days: dayInterval));
      intervalEnd = intervalEnd.add(Duration(days: dayInterval));
      firstLoop = false;
    }

    print(data);
    return data;
  }

  /// Takes a DataInterval enum and returns the corresponding number of days
  /// within that interval. The options are weekly, bi-weekly (every 2 weeks),
  /// monthly, bi-yearly (every 6 months), yearly, and yearToDate (which counts
  /// as monthly as far as the number of days within that interval)
  int _setIntervalDays(DataInterval interval) {
    if (interval == DataInterval.weekly) {
      return 7;
    } else if (interval == DataInterval.biWeekly) {
      return 14;
    } else if (interval == DataInterval.biYearly) {
      return 181;
    } else if (interval == DataInterval.yearly) {
      return 365;
    } else {
      // Monthly interval is default, also used for Year-to-date
      return 32;
    }
  }

  /// Returns the name of a DataInterval
  static String getIntervalName (DataInterval interval) {
    switch (interval) {
      case DataInterval.weekly:
        return "Week";
      case DataInterval.biWeekly:
        return "Two Weeks";
      case DataInterval.monthly:
        return "Month";
      case DataInterval.biYearly:
        return "6 Months";
      case DataInterval.yearly:
        return "Year";
      case DataInterval.yearToDate:
        return "Year to Date";
    }
    return "Error";
  }
}
