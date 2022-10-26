import 'package:cloud_firestore/cloud_firestore.dart';

class Count {
  Count(DocumentSnapshot<Map<String, dynamic>> doc) {
    count = doc.id;
    total = doc.data()!['total'];
  }

  String? count;
  int? total;
}
