import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final FcmProvider = ChangeNotifierProvider<FcmController>(
  (ref) => FcmController(),
);

class FcmController extends ChangeNotifier {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings? settings;

  setRequestPermission() async {
    final settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    return print('User granted permission: ${settings.authorizationStatus}');
  }

  foregroundMessagesSettings() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }

  getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print(token);
  }

  final AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.max,
  );
}
