import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:if_then_app/models/userModel.dart';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

final LogInProvider = ChangeNotifierProvider<LogInController>(
  (ref) => LogInController(),
);

final GoogleLogInProvider = ChangeNotifierProvider<GoogleSignInController>(
  (ref) => GoogleSignInController(),
);

final AppleLogInProvider = ChangeNotifierProvider<AppleSignInController>(
  (ref) => AppleSignInController(),
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

class AppleSignInController with ChangeNotifier {
  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<UserCredential> signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
    return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }
}
