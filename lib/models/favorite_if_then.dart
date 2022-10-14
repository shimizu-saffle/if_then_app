import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class FavoriteIfThen {
  FavoriteIfThen(DocumentSnapshot<Map<String, dynamic>> doc) {
    Firebase.initializeApp();
    documentID = doc.id;
    userId = doc.data()!['userId'];
    createdAt = doc.data()!['createdAt'];
  }

  String? documentID;
  String? userId;
  Timestamp? createdAt;
}
