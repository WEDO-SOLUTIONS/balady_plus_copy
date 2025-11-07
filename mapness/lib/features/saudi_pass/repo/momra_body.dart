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

    return data.dataOrThrow();
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

  R dataOrThrow() {
    final result = this.result;

    if (responseCode != '1' || result == null) {
      // https://urbiae.sharepoint.com/:w:/r/sites/urbi.shared.lib/_layouts/15/Doc.aspx?sourcedoc=%7BDAB63164-7F94-445F-9288-872798B1E3FD%7D&file=Balady_Business_Saudi_Pass_Services%20Integration%20Guide%20V1.2.1.docx&action=default&mobileredirect=true
      // Custom Response Codes
      // This section describes the possible response code values in case of success or business errors.
      // | Code | Message                   |
      // |------|---------------------------|
      // |   1  | Success                   |
      // |   2  | Business Validation error |
      throw BusinessValidationError._(this);
    }

    return result;
  }

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
