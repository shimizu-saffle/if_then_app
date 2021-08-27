import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:if_then_app/controllers/login_controller.dart';

class GoogleLoginButton extends StatelessWidget {
  const GoogleLoginButton({
    Key? key,
    required this.buttonName,
    this.icon,
  }) : super(key: key);

  final String? buttonName;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer(builder: (context, watch, child) {
      final logInController = watch(GoogleLogInProvider);
      return Container(
        height: size.height * 0.08,
        width: size.width * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.blue,
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: TextButton.icon(
            onPressed: () async {
              await logInController.loginUserWithGoogle();
              Navigator.pushNamed(context, 'RootPage');
            },
            icon: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Icon(
                icon,
                size: 28,
                color: Colors.white,
              ),
            ),
            label: Text(
              buttonName!,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    });
  }
}
