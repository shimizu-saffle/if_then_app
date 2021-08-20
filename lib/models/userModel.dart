import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  Timestamp? accountCreated;
  String? notifToken;

  UserModel({
    this.uid,
    this.accountCreated,
    this.notifToken,
  });
}
