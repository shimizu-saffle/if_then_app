import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class IfThen {
  IfThen(DocumentSnapshot doc) {
    Firebase.initializeApp();
    final Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
    this.title = data['title'];
    this.createdAt = data['createdAt'];
    // this.documentReference = doc.reference;
  }

  String? title;
  Timestamp? createdAt;
  // bool? isDone = false;
  // DocumentReference? documentReference;
}
