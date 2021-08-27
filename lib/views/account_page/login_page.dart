import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:if_then_app/models/pallete.dart';
import 'package:if_then_app/widgets/GoogleLoginButton.dart';
import 'package:if_then_app/widgets/login_button.dart';
import 'package:if_then_app/widgets/password-input.dart';
import 'package:if_then_app/widgets/mail-input.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 40),
          Flexible(
            child: Center(
              child: Text(
                'イフゼン',
                style: GoogleFonts.pottaOne(
                  textStyle: TextStyle(
                    color: Colors.blue,
                    fontSize: 60,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              MailInputField(
                icon: FontAwesomeIcons.envelope,
                hint: '',
                inputType: TextInputType.emailAddress,
                inputAction: TextInputAction.next,
              ),
              PasswordInputField(
                icon: FontAwesomeIcons.lock,
                hint: '',
                inputType: TextInputType.emailAddress,
                inputAction: TextInputAction.done,
              ),
              SizedBox(
                height: 10,
              ),
              LoginButton(buttonName: 'ログイン'),
              SizedBox(height: 25),
              GoogleLoginButton(
                buttonName: 'Googleアカウントでログイン',
                icon: FontAwesomeIcons.google,
              ),
              SizedBox(height: 25),
            ],
          ),
          SizedBox(
            height: 20,
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
            height: 30,
          ),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'ForgotPassword'),
            child: Container(
              child: Text(
                'パスワードを忘れた方はこちら\u{1F481}',
                style: bBodyText,
              ),
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(width: 1, color: kBlue))),
            ),
          ),
          SizedBox(
            height: 45,
          ),
        ],
      ),
    );
  }
}
