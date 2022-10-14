import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sign_button/sign_button.dart';

import '../controllers/login_controller.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 70),
          Flexible(
            child: Center(
              child: Text(
                'イフゼン',
                style: GoogleFonts.yuseiMagic(
                  textStyle: const TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 60,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
          Consumer(
            builder: (context, watch, child) {
              final googleLogInController = ref.watch(googleLogInProvider);
              final appleLogInController = ref.watch(appleLogInProvider);
              return Column(
                children: [
                  const SizedBox(height: 25),
                  Platform.isAndroid
                      ? const SizedBox(height: 0)
                      : SignInButton(
                          buttonType: ButtonType.apple,
                          onPressed: () async {
                            await EasyLoading.show(status: 'ようこそ \u{1F450}!!!');
                            try {
                              await appleLogInController
                                  .loginUserWithApple()
                                  .then((_) {
                                EasyLoading.dismiss();
                                Navigator.pushNamed(context, 'RootPage');
                              });
                            } on Exception catch (e) {
                              debugPrint('debug : $e');
                            }
                          },
                        ),
                  const SizedBox(height: 25),
                  SignInButton(
                    buttonType: ButtonType.google,
                    onPressed: () async {
                      await EasyLoading.show(status: 'ようこそ \u{1F450}');
                      await googleLogInController.loginUserWithGoogle().then(
                        (_) {
                          EasyLoading.dismiss();
                          Navigator.pushNamed(context, 'RootPage');
                        },
                      );
                    },
                  ),
                  const SizedBox(
                    height: 150,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
