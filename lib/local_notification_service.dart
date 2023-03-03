import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService extends ChangeNotifier {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static init() {
    InitializationSettings initializationSettings =
    const InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/ic_launcher"));
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

   static displayNotification(RemoteMessage message) {
      NotificationDetails notificationDetails = const NotificationDetails(
          android: AndroidNotificationDetails(
              "push_notification", "push_notification_channel",
              priority: Priority.high));

      final int id = DateTime.now().microsecondsSinceEpoch.toSigned(5);
      _flutterLocalNotificationsPlugin.show(
          id,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails,
          payload: message.data['_id']);
    }
}
