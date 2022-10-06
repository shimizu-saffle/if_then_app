import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:if_then_app/controllers/login_controller.dart';
import 'package:sign_button/sign_button.dart';

class LoginPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 70),
          Flexible(
            child: Center(
              child: Text(
                'イフゼン',
                style: GoogleFonts.yuseiMagic(
                  textStyle: TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 60,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
          Consumer(builder: (context, watch, child) {
            final googleLogInController = ref.watch(GoogleLogInProvider);
            final appleLogInController = ref.watch(AppleLogInProvider);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 25),
                Platform.isAndroid
                    ? SizedBox(height: 0)
                    : SignInButton(
                        buttonType: ButtonType.apple,
                        buttonSize: ButtonSize.small,
                        onPressed: () async {
                          EasyLoading.show(status: 'ようこそ \u{1F450}');
                          try {
                            await appleLogInController.loginUserWithApple();
                            Navigator.pushNamed(context, 'RootPage');
                          } catch (e) {
                            debugPrint('error');
                          }
                          await EasyLoading.dismiss();
                        },
                      ),
                SizedBox(height: 25),
                SignInButton(
                  buttonType: ButtonType.google,
                  buttonSize: ButtonSize.small,
                  onPressed: () async {
                    EasyLoading.show(status: 'ようこそ \u{1F450}');
                    await googleLogInController.loginUserWithGoogle();
                    if (FirebaseAuth.instance.currentUser?.uid != null) {
                      Navigator.pushNamed(context, 'RootPage');
                    }
                    await EasyLoading.dismiss();
                  },
                ),
                SizedBox(
                  height: 150,
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
