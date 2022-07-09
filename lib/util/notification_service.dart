import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

import '../model/event_model.dart';

class NotificationService {
  static final NotificationService _notificationService = NotificationService
      ._internal();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('lib/res/icon/icon512 - android.png');

    const IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false);

    const InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: null);

    tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  Future selectNotification(String? payload) async {
    //Handle notification tapped logic here
  }

  Future<void> _scheduleNotification(Event event, DateTime dateTime) async {
    final timeZone = _TimeZone();
    final timeZoneName = await timeZone.getTimeZoneName();
    final location = await timeZone.getLocation(timeZoneName);

    final scheduledDate = tz.TZDateTime.from(dateTime, location);

    await flutterLocalNotificationsPlugin.zonedSchedule(
        event.key, event.name, event.description, scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            "VilladexChannel",
            "Villadex",
            ""
          ),
          iOS: IOSNotificationDetails(),),
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation
            .wallClockTime,
        androidAllowWhileIdle: false)
  }
}

/// Finds the local time zone. Can return the name as a string or the location
/// as a tz.Location object.
/// https://stackoverflow.com/questions/64305469/how-to-convert-datetime-to-tzdatetime-in-flutter
class _TimeZone {
  factory _TimeZone() => _this ?? _TimeZone._();

  _TimeZone._() {
    tz.initializeTimeZones();
  }

  static _TimeZone? _this;

  Future<String> getTimeZoneName() async =>
      FlutterNativeTimezone.getLocalTimezone();

  Future<tz.Location> getLocation(String? timeZoneName) async {
    if (timeZoneName == null || timeZoneName.isEmpty) {
      timeZoneName = await getTimeZoneName();
    }

    return tz.getLocation(timeZoneName);
  }
}