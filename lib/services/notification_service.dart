import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(android: android);

    await notificationsPlugin.initialize(settings);
  }

  static Future<void> scheduleNotification({
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    await notificationsPlugin.zonedSchedule(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'note_channel',
          'Notes Reminder',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}


// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

// class NotificationService {
//   static final FlutterLocalNotificationsPlugin _notifications =
//       FlutterLocalNotificationsPlugin();

//   static Future init() async {
//     tz.initializeTimeZones();

//     const android = AndroidInitializationSettings('@mipmap/ic_launcher');

//     const settings = InitializationSettings(android: android);

//     await _notifications.initialize(settings);
//   }

//   // ⏰ Tambahin fungsi schedule
//   static Future scheduleNotification({
//     required String title,
//     required String body,
//     required DateTime scheduledTime,
//   }) async {
//     await _notifications.zonedSchedule(
//       0,
//       title,
//       body,
//       tz.TZDateTime.from(scheduledTime, tz.local),
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'channel_id',
//           'reminder',
//           importance: Importance.max,
//           priority: Priority.high,
//         ),
//       ),
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//     );
//   }

//   static Future showNotification({
//     required String title,
//     required String body,
//   }) async {
//     const androidDetails = AndroidNotificationDetails(
//       'channel_id',
//       'reminder',
//       importance: Importance.max,
//       priority: Priority.high,
//     );

//     const details = NotificationDetails(android: androidDetails);

//     await _notifications.show(
//       0,
//       title,
//       body,
//       details,
//     );
//   }
// }
