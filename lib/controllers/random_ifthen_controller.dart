import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:if_then_app/models/count.dart';

final randomProvider = ChangeNotifierProvider<RandomIfThenController>(
  (ref) => RandomIfThenController(),
);

class RandomIfThenController extends ChangeNotifier {
  String randomIfText = '';
  String randomThenText = '';

  Future getRandomIfThen() async {
    final DocumentReference<Map<String, dynamic>> countRef =
        FirebaseFirestore.instance.collection('settings').doc('count');
    final countSnapshot = await countRef.get();
    final count = Count(countSnapshot);
    final randomRange = count.total;
    int randomSerialNumber1 = Random().nextInt(randomRange!) + 1;
    int randomSerialNumber2 = Random().nextInt(randomRange) + 1;

    print('イフ${randomSerialNumber1}');
    print('ゼン${randomSerialNumber2}');

    final ifSnapshots = await FirebaseFirestore.instance
        .collection('itList')
        .where('serialNumber', isEqualTo: randomSerialNumber1)
        .get();

    final thenSnapshots = await FirebaseFirestore.instance
        .collection('itList')
        .where('serialNumber', isEqualTo: randomSerialNumber2)
        .get();

    final randomIfText = ifSnapshots.docs[0].data()['ifText'];
    final randomThenText = thenSnapshots.docs[0].data()['thenText'];

    print(randomIfText + randomThenText);
  }
}
