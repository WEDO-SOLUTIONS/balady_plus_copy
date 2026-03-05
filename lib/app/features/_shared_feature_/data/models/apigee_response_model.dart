import '../entities/apigee_response.dart';

class ApigeeResponseModel<T> extends ApigeeResponse<T> {
  ApigeeResponseModel({super.data, super.statusDetails});

  factory ApigeeResponseModel.fromMap(Map<String, dynamic> json, {T? parsedResult}) => ApigeeResponseModel<T>(
    statusDetails: json["statusDetails"] != null ? StatusDetailsModel.fromMap(json["statusDetails"]) : null,
    data: json["data"] != null ? ResponseModel<T>.fromMap(json["data"], parsedResult: parsedResult) : null,
  );
}

class ResponseModel<T> extends Response<T> {
  ResponseModel({super.responseCode, super.responseMessage, super.beRequestId, super.correlationId, super.result});

  factory ResponseModel.fromMap(Map<String, dynamic> json, {T? parsedResult}) => ResponseModel(
    responseCode: json["responseCode"] != null ? json["responseCode"].toString() : json["responseCode"],
    beRequestId: json["beRequestId"],
    correlationId: json["correlationId"],
    responseMessage: json["responseMessage"],
    result: parsedResult,
  );
}

class StatusDetailsModel extends StatusDetails {
  StatusDetailsModel({super.code, super.message});

  factory StatusDetailsModel.fromMap(Map<String, dynamic> json) =>
      StatusDetailsModel(code: json["code"], message: json["message"]);
}
