import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final SignUpProvider = ChangeNotifierProvider<SignUpController>(
  (ref) => SignUpController(),
);

class SignUpController extends ChangeNotifier {
  String mail = '';
  String password = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //サインアップ時にFCMトークンを取得して保存できるメソッド
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
    final userId = user.uid;

    FirebaseFirestore.instance.collection('users').doc(userId).set(
      {
        'userId': userId,
        'email': email,
        'createdAt': Timestamp.now(),
      },
    );

    //端末のFCMトークン
    String? token = await FirebaseMessaging.instance.getToken();

    Future<void> saveTokenToDatabase(String token) async {
      // この例では、ユーザーがログインしていると仮定します。

      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'tokens': FieldValue.arrayUnion([token]),
      });
    }

    // 初期トークンのデータベースへの保存
    await saveTokenToDatabase(token!);

    // トークンが更新されるたびに、これもデータベースに保存します。
    FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
  }
}
