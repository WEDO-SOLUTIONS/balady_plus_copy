// To parse this JSON data, do
//
//     final serviceConfigResponse = serviceConfigResponseFromJson(jsonString);

import 'dart:convert';

ServiceConfigResponse serviceConfigResponseFromJson(String str) =>
    ServiceConfigResponse.fromJson(json.decode(str));

String serviceConfigResponseToJson(ServiceConfigResponse data) =>
    json.encode(data.toJson());

class ServiceConfigResponse {
  ServiceConfigResponse({
    this.statusDetails,
    this.data,
  });

  StatusDetail? statusDetails;
  Data? data;

  factory ServiceConfigResponse.fromJson(Map<String, dynamic> json) =>
      ServiceConfigResponse(
        statusDetails: json["statusDetails"] == null
            ? null
            : StatusDetail.fromJson(json["statusDetails"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "statusDetails": statusDetails?.toJson(),
        "data": data?.toJson(),
      };

  int? getServiceId() {
    return data?.result?[0].id;
  }

  String? getDepartmentName() {
    return data?.result?[0].departmentName;
  }
}

class Data {
  Data({
    this.responseCode,
    this.responseMessage,
    this.result,
  });

  String? responseCode;
  String? responseMessage;
  List<ServiceConfigItem>? result;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        responseCode: json["responseCode"],
        responseMessage: json["responseMessage"],
        result: json["result"] != null
            ? List<ServiceConfigItem>.from(
                json["result"].map((x) => ServiceConfigItem.fromJson(x)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "responseCode": responseCode,
        "responseMessage": responseMessage,
        "result": List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class ServiceConfigItem {
  ServiceConfigItem(
      {this.id,
      this.name,
      this.applyMethod,
      this.mainClassificationId,
      this.mainClassification,
      this.subClassification,
      this.departmentId,
      this.departmentName,
      this.allowDepartmentList,
      this.allowAddTopic,
      this.visitType,
      this.realEstate,
      this.commitmentable,
      this.askForWakeelVisit,
      this.prevTransNoRequired,
      this.attachmentsConfig});

  int? id;
  dynamic name;
  String? applyMethod;
  int? mainClassificationId;
  String? mainClassification;
  dynamic subClassification;
  int? departmentId;
  String? departmentName;
  bool? allowDepartmentList;
  bool? allowAddTopic;
  bool? realEstate;
  bool? commitmentable;
  bool? askForWakeelVisit;
  bool? prevTransNoRequired;
  List<VisitType>? visitType;
  List<AttachmentsConfig>? attachmentsConfig;

  factory ServiceConfigItem.fromJson(Map<String, dynamic> json) =>
      ServiceConfigItem(
        id: json["id"],
        name: json["name"],
        applyMethod: json["applyMethod"],
        mainClassificationId: json["mainClassificationId"],
        mainClassification: json["mainClassification"],
        subClassification: json["subClassification"],
        departmentId: json["departmentId"],
        departmentName: json["departmentName"],
        allowDepartmentList: json["allowDepartmentList"],
        allowAddTopic: json["allowAddTopic"],
        realEstate: json["realEstate"],
        commitmentable: json["commitmentable"],
        askForWakeelVisit: json["askForWakeelVisit"],
        prevTransNoRequired: json["prevTransNoRequired"],
        visitType: json["visitType"] != null
            ? List<VisitType>.from(
                json["visitType"].map((x) => VisitType.fromJson(x)))
            : null,
        attachmentsConfig: json["attachmentsConfig"] != null
            ? List<AttachmentsConfig>.from(json["attachmentsConfig"]
                .map((x) => AttachmentsConfig.fromJson(x)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "applyMethod": applyMethod,
        "mainClassificationId": mainClassificationId,
        "mainClassification": mainClassification,
        "subClassification": subClassification,
        "departmentId": departmentId,
        "departmentName": departmentName,
        "allowDepartmentList": allowDepartmentList,
        "allowAddTopic": allowAddTopic,
        "visitType": List<dynamic>.from(visitType!.map((x) => x.toJson())),
        "attachmentsConfig":
            List<dynamic>.from(attachmentsConfig!.map((x) => x.toJson())),
      };
}

class VisitType {
  VisitType({
    this.id,
    this.name,
  });

  int? id;
  String? name;

  factory VisitType.fromJson(Map<String, dynamic> json) => VisitType(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class AttachmentsConfig {
  AttachmentsConfig(
      {this.id,
      this.uuid,
      this.name,
      this.allowedFilesExtension,
      this.mandatory,
      this.maxSize});

  int? id;
  int? maxSize;
  String? uuid;
  String? name;
  String? allowedFilesExtension;
  bool? mandatory;
  factory AttachmentsConfig.fromJson(Map<String, dynamic> json) =>
      AttachmentsConfig(
        id: json["id"],
        uuid: json["uuid"],
        name: json["name"],
        maxSize: json["maxSize"],
        allowedFilesExtension: json["allowedFilesExtension"],
        mandatory: json["mandatory"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "uuid": uuid,
        "maxSize": maxSize,
        "allowedFilesExtension": allowedFilesExtension,
        "mandatory": mandatory,
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
