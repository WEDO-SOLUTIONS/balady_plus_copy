// To parse this JSON data, do
//
//     final saveAppointmentResponse = saveAppointmentResponseFromJson(jsonString);

import 'dart:convert';

SaveAppointmentResponse saveAppointmentResponseFromJson(String str) =>
    SaveAppointmentResponse.fromJson(json.decode(str));

class SaveAppointmentResponse {
  SaveAppointmentResponse({
    this.statusDetails,
    this.data,
  });

  StatusDetail? statusDetails;
  Data? data;

  factory SaveAppointmentResponse.fromJson(Map<String, dynamic> json) =>
      SaveAppointmentResponse(
        statusDetails: json["statusDetails"] != null
            ? StatusDetail.fromJson(json["statusDetails"])
            : null,
        data: json["data"] != null ? Data.fromJson(json["data"]) : null,
      );
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
        "result": result!.toJson(),
      };
}

class Result {
  Result({
    this.id,
    this.municipalityId,
    this.municipalityName,
    this.subMunicipalityId,
    this.subMunicipalityName,
    this.visitDate,
    this.visitTime,
    this.serviceConfigId,
    this.serviceName,
    this.statusId,
    this.statusName,
    this.visitTopic,
    this.identityNumber,
    this.identityTypeId,
    this.submitterName,
    this.mobileNumber,
    this.cancelable,
    this.printable,
    this.printUrl,
    this.applyMethod,
    this.mainClassification,
    this.subClassification,
    this.departmentName,
    this.visitType,
    this.visitLinked,
    this.prevTrnNo,
    this.specialCondition,
    this.submitterType,
    this.uuid,
    this.mainClassName,
    this.subClassName,
    this.appointmentDetails,
    this.otherValueName,
  });

  int? id;
  String? municipalityId;
  String? municipalityName;
  String? subMunicipalityId;
  String? subMunicipalityName;
  String? visitDate;
  String? visitTime;
  int? serviceConfigId;
  dynamic serviceName;
  int? statusId;
  dynamic statusName;
  dynamic visitTopic;
  String? identityNumber;
  int? identityTypeId;
  String? submitterName;
  String? mobileNumber;
  bool? cancelable;
  bool? printable;
  dynamic printUrl;
  String? applyMethod;
  String? mainClassification;
  dynamic subClassification;
  String? departmentName;
  dynamic visitType;
  bool? visitLinked;
  dynamic prevTrnNo;
  dynamic specialCondition;
  int? submitterType;
  String? uuid;
  String? mainClassName;
  String? subClassName;
  String? appointmentDetails;
  dynamic otherValueName;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        municipalityId: json["municipalityId"],
        municipalityName: json["municipalityName"],
        subMunicipalityId: json["subMunicipalityId"],
        subMunicipalityName: json["subMunicipalityName"],
        visitDate: json["visitDate"],
        visitTime: json["visitTime"],
        serviceConfigId: json["serviceConfigId"],
        serviceName: json["serviceName"],
        statusId: json["statusId"],
        statusName: json["statusName"],
        visitTopic: json["visitTopic"],
        identityNumber: json["identityNumber"],
        identityTypeId: json["identityTypeId"],
        submitterName: json["submitterName"],
        mobileNumber: json["mobileNumber"],
        cancelable: json["cancelable"],
        printable: json["printable"],
        printUrl: json["printUrl"],
        applyMethod: json["applyMethod"],
        mainClassification: json["mainClassification"],
        subClassification: json["subClassification"],
        departmentName: json["departmentName"],
        visitType: json["visitType"],
        visitLinked: json["visitLinked"],
        prevTrnNo: json["prevTrnNo"],
        specialCondition: json["specialCondition"],
        submitterType: json["submitterType"],
        uuid: json["uuid"],
        mainClassName: json["mainClassName"],
        subClassName: json["subClassName"],
        appointmentDetails: json["appointmentDetails"],
        otherValueName: json["otherValueName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "municipalityId": municipalityId,
        "municipalityName": municipalityName,
        "subMunicipalityId": subMunicipalityId,
        "subMunicipalityName": subMunicipalityName,
        "visitDate": visitDate,
        "visitTime": visitTime,
        "serviceConfigId": serviceConfigId,
        "serviceName": serviceName,
        "statusId": statusId,
        "statusName": statusName,
        "visitTopic": visitTopic,
        "identityNumber": identityNumber,
        "identityTypeId": identityTypeId,
        "submitterName": submitterName,
        "mobileNumber": mobileNumber,
        "cancelable": cancelable,
        "printable": printable,
        "printUrl": printUrl,
        "applyMethod": applyMethod,
        "mainClassification": mainClassification,
        "subClassification": subClassification,
        "departmentName": departmentName,
        "visitType": visitType,
        "visitLinked": visitLinked,
        "prevTrnNo": prevTrnNo,
        "specialCondition": specialCondition,
        "submitterType": submitterType,
        "uuid": uuid,
        "mainClassName": mainClassName,
        "subClassName": subClassName,
        "appointmentDetails": appointmentDetails,
        "otherValueName": otherValueName,
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
