import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:if_then_app/controllers/login_controller.dart';
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
          final logInController = watch(LogInProvider);
          return Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                TextField(
                  controller: mailController,
                  decoration: InputDecoration(hintText: "メールアドレス"),
                  onChanged: (text) {
                    logInController.mail = text;
                  },
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(hintText: "パスワード"),
                  obscureText: true,
                  onChanged: (text) {
                    logInController.password = text;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  child: Text('ログイン'),
                  onPressed: () async {
                    try {
                      await logInController.login();
                      _showDialog(context, 'ログインしました');
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TimeLinePage(),
                        ),
                      );
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
