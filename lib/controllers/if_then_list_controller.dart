import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:if_then_app/utils/uuid.dart';

import '../models/if_then.dart';

final ifThenListProvider = ChangeNotifierProvider<IfThenListController>(
  (ref) => IfThenListController()..getItListRealtime(),
);

final addProvider = ChangeNotifierProvider<IfThenListController>(
  (ref) => IfThenListController(),
);

class IfThenListController extends ChangeNotifier {
  List<IfThen> ifThenList = [];
  List<String> initFavoriteUserId = [];
  String newIfText = '';
  String newThenText = '';

  Future<void> getItListRealtime() async {
    FirebaseFirestore.instance
        .collection('itList')
        .snapshots()
        .listen((snapshot) {
      final docs = snapshot.docs;
      ifThenList = docs.map(IfThen.new).toList();
      ifThenList.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
      notifyListeners();
    });
  }

  Future<void> ifThenAdd() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final itList = FirebaseFirestore.instance.collection('itList');

    await itList.add(<String, dynamic>{
      'ifText': newIfText,
      'thenText': newThenText,
      'createdAt': Timestamp.now(),
      'userId': userId,
      'favoriteUserId': initFavoriteUserId,
      'serialNumber': uuid
    });
  }

  Future<void> saveFavoriteUserId(IfThen ifThen) async {
    final favoriteUserId = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('itList')
        .doc(ifThen.documentID)
        .update({
      'favoriteUserId': FieldValue.arrayUnion(<String>[favoriteUserId]),
    });
  }

  Future<void> deleteFavoriteUserId(IfThen ifThen) async {
    final favoriteUserId = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('itList')
        .doc(ifThen.documentID)
        .update({
      'favoriteUserId': FieldValue.arrayRemove(<String>[favoriteUserId]),
    });
  }

  Future<void> ifThenUpdate(IfThen ifThen) async {
    final document =
        FirebaseFirestore.instance.collection('itList').doc(ifThen.documentID);
    await document.update({
      'ifText': newIfText,
      'thenText': newThenText,
      'createdAt': Timestamp.now(),
    });
  }

  Future<void> ifThenDelete(IfThen ifThen) async {
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
    FirebaseFirestore.instance
        .collection('itList')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .snapshots()
        .listen((snapshot) {
      final docs = snapshot.docs;
      myIfThenList = docs.map(IfThen.new).toList();
      myIfThenList.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
      notifyListeners();
    });
  }

  Future<void> getMyFavoriteItListRealtime() async {
    FirebaseFirestore.instance
        .collection('itList')
        .where(
          'favoriteUserId',
          arrayContains: FirebaseAuth.instance.currentUser?.uid,
        )
        .snapshots()
        .listen((snapshot) {
      final docs = snapshot.docs;
      myFavoriteIfThenList = docs.map(IfThen.new).toList();
      myFavoriteIfThenList.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
      notifyListeners();
    });
  }
}
