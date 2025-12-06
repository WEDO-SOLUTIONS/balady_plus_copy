import 'package:flutter/foundation.dart';

class JobBaseResponse<T> {
  const JobBaseResponse({
    this.data,
    this.statusDetails,
  });

  factory JobBaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) =>
      JobBaseResponse(
        statusDetails: json['statusDetails'] != null
            ? StatusModel.fromJson(
                json['statusDetails'] as Map<String, dynamic>,
              )
            : null,
        data: json['data'] != null
            ? JobResponseModel.fromJson(
                json['data'] as Map<String, dynamic>,
                fromJson,
              )
            : null,
      );
  final StatusModel? statusDetails;
  final JobResponseModel<T>? data;

  bool get isSuccess => statusDetails?.code == 200 && data?.responseCode == '1';
  String? get message => statusDetails?.message;
}

//TODO(Scroollocker): change to equatable
@immutable
class StatusModel {
  const StatusModel({
    this.code,
    this.message,
  });

  factory StatusModel.fromJson(Map<String, dynamic> json) => StatusModel(
        code: json['code'] as int?,
        message: json['message'] as String?,
      );
  final int? code;
  final String? message;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is StatusModel && other.code == code && other.message == message;
  }

  @override
  int get hashCode => code.hashCode ^ message.hashCode;
}

@immutable
class JobResponseModel<T> {
  const JobResponseModel({
    this.responseCode,
    this.responseMessage,
    this.responseId,
    this.result,
  });

  factory JobResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) =>
      JobResponseModel(
        responseCode: json['responseCode'] as String?,
        responseMessage: json['responseMessage'] as String?,
        responseId: json['responseId'] as String?,
        result: json['result'] != null ? fromJson(json['result'] as Map<String, dynamic>) : null,
      );
  final String? responseCode;
  final String? responseMessage;
  final String? responseId;
  final T? result;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is JobResponseModel &&
        other.responseCode == responseCode &&
        other.responseMessage == responseMessage &&
        other.responseId == responseId &&
        other.result == result;
  }

  @override
  int get hashCode => responseCode.hashCode ^ responseMessage.hashCode ^ responseId.hashCode ^ result.hashCode;
}
