import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class FavoriteIfThen {
  FavoriteIfThen(DocumentSnapshot<Map<String, dynamic>> doc) {
    Firebase.initializeApp();
    this.documentID = doc.id;
    this.userId = doc.data()!['userId'];
    this.createdAt = doc.data()!['createdAt'];
  }

  String? documentID;
  String? userId;
  Timestamp? createdAt;
}
