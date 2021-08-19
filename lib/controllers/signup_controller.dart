import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final SignUpProvider = ChangeNotifierProvider<SignUpController>(
  (ref) => SignUpController(),
);

class SignUpController extends ChangeNotifier {
  String mail = '';
  String password = '';
  String userId = FirebaseAuth.instance.currentUser!.uid;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signUp() async {
    if (mail.isEmpty) {
      throw ('メールアドレスを入力してください');
    }

    if (password.isEmpty) {
      throw ('パスワードを入力してください');
    }

    // todo
    final User? user = (await _auth.createUserWithEmailAndPassword(
      email: mail,
      password: password,
    ))
        .user;
    final email = user!.email;

    FirebaseFirestore.instance.collection('users').doc(userId).set(
      {
        'userId': userId,
        'email': email,
        'createdAt': Timestamp.now(),
      },
    );
  }
}
