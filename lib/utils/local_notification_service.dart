import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initialize(BuildContext context) async {
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/ic_launcher"));

    await _notificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> display(RemoteMessage message) async {
    try {
      const NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
        "guciano",
        "guciano channel",
        channelDescription: "this is our channel",
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
      ));

      await _notificationsPlugin.show(
        0,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
      );
    } on Exception catch (e) {
      print(e);
    }
  }
}
