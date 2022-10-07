import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../main.dart';

final fcmProvider = ChangeNotifierProvider<FcmController>(
  (ref) => FcmController(),
);

class FcmController extends ChangeNotifier {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings? settings;

  Future<void> setRequestPermission() async {
    final settings = await messaging.requestPermission();

    return print('User granted permission: ${settings.authorizationStatus}');
  }

  Future<void> iOSForegroundMessagesSettings() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }

  Future<void> printToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    print(token);
  }

  Future<void> getSetToken() async {
    final token = await FirebaseMessaging.instance.getToken();

    Future<void> saveTokenToDatabase(String token) async {
      final userId = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'tokens': FieldValue.arrayUnion([token]),
      });
    }

    await saveTokenToDatabase(token!);

    FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
  }

  Future<void> foregroundAndroidNotification() async {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        final notification = message.notification;
        final android = message.notification?.android;
        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                // channel.description, ※1
                icon: android.smallIcon,
              ),
            ),
          );
        }
      },
    );
    notifyListeners();
  }
}
