import 'package:flutter/material.dart';
import 'package:if_then_app/views/account_page/login_page.dart';
import 'package:if_then_app/views/account_page/signup_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('If-Then'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              child: Text('アカウント作成'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                );
              },
            ),
            ElevatedButton(
              child: Text('ログイン'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
