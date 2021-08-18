import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:if_then_app/controllers/fcm_controller.dart';
import 'package:if_then_app/views/account_page/signup_page.dart';
import 'package:if_then_app/views/account_page/login_page.dart';
import 'package:if_then_app/views/fcm_test.dart';
import 'package:if_then_app/views/forgot-password.dart';
import 'package:if_then_app/views/timelinepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FcmController fcmSettings = FcmController();
  fcmSettings.setRequestPermission();
  fcmSettings.foregroundMessagesSettings();
  fcmSettings.getToken();
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
