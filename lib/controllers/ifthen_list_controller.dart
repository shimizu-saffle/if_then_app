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

  //itListドキュメントにfavoriteUserという配列型のフィールドを持たせて
  //フィールドの値にはFirebaseAuth.instance.currentUser!.uidを入れる
  //FCMトークン取得のメソッドを参考にする
  //itList更新メソッドを参考にする
  //タイムラインページのお気に入りアイコンボタンでこのメソッドを呼び出す。
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
    await FirebaseFirestore.instance
        .collection('itList')
        .doc(ifThen.documentID)
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

final favoriteIfThenProvider = ChangeNotifierProvider<FavoriteIfThenController>(
  (ref) => FavoriteIfThenController()..getMyFavoriteIfThenRealtime(),
);

class FavoriteIfThenController extends ChangeNotifier {
  List<IfThen> favoriteIfThenList = [];

  //イフゼンプランドキュメントのサブコレクションfavoriteからお気に入り一覧を取得するメソッド
  //だけどfavoriteIfThenListの中身は空になってしまう
  void getMyFavoriteIfThenRealtime() async {
    final snapshots = FirebaseFirestore.instance
        .collectionGroup('favorite')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .snapshots();
    snapshots.listen((snapshot) async {
      favoriteIfThenList.clear();
      //inの右側にある配列を一つずつ取り出して処理をする
      for (final doc in snapshot.docs) {
        doc.reference.parent.parent!.get();
        final ifThenDoc = await doc.reference.parent.parent!.get();
        favoriteIfThenList.add(IfThen(ifThenDoc));
      }
      notifyListeners();
    });
  }

//itListドキュメントのサブコレクションFavoriteに追加
  Future favoriteIfThenAdd(IfThen ifThen) async {
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    final collection = FirebaseFirestore.instance.collection('itList');
    await collection
        .doc(ifThen.documentID)
        .collection('favorite')
        .doc(userId)
        .set({'createdAt': Timestamp.now(), 'userId': userId});
  }

//itListドキュメントのサブコレクションFavoriteから削除
  Future deleteFavoriteIfThen(IfThen ifThen) async {
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    final collection = FirebaseFirestore.instance.collection('itList');
    await collection
        .doc(ifThen.documentID)
        .collection('favorite')
        .doc(userId)
        .delete();
  }

  bool favorite = false;

  //お気に入りアイコンの色を変える
  void changeColor() {
    if (favorite) {
      favorite = false;
    } else {
      favorite = true;
    }
    notifyListeners();
  }
}
