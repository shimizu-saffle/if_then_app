import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class FavoriteIfThen {
  FavoriteIfThen(DocumentSnapshot<Map<String, dynamic>> doc) {
    Firebase.initializeApp();
    //Stringがキーでdynamicがバリュー
    //documentスナップショットに対してジェネリクスを使って型を動的に指定することができる
    this.documentID = doc.id;
    this.userId = doc.data()!['userId'];
    this.createdAt = doc.data()!['createdAt'];
  }

  String? documentID;
  String? userId;
  Timestamp? createdAt;
}
