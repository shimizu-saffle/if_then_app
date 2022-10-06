import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:if_then_app/models/count.dart';

final randomProvider = ChangeNotifierProvider<RandomIfThenController>(
    (ref) => RandomIfThenController()
      ..checkTodayTurnGachaTimes()
      ..getRandomIfThen());

class RandomIfThenController extends ChangeNotifier {
  String? randomIfText;
  String? randomThenText;
  List<String> initFavoriteUserId = [];
  late bool canTurn;

  void getRandomIfThen() async {
    final DocumentReference<Map<String, dynamic>> countRef =
        FirebaseFirestore.instance.collection('settings').doc('count');

    final countSnapshot = await countRef.get();
    final count = Count(countSnapshot);
    final randomRange = count.total;

    int randomSerialNumber1 = Random().nextInt(randomRange!) + 1;
    int randomSerialNumber2 = Random().nextInt(randomRange) + 1;

    final ifSnapshots = await FirebaseFirestore.instance
        .collection('itList')
        .where('serialNumber', isEqualTo: randomSerialNumber1)
        .get();

    final thenSnapshots = await FirebaseFirestore.instance
        .collection('itList')
        .where('serialNumber', isEqualTo: randomSerialNumber2)
        .get();

    randomIfText = await ifSnapshots.docs[0].data()['ifText'];
    randomThenText = await thenSnapshots.docs[0].data()['thenText'];
  }

  Future addRandomToMyIfThen() async {
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    final itList = FirebaseFirestore.instance.collection('itList');
    final DocumentReference<Map<String, dynamic>> countRef =
        FirebaseFirestore.instance.collection('settings').doc('count');

    countRef.update({
      'total': FieldValue.increment(1),
    });

    final countSnapshot = await countRef.get();
    final count = Count(countSnapshot);
    final total = count.total;

    await itList.add({
      'ifText': randomIfText,
      'thenText': randomThenText,
      'createdAt': Timestamp.now(),
      'userId': userId,
      'favoriteUserId': initFavoriteUserId,
      'serialNumber': total
    });
  }

  Future<void> countTurningGacha() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'turnGacha': FieldValue.arrayUnion([Timestamp.now()]),
    });
  }

  Future checkTodayTurnGachaTimes() async {
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    final DocumentSnapshot<Map<String, dynamic>> userDocument =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    final List<dynamic> list = await userDocument.data()!['turnGacha'] ?? [];

    final turnGacha = list.map((e) => (e as Timestamp).toDate()).toList();

    if (turnGacha.length > 6) {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'turnGacha': FieldValue.arrayRemove([]),
      });
    }

    canTurn = turnGacha
            .where((e) =>
                e.day == DateTime.now().day &&
                e.year == DateTime.now().year &&
                e.month == DateTime.now().month)
            .length <
        5;
    notifyListeners();
  }
}
