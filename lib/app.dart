import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';

import 'views/gacha_page/present_page.dart';
import 'views/login_page.dart';
import 'views/my_if_then_list_page.dart';
import 'views/root_page.dart';
import 'views/time_line_page.dart';

class App extends StatelessWidget {
  App({super.key});

  final currentUserInfo = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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

          ///これでリビルドした際もログイン状態を保持できるのではないのか説を提唱したい
          if (snapshot.hasData && currentUserInfo != null) {
            return RootPage();
          } else if (currentUserInfo == null) {
            return const LoginPage();
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
      routes: {
        'LoginPage': (context) => const LoginPage(),
        'RootPage': (context) => RootPage(),
        'TimeLinePage': (context) => const TimeLinePage(),
        'MyIfThenListPage': (context) => const MyIfThenListPage(),
        'PresentPage': (context) => const PresentPage(),
      },
      theme: ThemeData(
        textTheme: GoogleFonts.notoSansTextTheme(),
        primaryColor: Colors.deepOrange,
        primarySwatch: Colors.deepOrange,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
          },
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepOrange,
      ),
      builder: EasyLoading.init(),
    );
  }
}
