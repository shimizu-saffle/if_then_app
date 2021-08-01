import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:if_then_app/controllers/pallete.dart';
import 'package:if_then_app/widgets/text-input.dart';

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
        title: Text(
          'Forgot Password',
          style: wBodyText,
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  width: size.width * 0.8,
                  child: Text(
                    'パスワード再設定の手順をご案内する\nメールをお送りします',
                    style: bBodyText,
                  ),
                ),
                TextInputField(icon: FontAwesomeIcons.envelope, hint: 'メールアドレス')
              ],
            ),
          ),
        ],
      ),
    );
  }
}
