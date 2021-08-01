import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:if_then_app/controllers/login_controller.dart';
import 'package:if_then_app/controllers/pallete.dart';
import 'package:if_then_app/widgets/password-input.dart';
import 'package:if_then_app/widgets/rounded-button.dart';
import 'package:if_then_app/widgets/text-input.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      body: Consumer(builder: (context, watch, child) {
        final logInController = watch(LogInProvider);
        return Column(
          children: [
            Flexible(
              child: Center(
                child: Text(
                  'If-Then',
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 60,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextInputField(
                  icon: FontAwesomeIcons.envelope,
                  hint: 'メールアドレス',
                  inputType: TextInputType.emailAddress,
                  inputAction: TextInputAction.next,
                ),
                PasswordInput(
                  icon: FontAwesomeIcons.lock,
                  hint: 'パスワード',
                  inputType: TextInputType.emailAddress,
                  inputAction: TextInputAction.done,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, 'ForgotPassword'),
                    child: Container(
                      child: Text(
                        'パスワードを忘れた方はこちら\u{1F481}',
                        style: bBodyText,
                      ),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(width: 1, color: kBlue))),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                RoundedButton(buttonName: 'ログイン'),
                SizedBox(height: 25),
              ],
            ),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, 'SignUpPage'),
              child: Container(
                child: Text(
                  '初めての方はこちら\u{1F481}',
                  style: bBodyText,
                ),
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(width: 1, color: kBlue))),
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        );
      }),
    );
  }
}
