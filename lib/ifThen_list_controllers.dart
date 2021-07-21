import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:if_then_app/IfThen.dart';

final itListProvider = ChangeNotifierProvider<ItListController>(
  (ref) => ItListController()..getItListRealtime(),
);

class ItListController extends ChangeNotifier {
  List<IfThen> itList = [];

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
}
