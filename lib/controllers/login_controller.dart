import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:if_then_app/models/userModel.dart';

final LogInProvider = ChangeNotifierProvider<LogInController>(
  (ref) => LogInController(),
);

final GoogleLogInProvider = ChangeNotifierProvider<GoogleSignInController>(
  (ref) => GoogleSignInController(),
);

class LogInController extends ChangeNotifier {
  String mail = '';
  String password = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future login() async {
    if (mail.isEmpty) {
      throw ('メールアドレスを入力してください');
    }

    if (password.isEmpty) {
      throw ('パスワードを入力してください');
    }

    // todo
    final result = await _auth.signInWithEmailAndPassword(
      email: mail,
      password: password,
    );
    final userId = result.user!.uid;

    String? token = await FirebaseMessaging.instance.getToken();

    Future<void> saveTokenToDatabase(String token) async {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'tokens': FieldValue.arrayUnion([token]),
      });
    }

    // 初期トークンのデータベースへの保存
    await saveTokenToDatabase(token!);

    // トークンが更新されるたびに、これもデータベースに保存します。
    FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
  }

  //Googleアカウントのログアウトができた。メールログインの状態でこのメソッド呼んだらエラー出ちゃうかも
  Future logout() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }
}

class GoogleSignInController with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<UserCredential> signInWithGoogle() async {
    // 認証フローのトリガー
    final googleUser = await GoogleSignIn().signIn();

    // リクエストから認証の詳細を取得する
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // 新しいクレデンシャルの作成
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // サインインしたら、UserCredentialを返します。
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<String> createUser(UserModel user) async {
    String retVal = "error";

    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.userId)
          .set({
        'createdAt': Timestamp.now(),
        'email': user.email,
        'tokens': user.tokens,
        'userId': user.userId,
      });
      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> loginUserWithGoogle() async {
    String retVal = "error";

    try {
      final _googleUser = await GoogleSignIn().signIn();
      GoogleSignInAuthentication _googleAuth =
          await _googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: _googleAuth.idToken, accessToken: _googleAuth.accessToken);

      UserCredential _authResult = await _auth.signInWithCredential(credential);

      String? token = await _fcm.getToken();

      if (_authResult.additionalUserInfo!.isNewUser) {
        UserModel _user = UserModel(
          userId: _authResult.user!.uid,
          email: _authResult.user!.email,
          createdAt: Timestamp.now(),
          tokens: await _fcm.getToken(),
        );
        String _returnString = await createUser(_user);
        if (_returnString == "success") {
          retVal = "success";
        }
      } else {
        // 取得してないトークンを取得して保存する処理
        // 最初にこのif,else文のifの処理でログインした状態で別デバイスでログインすると
        // 最初に取得したデバイスのトークンが上書きされてしまう
        Future<void> saveTokenToDatabase(String token) async {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(_authResult.user!.uid)
              .update({
            'tokens': FieldValue.arrayUnion([token]),
          });
        }

        // 初期トークンをデータベースへ保存
        await saveTokenToDatabase(token!);

        // トークンが更新されるたびに、これもデータベースに保存します。
        FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
      }
      retVal = "success";
    } on PlatformException catch (e) {
      retVal = e.message!;
    } catch (e) {
      print(e);
    }

    return retVal;
  }
}
