import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
            inputAction: TextInputAction.next,
          ),
        ],
      ),
    );
  }
}

class PasswordInput extends StatelessWidget {
  const PasswordInput({
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
    Size size = MediaQuery.of(context).size;
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
            obscureText: true,
            style: TextStyle(color: Colors.white),
            keyboardType: inputType,
            textInputAction: inputAction,
          ),
        ),
      ),
    );
  }
}

class TextInputField extends StatelessWidget {
  const TextInputField({
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
    Size size = MediaQuery.of(context).size;
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
          ),
        ),
      ),
    );
  }
}
