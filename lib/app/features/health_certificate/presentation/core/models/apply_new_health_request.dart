import 'dart:convert';

ApplyNewHealthRequest applyNewHealthRequestFromJson(String str) =>
    ApplyNewHealthRequest.fromJson(json.decode(str));

String applyNewHealthRequestToJson(ApplyNewHealthRequest data) =>
    json.encode(data.toJson());

class ApplyNewHealthRequest {
  ApplyNewHealthRequest({
    this.statusDetails,
    this.data,
  });

  List<StatusDetail>? statusDetails;
  Data? data;

  factory ApplyNewHealthRequest.fromJson(Map<String, dynamic> json) =>
      ApplyNewHealthRequest(
        statusDetails: json["statusDetails"] == null
            ? null
            : List<StatusDetail>.from(
                json["statusDetails"].map((x) => StatusDetail.fromJson(x))),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "statusDetails": statusDetails == null
            ? null
            : List<dynamic>.from(statusDetails!.map((x) => x.toJson())),
        "data": data == null ? null : data!.toJson(),
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
        result: json["result"] == null ? null : Result.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "responseCode": responseCode,
        "responseMessage": responseMessage,
        "result": result == null ? null : result!.toJson(),
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
  dynamic printUrl;

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
