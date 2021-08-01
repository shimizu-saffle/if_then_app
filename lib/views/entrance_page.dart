import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:if_then_app/controllers/pallete.dart';
import 'package:if_then_app/widgets/password-input.dart';
import 'package:if_then_app/widgets/rounded-button.dart';
import 'package:if_then_app/widgets/text-input.dart';

class EntrancePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                  child: Text(
                    'パスワードを忘れた方はこちら',
                    style: bBodyText,
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
          Container(
            child: Text(
              '初めての方はこちら',
              style: bBodyText,
            ),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 1, color: kBlue))),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
