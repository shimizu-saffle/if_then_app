import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:if_then_app/controllers/login_controller.dart';

class MailInputField extends StatelessWidget {
  const MailInputField({
    Key? key,
    required this.icon,
    required this.hint,
    this.inputType,
    this.inputAction,
  }) : super(key: key);

  final IconData? icon;
  final String? hint;
  final TextInputType? inputType;
  final TextInputAction? inputAction;

  @override
  Widget build(BuildContext context) {
    final mailController = TextEditingController();
    Size size = MediaQuery.of(context).size;
    return Consumer(builder: (context, watch, child) {
      final logInController = watch(LogInProvider);
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Container(
          height: size.height * 0.08,
          width: size.width * 0.8,
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.7),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  child: Icon(
                    icon,
                    size: 28,
                    color: Colors.white,
                  ),
                ),
                hintText: hint,
                hintStyle: TextStyle(color: Colors.white),
              ),
              style: TextStyle(color: Colors.white),
              keyboardType: inputType,
              textInputAction: inputAction,
              controller: mailController,
              onChanged: (text) {
                logInController.mail = text;
              },
            ),
          ),
        ),
      );
    });
  }
}
