import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/count.dart';
import '../models/ifthen.dart';

final ifThenListProvider = ChangeNotifierProvider<IfThenListController>(
  (ref) => IfThenListController()..getItListRealtime(),
);

final AddProvider = ChangeNotifierProvider<IfThenListController>(
  (ref) => IfThenListController(),
);

class IfThenListController extends ChangeNotifier {
  List<IfThen> ifThenList = [];
  List<String> initFavoriteUserId = [];
  String newIfText = '';
  String newThenText = '';

  Future<void> getItListRealtime() async {
    final snapshots =
        FirebaseFirestore.instance.collection('itList').snapshots();
    snapshots.listen((snapshot) {
      final docs = snapshot.docs;
      final itList = docs.map(IfThen.new).toList();
      itList.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
      ifThenList = itList;
      notifyListeners();
    });
  }

  Future ifThenAdd() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final itList = FirebaseFirestore.instance.collection('itList');
    final countRef =
        FirebaseFirestore.instance.collection('settings').doc('count');

    await countRef.update({
      'total': FieldValue.increment(1),
    });

    final countSnapshot = await countRef.get();
    final count = Count(countSnapshot);
    final total = count.total;

    await itList.add({
      'ifText': newIfText,
      'thenText': newThenText,
      'createdAt': Timestamp.now(),
      'userId': userId,
      'favoriteUserId': initFavoriteUserId,
      'serialNumber': total
    });
  }

  Future<void> saveFavoriteUserId(IfThen ifThen) async {
    final favoriteUserId = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('itList')
        .doc(ifThen.documentID)
        .update({
      'favoriteUserId': FieldValue.arrayUnion([favoriteUserId]),
    });
  }

  Future<void> deleteFavoriteUserId(IfThen ifThen) async {
    final favoriteUserId = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('itList')
        .doc(ifThen.documentID)
        .update({
      'favoriteUserId': FieldValue.arrayRemove([favoriteUserId]),
    });
  }

  Future ifThenUpdate(IfThen ifThen) async {
    final document =
        FirebaseFirestore.instance.collection('itList').doc(ifThen.documentID);
    await document.update({
      'ifText': newIfText,
      'thenText': newThenText,
      'createdAt': Timestamp.now(),
    });
  }

  Future ifThenDelete(IfThen ifThen) async {
    final count =
        FirebaseFirestore.instance.collection('settings').doc('count');

    await FirebaseFirestore.instance
        .collection('itList')
        .doc(ifThen.documentID)
        .delete();

    await count.update({
      'total': FieldValue.increment(-1),
    });
  }
}

final myifThenListProvider = ChangeNotifierProvider<MyIfThenListController>(
  (ref) => MyIfThenListController()..getMyItListRealtime(),
);

final myFavoriteIfThenListProvider =
    ChangeNotifierProvider<MyIfThenListController>(
  (ref) => MyIfThenListController()..getMyFavoriteItListRealtime(),
);

class MyIfThenListController extends ChangeNotifier {
  List<IfThen> myIfThenList = [];
  List<IfThen> myFavoriteIfThenList = [];

  Future<void> getMyItListRealtime() async {
    final snapshots = FirebaseFirestore.instance
        .collection('itList')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .snapshots();
    snapshots.listen((snapshot) {
      final docs = snapshot.docs;
      final itList = docs.map(IfThen.new).toList();
      itList.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
      myIfThenList = itList;
      notifyListeners();
    });
  }

  Future<void> getMyFavoriteItListRealtime() async {
    final snapshots = FirebaseFirestore.instance
        .collection('itList')
        .where(
          'favoriteUserId',
          arrayContains: FirebaseAuth.instance.currentUser?.uid,
        )
        .snapshots();
    snapshots.listen((snapshot) {
      final docs = snapshot.docs;
      final itList = docs.map(IfThen.new).toList();
      itList.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
      myFavoriteIfThenList = itList;
      notifyListeners();
    });
  }
}
