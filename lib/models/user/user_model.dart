import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:if_then_app/utils/json_converter.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    @Default('') String? userId,
    @TimestampConverter() DateTime? createdAt,
    @Default('') String? tokens,
    @Default('') String? email,
    @TimestampConverter() List<DateTime>? turnGacha,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}
