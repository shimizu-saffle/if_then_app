import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:if_then_app/controllers/fcm_controller.dart';

class FcmTestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FcmController fcm = FcmController();
    final fcmText = fcm.setRequestPermission();
    return Consumer(builder: (context, watch, child) {
      // final fcmController = watch(FcmProvider);
      return Scaffold(
        appBar: AppBar(
          title: Text('テスト'),
        ),
        body: Text(fcmText),
      );
    });
  }
}
