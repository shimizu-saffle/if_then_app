import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:if_then_app/controllers/login_controller.dart';
import 'package:if_then_app/views/timelinepage.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({Key? key, required this.buttonName}) : super(key: key);

  final String? buttonName;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer(builder: (context, watch, child) {
      final logInController = watch(LogInProvider);
      return Container(
        height: size.height * 0.08,
        width: size.width * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.blue,
        ),
        child: TextButton(
          onPressed: () async {
            try {
              await logInController.login();
              successfulDialog(context, 'おかえりなさい\u{1F61A}');
            } catch (e) {
              failedDialog(context, e.toString());
            }
          },
          child: Text(
            buttonName!,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    });
  }

  Future successfulDialog(
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
              child: Text('ただいま\u{1F44B}'),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TimeLinePage(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future failedDialog(
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
