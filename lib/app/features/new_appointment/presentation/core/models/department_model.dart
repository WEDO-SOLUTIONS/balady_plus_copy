import 'dart:convert';

DepartmentList departmentListFromJson(String str) =>
    DepartmentList.fromJson(json.decode(str));

String departmentListToJson(DepartmentList data) => json.encode(data.toJson());

class DepartmentList {
  DepartmentList({
    this.statusDetails,
    this.data,
  });

  List<DepartmentStatusDetail>? statusDetails;
  DepartmentData? data;

  factory DepartmentList.fromJson(Map<String, dynamic> json) => DepartmentList(
        statusDetails: json["statusDetails"] == null
            ? null
            : List<DepartmentStatusDetail>.from(json["statusDetails"]
                .map((x) => DepartmentStatusDetail.fromJson(x))),
        data:
            json["data"] == null ? null : DepartmentData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "statusDetails": statusDetails == null
            ? null
            : List<dynamic>.from(statusDetails!.map((x) => x.toJson())),
        "data": data == null ? null : data!.toJson(),
      };
}

class DepartmentData {
  DepartmentData({
    this.responseCode,
    this.responseMessage,
    this.result,
  });

  String? responseCode;
  String? responseMessage;
  List<DepartmentItem>? result;

  factory DepartmentData.fromJson(Map<String, dynamic> json) => DepartmentData(
        responseCode:
            json["responseCode"] == null ? null : json["responseCode"],
        responseMessage:
            json["responseMessage"] == null ? null : json["responseMessage"],
        result: json["result"] == null
            ? null
            : List<DepartmentItem>.from(
                json["result"].map((x) => DepartmentItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "responseCode": responseCode == null ? null : responseCode,
        "responseMessage": responseMessage == null ? null : responseMessage,
        "result": result == null
            ? null
            : List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class DepartmentItem {
  DepartmentItem({
    this.id,
    this.name,
  });

  int? id;
  String? name;

  factory DepartmentItem.fromJson(Map<String, dynamic> json) => DepartmentItem(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
      };
}

class DepartmentStatusDetail {
  DepartmentStatusDetail({
    this.code,
    this.message,
  });

  int? code;
  String? message;

  factory DepartmentStatusDetail.fromJson(Map<String, dynamic> json) =>
      DepartmentStatusDetail(
        code: json["code"] == null ? null : json["code"],
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "message": message == null ? null : message,
      };
}
