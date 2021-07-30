import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:if_then_app/controllers/signup_controller.dart';
import 'package:if_then_app/views/timeline.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('ログイン'),
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
                  onChanged: (text) {
                    signUpController.password = text;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await signUpController.signUp();
                    } catch (e) {
                      _showDialog(context, e.toString());
                    }
                  },
                  child: Text('登録する'),
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
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TimeLinePage()),
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
