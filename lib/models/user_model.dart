import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  UserModel({
    this.userId,
    this.createdAt,
    this.tokens,
    this.email,
    this.turnGacha,
  });
  String? userId;
  Timestamp? createdAt;
  String? tokens;
  String? email;
  List<Timestamp>? turnGacha;
}
