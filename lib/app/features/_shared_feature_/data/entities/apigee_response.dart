import 'package:localize_and_translate/localize_and_translate.dart';

class ApigeeResponse<T> {
  StatusDetails? statusDetails;
  Response<T>? data;

  ApigeeResponse({this.data, this.statusDetails});
}

class StatusDetails {
  StatusDetails({
    this.code,
    this.message,
  });

  int? code;
  String? message;
}

class Response<T> {
  String? responseCode;
  String? responseMessage;
  String? correlationId;
  String? beRequestId;
  T? result;

  Response({this.responseCode, this.responseMessage, this.beRequestId, this.correlationId, this.result});

  String? getRefResponseMessage() {
    if (beRequestId != null)
      return (responseMessage ?? "0") + "\n" + ("be_request_error").tr().replaceAll("{}", (beRequestId ?? ""));
    return responseMessage;
  }
}
