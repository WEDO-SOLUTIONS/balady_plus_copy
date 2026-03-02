import 'package:localize_and_translate/localize_and_translate.dart';

class ResponseBodyModel<T> {
  StatusDetailsModel? statusDetails;
  ResponseData<T>? data;

  ResponseBodyModel({this.data, this.statusDetails});

  factory ResponseBodyModel.fromMap(Map<String, dynamic> json, {T? parsedResult}) => ResponseBodyModel<T>(
      statusDetails: json["statusDetails"] != null ? StatusDetailsModel.fromMap(json["statusDetails"]) : null,
      data: json["data"] != null ? ResponseData<T>.fromMap(json["data"], parsedResult: parsedResult) : null);
}

class ResponseData<T> {
  String? responseCode;
  String? responseMessage;
  String? correlationId;
  String? beRequestId;
  T? result;

  ResponseData({this.responseCode, this.responseMessage, this.beRequestId, this.correlationId, this.result});

  factory ResponseData.fromMap(Map<String, dynamic> json, {T? parsedResult}) => ResponseData(
      responseCode: json["responseCode"] != null ? json["responseCode"].toString() : json["responseCode"],
      beRequestId: json["beRequestId"],
      correlationId: json["correlationId"],
      responseMessage: json["responseMessage"],
      result: parsedResult ?? json["result"]);

  String? getRefResponseMessage() {
    if (beRequestId != null)
      return (responseMessage ?? "0") + "\n" + ("be_request_error").tr().replaceAll("{}", (beRequestId ?? ""));
    return responseMessage;
  }
}

class StatusDetailsModel {
  int? code;
  String? message;
  StatusDetailsModel({this.code, this.message});

  factory StatusDetailsModel.fromMap(Map<String, dynamic> json) =>
      StatusDetailsModel(code: json["code"], message: json["message"]);
}
