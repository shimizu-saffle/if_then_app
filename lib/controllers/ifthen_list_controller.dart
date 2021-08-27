import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:if_then_app/models/ifthen.dart';

final IfThenListProvider = ChangeNotifierProvider<IfThenListController>(
  (ref) => IfThenListController()..getItListRealtime(),
);

final AddProvider = ChangeNotifierProvider<IfThenListController>(
  (ref) => IfThenListController()..ifThenAdd(),
);

class IfThenListController extends ChangeNotifier {
  List<IfThen> ifThenList = [];
  String newIfText = '';
  String newThenText = '';

  void getItListRealtime() async {
    final snapshots =
        FirebaseFirestore.instance.collection('itList').snapshots();
    snapshots.listen((snapshot) {
      final docs = snapshot.docs;
      final itList = docs.map((doc) => IfThen(doc)).toList();
      itList.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
      this.ifThenList = itList;
      notifyListeners();
    });
  }

  Future ifThenAdd() async {
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    final collection = FirebaseFirestore.instance.collection('itList');
    await collection.add({
      'ifText': newIfText,
      'thenText': newThenText,
      'createdAt': Timestamp.now(),
      'userId': userId
    });
  }

  Future ifThenUpdate(IfThen ifthen) async {
    final document =
        FirebaseFirestore.instance.collection('itList').doc(ifthen.documentID);
    await document.update({
      'ifText': newIfText,
      'thenText': newThenText,
      'createdAt': Timestamp.now(),
    });
  }

  Future ifThenDelete(IfThen ifthen) async {
    await FirebaseFirestore.instance
        .collection('itList')
        .doc(ifthen.documentID)
        .delete();
  }
}

final myIfThenListProvider = ChangeNotifierProvider<MyIfThenListController>(
  (ref) => MyIfThenListController()..getMyItListRealtime(),
);

class MyIfThenListController extends ChangeNotifier {
  List<IfThen> myIfThenList = [];
  void getMyItListRealtime() async {
    final snapshots = FirebaseFirestore.instance
        .collection('itList')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .snapshots();
    snapshots.listen((snapshot) {
      final docs = snapshot.docs;
      final itList = docs.map((doc) => IfThen(doc)).toList();
      itList.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
      this.myIfThenList = itList;
      notifyListeners();
    });
  }
}