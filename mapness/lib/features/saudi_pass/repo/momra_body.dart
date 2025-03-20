import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

part 'momra_body.g.dart';

abstract class MomraBody<T, D extends Data<T>> {
  final StatusDetails statusDetails;
  final D? data;

  MomraBody({required this.statusDetails, this.data});

  T dataOrThrow() {
    final statusDetails = this.statusDetails;
    final data = this.data;

    if (statusDetails.code != HttpStatus.ok || data == null) {
      throw Exception('${statusDetails.code} ${statusDetails.message}');
    }

    final result = data.result;

    if (data.responseCode != '1' || result == null) {
      throw BusinessValidationError._(data);
    }

    return result;
  }
}

class BusinessValidationError implements Exception {
  final Data data;

  BusinessValidationError._(this.data);

  @override
  String toString() => 'BusinessValidationError{data: $data}';
}

abstract class Data<R> {
  final String responseCode;
  final String responseMessage;
  final String responseId;
  final R? result;

  Data({required this.responseCode, required this.responseMessage, required this.responseId, required this.result});

  @override
  String toString() => 'responseCode: $responseCode, responseMessage: $responseMessage, responseId: $responseId}';
}

const noRenameNoToJson = JsonSerializable(fieldRename: FieldRename.none, createToJson: false);

@noRenameNoToJson
class StatusDetails {
  final int code;
  final String message;

  StatusDetails({required this.code, required this.message});

  factory StatusDetails.fromJson(Map<String, dynamic> json) => _$StatusDetailsFromJson(json);
}
