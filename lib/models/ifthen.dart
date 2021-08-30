import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class IfThen {
  IfThen(DocumentSnapshot<Map<String, dynamic>> doc) {
    Firebase.initializeApp();
    //Stringがキーでdynamicがバリュー
    //FirestoreのdocumentスナップショットはMap型ではなくなった
    //documentスナップショットに対してジェネリクスを使って型を動的に指定することができる
    this.documentID = doc.id;
    this.ifText = doc.data()!['ifText'];
    this.thenText = doc.data()!['thenText'];
    this.userId = doc.data()!['userId'];
    this.createdAt = doc.data()!['createdAt'];
    this.favoriteUserId = doc.data()!['favoriteUserId'];
  }

  String? documentID;
  String? ifText;
  String? thenText;
  String? userId;
  Timestamp? createdAt;
  List? favoriteUserId;
}
