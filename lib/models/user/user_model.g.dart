// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserModel _$$_UserModelFromJson(Map<String, dynamic> json) => _$_UserModel(
      userId: json['userId'] as String? ?? '',
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      tokens: json['tokens'] as String? ?? '',
      email: json['email'] as String? ?? '',
      turnGacha: (json['turnGacha'] as List<dynamic>?)
          ?.map((e) => DateTime.parse(e as String))
          .toList(),
    );

Map<String, dynamic> _$$_UserModelToJson(_$_UserModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'tokens': instance.tokens,
      'email': instance.email,
      'turnGacha': instance.turnGacha?.map((e) => e.toIso8601String()).toList(),
    };
