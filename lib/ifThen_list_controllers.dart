import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:if_then_app/IfThen.dart';

final ItListProvider = ChangeNotifierProvider<IfThenListController>(
  (ref) => IfThenListController()..getItListRealtime(),
);

final AddProvider = ChangeNotifierProvider<IfThenListController>(
  (ref) => IfThenListController()..ifThenAdd(),
);

final DeleteProvider = ChangeNotifierProvider<IfThenListController>(
  (ref) => IfThenListController()..ifThenDelete(),
);

class IfThenListController extends ChangeNotifier {
  List<IfThen> itList = [];
  String newIfText = '';
  String newThenText = '';

  void getItListRealtime() async {
    final snapshots =
        FirebaseFirestore.instance.collection('itList').snapshots();
    snapshots.listen((snapshot) {
      final docs = snapshot.docs;
      final itList = docs.map((doc) => IfThen(doc)).toList();
      itList.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
      this.itList = itList;
      notifyListeners();
    });
  }

  Future ifThenAdd() async {
    final collection = FirebaseFirestore.instance.collection('itList');
    await collection.add({
      'ifText': newIfText,
      'thenText': newThenText,
      'createdAt': Timestamp.now(),
    });
  }

  Future ifThenDelete() async {
    final deleteCollection = FirebaseFirestore.instance.collection('itList');
    //下記のようにドキュメントのIDを指定したら消せる
    // await deleteCollection.doc('G8PMXhxknuqjPxkQiKdi').delete();
    await deleteCollection.doc().delete();
  }
}
