import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:if_then_app/views/account_page/signup_page.dart';
import 'package:if_then_app/views/entrance_page.dart';
import 'package:if_then_app/views/forgot-password.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        '/': (context) => EntrancePage(),
        'ForgotPassword': (context) => ForgotPassword(),
        'SignUpPage': (context) => SignUpPage(),
      },
    );
  }
}
