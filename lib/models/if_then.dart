import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class IfThen {
  IfThen(DocumentSnapshot<Map<String, dynamic>> doc) {
    Firebase.initializeApp();
    documentID = doc.id;
    ifText = doc.data()!['ifText'];
    thenText = doc.data()!['thenText'];
    userId = doc.data()!['userId'];
    createdAt = doc.data()!['createdAt'];
    favoriteUserId = doc.data()!['favoriteUserId'];
    serialNumber = doc.data()!['serialNumber'];
    uuid = doc.data()!['uuid'];
  }

  String? documentID;
  String? ifText;
  String? thenText;
  String? userId;
  Timestamp? createdAt;
  List<dynamic>? favoriteUserId;
  int? serialNumber;
  String? uuid;
}
