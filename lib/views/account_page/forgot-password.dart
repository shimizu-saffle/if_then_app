import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:if_then_app/controllers/pallete.dart';
import 'package:if_then_app/widgets/login_button.dart';
import 'package:if_then_app/widgets/mail-input.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
          color: kWhite,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Center(
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.1,
                ),
                Container(
                  width: size.width * 0.8,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Text(
                      'パスワード再設定の手順をご案内する\nメールをお送りします',
                      style: bBodyText,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                MailInputField(
                  icon: FontAwesomeIcons.envelope,
                  hint: 'メールアドレス',
                  inputType: TextInputType.emailAddress,
                  inputAction: TextInputAction.done,
                ),
                SizedBox(
                  height: 20,
                ),
                LoginButton(buttonName: 'Send'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
