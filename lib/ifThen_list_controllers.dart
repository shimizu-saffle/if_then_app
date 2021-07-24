import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:if_then_app/IfThen.dart';

final ItListProvider = ChangeNotifierProvider<ItListController>(
  (ref) => ItListController()..getItListRealtime(),
);

final AddProvider = ChangeNotifierProvider<ItListController>(
  (ref) => ItListController()..ifThenAdd(),
);

class ItListController extends ChangeNotifier {
  List<IfThen> itList = [];
  // Map<IfThen, String> itMap = {};
  String newIfText = '';
  String newThenText = '';

  Future getItList() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('itList').get();
    final docs = snapshot.docs;
    final itList = docs.map((doc) => IfThen(doc)).toList();
    this.itList = itList;
    notifyListeners();
  }

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
      'title': newIfText,
      'ifText': newIfText,
      'thenText': newThenText,
      'createdAt': Timestamp.now(),
    });
  }
}
