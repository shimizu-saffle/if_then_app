import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/count.dart';
import '../utils/uuid.dart';

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

  final _store = FirebaseFirestore.instance;

  Future<void> getRandomIfThen() async {
    //Uuidを発行してserialNumberが保持しているUuidと比較
    //Uuid以上かつ一番近いserialNumberのドキュメントを取得
    //Uuid以上にserialNumberが無い場合は0から一番近いserialNumberのドキュメントを取得
    final ifSnapshots = await _store
        .collection('itList')
        .where(
          'uuid',
          isGreaterThanOrEqualTo: uuid,
        )
        .limit(1)
        .get();

    if (ifSnapshots.docs.isEmpty) {
      final ifSnapshotTo0 = await _store
          .collection('itList')
          .where(
            'uuid',
            isGreaterThanOrEqualTo: '0',
          )
          .limit(1)
          .get();
      randomIfText = await ifSnapshotTo0.docs[0].data()['ifText'];
    } else {
      randomIfText = await ifSnapshots.docs[0].data()['ifText'];
    }

    final thenSnapshots = await _store
        .collection('itList')
        .where(
          'uuid',
          isGreaterThanOrEqualTo: uuid,
        )
        .limit(1)
        .get();

    if (thenSnapshots.docs.isEmpty) {
      final thenSnapshotTo0 = await _store
          .collection('itList')
          .where(
            'uuid',
            isGreaterThanOrEqualTo: '0',
          )
          .limit(1)
          .get();
      randomThenText = await thenSnapshotTo0.docs[0].data()['thenText'];
    } else {
      randomThenText = await thenSnapshots.docs[0].data()['thenText'];
      debugPrint('debug : $randomIfText');
    }
  }

  Future<void> addRandomToMyIfThen() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final itList = _store.collection('itList');
    final countRef = _store.collection('settings').doc('count');

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
      'serialNumber': total,
      'uuid': uuid,
    });
  }

  Future<void> countTurningGacha() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    await _store.collection('users').doc(userId).update({
      'turnGacha': FieldValue.arrayUnion(<Timestamp>[Timestamp.now()]),
    });
  }

  Future<void> checkTodayTurnGachaTimes() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final userDocument = await _store.collection('users').doc(userId).get();

    final List<dynamic> list = await userDocument.data()!['turnGacha'] ?? [];

    final turnGacha = list.map((e) => (e as Timestamp).toDate()).toList();

    if (turnGacha.length > 6) {
      await _store.collection('users').doc(userId).update({
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
