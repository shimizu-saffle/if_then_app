import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:if_then_app/controllers/login_controller.dart';
import 'package:sign_button/sign_button.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            final googleLogInController = watch(GoogleLogInProvider);
            final appleLogInController = watch(AppleLogInProvider);
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
                          try {
                            await appleLogInController.loginUserWithApple();
                            Navigator.pushNamed(context, 'RootPage');
                          } catch (e) {}
                        },
                      ),
                SizedBox(height: 25),
                SignInButton(
                  buttonType: ButtonType.google,
                  buttonSize: ButtonSize.small,
                  onPressed: () async {
                    try {
                      await googleLogInController.loginUserWithGoogle();
                      Navigator.pushNamed(context, 'RootPage');
                    } catch (e) {
                      Navigator.pushNamed(context, 'LoginPage');
                    }
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
