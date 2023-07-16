import 'dart:convert';

CancelHealthCertificateResponse cancelHealthCertificateResponseFromJson(
        String str) =>
    CancelHealthCertificateResponse.fromJson(json.decode(str));

String cancelHealthCertificateResponseToJson(
        CancelHealthCertificateResponse data) =>
    json.encode(data.toJson());

class CancelHealthCertificateResponse {
  CancelHealthCertificateResponse({
    this.statusDetails,
    this.data,
  });

  List<StatusDetail>? statusDetails;
  Data? data;

  factory CancelHealthCertificateResponse.fromJson(Map<String, dynamic> json) =>
      CancelHealthCertificateResponse(
        statusDetails: json["statusDetails"] != null
            ? List<StatusDetail>.from(
                json["statusDetails"].map((x) => StatusDetail.fromJson(x)))
            : null,
        data: json["data"] != null ? Data.fromJson(json["data"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "statusDetails": statusDetails != null
            ? List<dynamic>.from(statusDetails!.map((x) => x.toJson()))
            : null,
        "data": data != null ? data!.toJson() : null,
      };
}

class Data {
  Data({
    this.responseCode,
    this.responseMessage,
    this.result,
  });

  String? responseCode;
  String? responseMessage;
  Result? result;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        responseCode: json["responseCode"],
        responseMessage: json["responseMessage"],
        result: json["result"] != null ? Result.fromJson(json["result"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "responseCode": responseCode,
        "responseMessage": responseMessage,
        "result": result != null ? result!.toJson() : null,
      };
}

class Result {
  Result({
    this.requestId,
    this.gotoRating,
    this.message,
    this.printUrl,
  });

  int? requestId;
  bool? gotoRating;
  String? message;
  String? printUrl;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        requestId: json["requestId"],
        gotoRating: json["gotoRating"],
        message: json["message"],
        printUrl: json["printUrl"],
      );

  Map<String, dynamic> toJson() => {
        "requestId": requestId,
        "gotoRating": gotoRating,
        "message": message,
        "printUrl": printUrl,
      };
}

class StatusDetail {
  StatusDetail({
    this.code,
    this.message,
  });

  int? code;
  String? message;

  factory StatusDetail.fromJson(Map<String, dynamic> json) => StatusDetail(
        code: json["code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
      };
}
