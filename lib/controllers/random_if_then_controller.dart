import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/count.dart';

final randomProvider = ChangeNotifierProvider<RandomIfThenController>(
  (ref) => RandomIfThenController()
    ..checkTodayTurnGachaTimes()
    ..getRandomIfThen(),
);

class RandomIfThenController extends ChangeNotifier {
  String? randomIfText;
  String? randomThenText;
  List<String> initFavoriteUserId = [];
  late bool canTurn;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> getRandomIfThen() async {
    final countRef = _firestore.collection('settings').doc('count');

    final countSnapshot = await countRef.get();
    final count = Count(countSnapshot);
    final randomRange = count.total;

    final randomSerialNumber1 = Random().nextInt(randomRange!) + 1;
    final randomSerialNumber2 = Random().nextInt(randomRange) + 1;

    final ifSnapshots = await _firestore
        .collection('itList')
        .where('serialNumber', isEqualTo: randomSerialNumber1)
        .get();

    final thenSnapshots = await _firestore
        .collection('itList')
        .where('serialNumber', isEqualTo: randomSerialNumber2)
        .get();

    randomIfText = await ifSnapshots.docs[0].data()['ifText'];
    randomThenText = await thenSnapshots.docs[0].data()['thenText'];
  }

  Future<void> addRandomToMyIfThen() async {
    final userId = _auth.currentUser!.uid;
    final itList = _firestore.collection('itList');
    final countRef = _firestore.collection('settings').doc('count');

    await countRef.update({
      'total': FieldValue.increment(1),
    });

    final countSnapshot = await countRef.get();
    final count = Count(countSnapshot);
    final total = count.total;

    await itList.add(<String, dynamic>{
      'ifText': randomIfText,
      'thenText': randomThenText,
      'createdAt': Timestamp.now(),
      'userId': userId,
      'favoriteUserId': initFavoriteUserId,
      'serialNumber': total
    });
  }

  Future<void> countTurningGacha() async {
    final userId = _auth.currentUser!.uid;

    await _firestore.collection('users').doc(userId).update({
      'turnGacha': FieldValue.arrayUnion(<Timestamp>[Timestamp.now()]),
    });
  }

  Future<void> checkTodayTurnGachaTimes() async {
    final userId = _auth.currentUser!.uid;
    final userDocument = await _firestore.collection('users').doc(userId).get();

    final List<dynamic> list = await userDocument.data()!['turnGacha'] ?? [];

    final turnGacha = list.map((e) => (e as Timestamp).toDate()).toList();

    if (turnGacha.length > 6) {
      await _firestore.collection('users').doc(userId).update({
        'turnGacha': FieldValue.arrayRemove(<dynamic>[]),
      });
    }

    canTurn = turnGacha
            .where(
              (e) =>
                  e.day == DateTime.now().day &&
                  e.year == DateTime.now().year &&
                  e.month == DateTime.now().month,
            )
            .length <
        5;
    notifyListeners();
  }
}
