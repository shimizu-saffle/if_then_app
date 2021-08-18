import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:if_then_app/controllers/fcm_controller.dart';
import 'package:if_then_app/views/account_page/signup_page.dart';
import 'package:if_then_app/views/account_page/login_page.dart';
import 'package:if_then_app/views/fcm_test.dart';
import 'package:if_then_app/views/forgot-password.dart';
import 'package:if_then_app/views/timelinepage.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
  print(message.data);
  flutterLocalNotificationsPlugin.show(
      message.data.hashCode,
      message.data['title'],
      message.data['body'],
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channel.description,
        ),
      ));
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FcmController fcmSettings = FcmController();
  fcmSettings.setRequestPermission();
  fcmSettings.foregroundMessagesSettings();
  fcmSettings.printToken();
  await fcmSettings.initAndroidNotification();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'If-Then',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        'ForgotPassword': (context) => ForgotPassword(),
        'SignUpPage': (context) => SignUpPage(),
        'FcmTestScreen': (context) => FcmTestScreen(),
        'TimeLinePage': (context) => TimeLinePage(),
      },
    );
  }
}
