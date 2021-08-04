import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final FcmProvider = ChangeNotifierProvider<FcmController>(
  (ref) => FcmController(),
);

class FcmController extends ChangeNotifier {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
}
