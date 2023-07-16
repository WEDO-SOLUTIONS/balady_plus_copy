import 'dart:convert';

ValidateHealthCertificateResponse validateHealthCertificateResponseFromJson(
        String str) =>
    ValidateHealthCertificateResponse.fromJson(json.decode(str));

String validateHealthCertificateResponseToJson(
        ValidateHealthCertificateResponse data) =>
    json.encode(data.toJson());

class ValidateHealthCertificateResponse {
  ValidateHealthCertificateResponse({
    this.statusDetails,
    this.data,
  });

  List<StatusDetail>? statusDetails;
  Data? data;

  factory ValidateHealthCertificateResponse.fromJson(
          Map<String, dynamic> json) =>
      ValidateHealthCertificateResponse(
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

  dynamic responseCode;
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
  Result(
      {this.linkType,
      this.showCommercialNo,
      this.showLicense,
      this.showAreaNoLicencePermit,
      this.terms,
      this.isSaudi,
      this.notPermitLiceTerm,
      this.showHealthCenters});

  String? linkType;
  bool? showCommercialNo;
  bool? showLicense;
  bool? showAreaNoLicencePermit;
  List<String>? terms;
  bool? isSaudi;
  String? notPermitLiceTerm;
  bool? showHealthCenters;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
      linkType: json["linkType"],
      showCommercialNo: json["showCommercialNo"],
      showLicense: json["showLicense"],
      showAreaNoLicencePermit: json["showAreaNoLicencePermit"],
      terms: json["terms"] == null
          ? null
          : List<String>.from(json["terms"].map((x) => x)),
      isSaudi: json["isSaudi"],
      notPermitLiceTerm: json["notPermitLiceTerm"],
      showHealthCenters: json["showHealthCenters"]);

  Map<String, dynamic> toJson() => {
        "linkType": linkType,
        "showCommercialNo": showCommercialNo,
        "showLicense": showLicense,
        "showAreaNoLicencePermit": showAreaNoLicencePermit,
        "terms":
            terms == null ? null : List<dynamic>.from(terms!.map((x) => x)),
        "isSaudi": isSaudi,
        "notPermitLiceTerm": notPermitLiceTerm,
        "showHealthCenters": showHealthCenters
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
