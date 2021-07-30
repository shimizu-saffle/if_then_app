import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:if_then_app/controllers/signup_controller.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('アカウント作成'),
      ),
      body: Consumer(
        builder: (context, watch, child) {
          final signUpController = watch(SignUpProvider);
          return Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                TextField(
                  controller: mailController,
                  decoration: InputDecoration(hintText: "メールアドレス"),
                  onChanged: (text) {
                    signUpController.mail = text;
                  },
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(hintText: "パスワード"),
                  obscureText: true,
                  onChanged: (text) {
                    signUpController.password = text;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  child: Text('登録する'),
                  onPressed: () async {
                    try {
                      await signUpController.signUp();
                      _showDialog(context, '登録完了しました');
                    } catch (e) {
                      _showDialog(context, e.toString());
                    }
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Future _showDialog(
    BuildContext context,
    String title,
  ) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          actions: <Widget>[
            ElevatedButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
