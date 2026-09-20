// To parse this JSON data, do
//
//     final versionInfo = versionInfoFromJson(jsonString);

class VersionInfo {
  VersionInfo({this.statusDetails, this.data});

  List<StatusDetail>? statusDetails;
  Data? data;

  factory VersionInfo.fromJson(Map<String, dynamic> json) => VersionInfo(
    statusDetails: List<StatusDetail>.from(json["statusDetails"].map((x) => StatusDetail.fromJson(x))),
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "statusDetails": List<dynamic>.from(statusDetails!.map((x) => x.toJson())),
    "data": data!.toJson(),
  };
}

class Data {
  Data({this.responseCode, this.responseMessage, this.result});

  int? responseCode;
  String? responseMessage;
  Result? result;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    responseCode: json["responseCode"],
    responseMessage: json["responseMessage"],
    result: Result.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "responseCode": responseCode,
    "responseMessage": responseMessage,
    "result": result!.toJson(),
  };
}

class Result {
  Result({
    this.id,
    this.applicationId,
    this.forceUpdate,
    this.buildNumber,
    this.versionNumber,
    this.type,
    this.createdDate,
    this.updatedDate,
  });

  int? id;
  String? applicationId;
  bool? forceUpdate;
  String? buildNumber;
  String? versionNumber;
  String? type;
  DateTime? createdDate;
  DateTime? updatedDate;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["ID"],
    applicationId: json["ApplicationID"],
    forceUpdate: json["ForceUpdate"],
    buildNumber: json["BuildNumber"],
    versionNumber: json["VersionNumber"],
    type: json["Type"],
    createdDate: DateTime.parse(json["CreatedDate"]),
    updatedDate: DateTime.parse(json["UpdatedDate"]),
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "ApplicationID": applicationId,
    "ForceUpdate": forceUpdate,
    "BuildNumber": buildNumber,
    "VersionNumber": versionNumber,
    "Type": type,
    "CreatedDate": createdDate!.toIso8601String(),
    "UpdatedDate": updatedDate!.toIso8601String(),
  };
}

class StatusDetail {
  StatusDetail({this.code, this.message});

  int? code;
  String? message;

  factory StatusDetail.fromJson(Map<String, dynamic> json) =>
      StatusDetail(code: json["code"], message: json["message"]);

  Map<String, dynamic> toJson() => {"code": code, "message": message};
}
