import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:if_then_app/IfThen.dart';

final itListProvider = ChangeNotifierProvider<ItListController>(
  (ref) => ItListController(),
);

class ItListController extends ChangeNotifier {
  List<IfThen> itList = [];
  String newIfThenText = '';

  Future getItList() async {
    await Firebase.initializeApp();
    final snapshot =
        await FirebaseFirestore.instance.collection('itList').get();
    final docs = snapshot.docs;
    final itList = docs.map((doc) => IfThen(doc)).toList();
    this.itList = itList;
    notifyListeners();
  }
}
