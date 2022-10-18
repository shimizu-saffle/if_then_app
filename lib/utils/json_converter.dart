import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// json_serializable パッケージによって自動生成される **.g.dart ファイルはDartのオブジェクトしか使用できないため、
// パッケージ内で定義されているクラス型のフィールドを持つクラスで **.g.dart ファイルを使用する際に必要なコンバーター
class DocumentReferenceConverter
    implements JsonConverter<DocumentReference, DocumentReference> {
  const DocumentReferenceConverter();

  @override
  DocumentReference fromJson(DocumentReference reference) => reference;

  @override
  DocumentReference toJson(DocumentReference reference) => reference;
}

class DocumentReferenceNullableConverter
    implements JsonConverter<DocumentReference?, DocumentReference?> {
  const DocumentReferenceNullableConverter();

  @override
  DocumentReference? fromJson(DocumentReference? reference) => reference;

  @override
  DocumentReference? toJson(DocumentReference? reference) => reference;
}

class TimestampConverter implements JsonConverter<DateTime?, dynamic> {
  const TimestampConverter();

  @override
  DateTime? fromJson(dynamic timestamp) {
    if (timestamp == null) {
      return null;
    }
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    }
    return null;
  }

  @override
  dynamic toJson(DateTime? dateTime) => dateTime == null
      ? FieldValue.serverTimestamp()
      : Timestamp.fromDate(dateTime);
}
