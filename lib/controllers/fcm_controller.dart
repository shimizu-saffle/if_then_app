import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final FcmProvider = ChangeNotifierProvider<FcmController>(
  (ref) => FcmController(),
);

class FcmController extends ChangeNotifier {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings? settings;

  allowNotifications() async {
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
}
