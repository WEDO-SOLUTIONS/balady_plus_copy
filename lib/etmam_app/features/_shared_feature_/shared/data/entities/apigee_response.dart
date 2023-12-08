import 'package:balady_plus/etmam_app/core/utils/constants/app_config.dart';

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

  Response(
      {this.responseCode,
      this.responseMessage,
      this.beRequestId,
      this.correlationId,
      this.result});

  String? getRefResponseMessage() {
    if (beRequestId != null)
      return (responseMessage ?? "0") +
          "\n" +
          trans("be_request_error").replaceAll("{}", (beRequestId ?? ""));
    return responseMessage;
  }
}
