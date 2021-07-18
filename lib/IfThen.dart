import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class IfThen {
  IfThen(DocumentSnapshot doc) {
    Firebase.initializeApp();
    //　意味を理解できてない記述箇所①
    final Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
    this.title = data['title'];
    this.createdAt = data['createdAt'];
  }

  String? title;
  Timestamp? createdAt;
}
