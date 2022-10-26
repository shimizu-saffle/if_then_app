import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:if_then_app/utils/uuid.dart';


import '../models/count.dart';
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
  final _auth = FirebaseAuth.instance;
  final _store = FirebaseFirestore.instance;

  Future<void> getItListRealtime() async {
    _store
        .collection('itList')
        .snapshots()
        .listen((snapshot) {
      final docs = snapshot.docs;
      ifThenList = docs.map((doc) => IfThen(doc)).toList();

      // ifThenList.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
      // ↑↑エラー発生
      // aに値が入らず
      // _CastError (Null check operator used on a null value)
      notifyListeners();
    });
  }

  Future<void> ifThenAdd() async {
    final userId =_auth.currentUser!.uid;
    final itList = _store.collection('itList');
    final countRef =
        _store.collection('settings').doc('count');

    await countRef.update({
      'total': FieldValue.increment(1),
    });

    final countSnapshot = await countRef.get();
    final count = Count(countSnapshot);
    final total = count.total;

    await itList.add(<String, dynamic>{
      'ifText': newIfText,
      'thenText': newThenText,
      'createdAt': Timestamp.now(),
      'userId': userId,
      'favoriteUserId': initFavoriteUserId,
      'serialNumber': total,
      'uuid': uuid,
    });
  }

  Future<void> saveFavoriteUserId(IfThen ifThen) async {
    final favoriteUserId = _auth.currentUser!.uid;

    await _store
        .collection('itList')
        .doc(ifThen.documentID)
        .update({
      'favoriteUserId': FieldValue.arrayUnion(<String>[favoriteUserId]),
    });
  }

  Future<void> deleteFavoriteUserId(IfThen ifThen) async {
    final favoriteUserId = _auth.currentUser!.uid;

    await _store
        .collection('itList')
        .doc(ifThen.documentID)
        .update({
      'favoriteUserId': FieldValue.arrayRemove(<String>[favoriteUserId]),
    });
  }

  Future<void> ifThenUpdate(IfThen ifThen) async {
    final document =
        _store.collection('itList').doc(ifThen.documentID);
    await document.update({
      'ifText': newIfText,
      'thenText': newThenText,
      'createdAt': Timestamp.now(),
    });
  }

  Future<void> ifThenDelete(IfThen ifThen) async {
    final count =
        _store.collection('settings').doc('count');

    await _store
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

  final _auth = FirebaseAuth.instance;

  Future<void> getMyItListRealtime() async {
    FirebaseFirestore.instance
        .collection('itList')
        .where('userId', isEqualTo: _auth.currentUser?.uid)
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
          arrayContains: _auth.currentUser?.uid,
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
