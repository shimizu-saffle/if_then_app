import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? userId;
  Timestamp? createdAt;
  String? tokens;
  String? email;

  UserModel({
    this.userId,
    this.createdAt,
    this.tokens,
    this.email,
  });
}
