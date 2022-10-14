import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../models/usermodel.dart';

final logOutProvider = ChangeNotifierProvider<LogOutController>(
  (ref) => LogOutController(),
);

final googleLogInProvider = ChangeNotifierProvider<GoogleSignInController>(
  (ref) => GoogleSignInController(),
);

final appleLogInProvider = ChangeNotifierProvider<AppleSignInController>(
  (ref) => AppleSignInController(),
);

class LogOutController extends ChangeNotifier {
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }
}

class GoogleSignInController with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<String> createUser(UserModel user) async {
    var retVal = 'error';

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.userId)
          .set({
        'createdAt': Timestamp.now(),
        'email': user.email,
        'tokens': user.tokens,
        'userId': user.userId,
      });
      retVal = 'success';
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> loginUserWithGoogle() async {
    var retVal = 'error';

    try {
      final googleUser = await GoogleSignIn().signIn();
      final googleAuth = await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final authResult = await _auth.signInWithCredential(credential);

      final token = await _fcm.getToken();

      if (authResult.additionalUserInfo!.isNewUser) {
        final user = UserModel(
          userId: authResult.user!.uid,
          email: authResult.user!.email,
          createdAt: Timestamp.now(),
          tokens: await _fcm.getToken(),
        );
        final returnString = await createUser(user);
        if (returnString == 'success') {
          retVal = 'success';
        }
      } else {
        Future<void> saveTokenToDatabase(String token) async {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(authResult.user!.uid)
              .update({
            'tokens': FieldValue.arrayUnion([token]),
          });
        }

        await saveTokenToDatabase(token!);

        FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
      }
      retVal = 'success';
    } on PlatformException catch (e) {
      retVal = e.message!;
    } catch (e) {
      print(e);
    }

    return retVal;
  }
}

class AppleSignInController with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<String> createUser(UserModel user) async {
    var retVal = 'error';

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.userId)
          .set({
        'createdAt': Timestamp.now(),
        'email': user.email,
        'tokens': user.tokens,
        'userId': user.userId,
      });
      retVal = 'success';
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> loginUserWithApple() async {
    var retVal = 'error';

    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    final oauthCredential = OAuthProvider('apple.com').credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    try {
      final authResult = await _auth.signInWithCredential(oauthCredential);

      final token = await _fcm.getToken();

      if (authResult.additionalUserInfo!.isNewUser) {
        final user = UserModel(
          userId: authResult.user!.uid,
          email: authResult.user!.email,
          createdAt: Timestamp.now(),
          tokens: await _fcm.getToken(),
        );
        final returnString = await createUser(user);
        if (returnString == 'success') {
          retVal = 'success';
        }
      } else {
        Future<void> saveTokenToDatabase(String token) async {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(authResult.user!.uid)
              .update({
            'tokens': FieldValue.arrayUnion([token]),
          });
        }

        await saveTokenToDatabase(token!);

        FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
      }
      retVal = 'success';
    } on PlatformException catch (e) {
      retVal = e.message!;
    } catch (e) {
      print(e);
    }

    return retVal;
  }
}
