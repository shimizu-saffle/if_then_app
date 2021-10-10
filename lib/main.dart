import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:if_then_app/controllers/fcm_controller.dart';
import 'package:if_then_app/views/login_page.dart';
import 'package:if_then_app/views/gacha_page/present_page.dart';
import 'package:if_then_app/views/my_ifthen_list_page.dart';

import 'package:if_then_app/views/root_page.dart';
import 'package:if_then_app/views/timeline_page.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
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
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await Firebase.initializeApp();
  FcmController fcmSettings = FcmController();
  fcmSettings.setRequestPermission();
  fcmSettings.iOSForegroundMessagesSettings();
  if (Platform.isAndroid) {
    await fcmSettings.foregroundAndroidNotification();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

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
      debugShowCheckedModeBanner: true,
      title: 'イフゼン',
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.deepOrange,
              ),
            );
          }
          if (snapshot.hasData) {
            return RootPage();
          }
          return LoginPage();
        },
      ),
      routes: {
        'LoginPage': (context) => LoginPage(),
        'RootPage': (context) => RootPage(),
        'TimeLinePage': (context) => TimeLinePage(),
        'MyIfThenListPage': (context) => MyIfThenListPage(),
        'PresentPage': (context) => PresentPage(),
      },
      theme: ThemeData(
          textTheme: GoogleFonts.notoSansTextTheme(),
          primaryColor: Colors.deepOrange,
          primarySwatch: Colors.deepOrange,
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: <TargetPlatform, PageTransitionsBuilder>{
              TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
            },
          )),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepOrange,
      ),
      themeMode: ThemeMode.system,
      builder: EasyLoading.init(),
    );
  }
}
// issueとプルリクを関連付けるテスト