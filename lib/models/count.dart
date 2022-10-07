import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Count {
  Count(DocumentSnapshot<Map<String, dynamic>> doc) {
    Firebase.initializeApp();
    count = doc.id;
    total = doc.data()!['total'];
  }

  String? count;
  int? total;
}
