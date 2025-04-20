// To parse this JSON data, do
//
//     final appointmentDetails = appointmentDetailsFromJson(jsonString);

import 'dart:convert';

AppointmentDetails appointmentDetailsFromJson(String str) =>
    AppointmentDetails.fromJson(json.decode(str));

class AppointmentDetails {
  AppointmentDetails({
    this.statusDetails,
    this.data,
  });

  StatusDetail? statusDetails;
  Data? data;

  factory AppointmentDetails.fromJson(Map<String, dynamic> json) =>
      AppointmentDetails(
        statusDetails: json["statusDetails"] == null
            ? null
            : StatusDetail.fromJson(json["statusDetails"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
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
  AppointmentItemInfo? result;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        responseCode:
            json["responseCode"] == null ? null : json["responseCode"],
        responseMessage:
            json["responseMessage"] == null ? null : json["responseMessage"],
        result: json["result"] == null
            ? null
            : AppointmentItemInfo.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "responseCode": responseCode == null ? null : responseCode,
        "responseMessage": responseMessage == null ? null : responseMessage,
        "result": result == null ? null : result!.toJson(),
      };
}

class AppointmentItemInfo {
  AppointmentItemInfo(
      {this.id,
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
      this.editable,
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
      this.confirmable,
      this.subClassId,
      this.mainClassId,
      this.attachments,
      this.serviceCategoryId,
      this.serviceCategoryName,
      this.specialConditionId,
      this.specialConditionName,
      this.visitTypeId,
      this.visitTypeName,
      this.realEstateSurveyId,
      this.realEstateId,
      this.realEstateRequestId,
      this.existedWakeelVisit = false,
      this.accepted_agreement = false,
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
  String? statusName;
  dynamic visitTopic;
  String? identityNumber;
  int? identityTypeId;
  String? submitterName;
  String? mobileNumber;
  bool? cancelable;
  bool? printable;
  bool? editable;
  dynamic printUrl;
  String? applyMethod;
  String? mainClassification;
  dynamic subClassification;
  String? departmentName;
  String? visitType;
  bool? visitLinked;
  dynamic prevTrnNo;
  dynamic specialCondition;
  int? submitterType;
  String? uuid;
  String? mainClassName;
  String? subClassName;
  String? appointmentDetails;
  dynamic otherValueName;
  bool? confirmable;
  int? mainClassId;
  int? subClassId;
  List<Attachment>? attachments;
  int? serviceCategoryId;
  String? serviceCategoryName;
  int? specialConditionId;
  String? specialConditionName;

  int? visitTypeId;
  String? visitTypeName;

  String? realEstateSurveyId;
  String? realEstateId;
  String? realEstateRequestId;
  bool? existedWakeelVisit;
  bool? accepted_agreement;

  

  String getFormattedVisitDate() {
    String originalDateString = visitDate ?? "";
    String formattedDate = "";
    if (originalDateString.isNotEmpty) {
      // Convert the format to "yyyy-MM-dd" before parsing
      originalDateString = originalDateString.replaceAll('/', '-');

      DateTime originalDate = DateTime.parse(originalDateString);

      // Format the date in the desired format
      formattedDate = "${originalDate.day.toString().padLeft(2, '0')}-"
          "${originalDate.month.toString().padLeft(2, '0')}-"
          "${originalDate.year}";
    }
    return formattedDate;
  }

  factory AppointmentItemInfo.fromJson(Map<String, dynamic> json) {
    return AppointmentItemInfo(
      serviceCategoryId: json["serviceCategoryId"],
      serviceCategoryName: json["serviceCategoryName"],
      subClassId: json["subClassId"],
      mainClassId: json["mainClassId"],
      id: json["id"] == null ? null : json["id"],
      municipalityId:
          json["municipalityId"] == null ? null : json["municipalityId"],
      municipalityName:
          json["municipalityName"] == null ? null : json["municipalityName"],
      subMunicipalityId:
          json["subMunicipalityId"] == null ? null : json["subMunicipalityId"],
      subMunicipalityName: json["subMunicipalityName"] == null
          ? null
          : json["subMunicipalityName"],
      visitDate: json["visitDate"] == null ? null : json["visitDate"],
      visitTime: json["visitTime"] == null ? null : json["visitTime"],
      serviceConfigId:
          json["serviceConfigId"] == null ? null : json["serviceConfigId"],
      serviceName: json["serviceName"],
      statusId: json["statusId"] == null ? null : json["statusId"],
      statusName: json["statusName"] == null ? null : json["statusName"],
      visitTopic: json["visitTopic"],
      identityNumber:
          json["identityNumber"] == null ? null : json["identityNumber"],
      identityTypeId:
          json["identityTypeId"] == null ? null : json["identityTypeId"],
      submitterName:
          json["submitterName"] == null ? null : json["submitterName"],
      mobileNumber: json["mobileNumber"] == null ? null : json["mobileNumber"],
      cancelable: json["cancelable"] == null ? null : json["cancelable"],
      printable: json["printable"] == null ? null : json["printable"],
      editable: json["editable"],
      printUrl: json["printUrl"],
      applyMethod: json["applyMethod"] == null ? null : json["applyMethod"],
      mainClassification: json["mainClassification"] == null
          ? null
          : json["mainClassification"],
      subClassification: json["subClassification"],
      departmentName:
          json["departmentName"] == null ? null : json["departmentName"],
      visitType: json["visitType"] == null ? null : json["visitType"],
      visitLinked: json["visitLinked"] == null ? null : json["visitLinked"],
      prevTrnNo: json["prevTrnNo"],
      specialCondition: json["specialCondition"],
      submitterType:
          json["submitterType"] == null ? null : json["submitterType"],
      uuid: json["uuid"] == null ? null : json["uuid"],
      mainClassName:
          json["mainClassName"] == null ? null : json["mainClassName"],
      subClassName: json["subClassName"] == null ? null : json["subClassName"],
      appointmentDetails: json["appointmentDetails"] == null
          ? null
          : json["appointmentDetails"],
      otherValueName: json["otherValueName"],
      confirmable: json["confirmable"],
      specialConditionId: json["specialConditionId"],
      specialConditionName: json["specialConditionName"],
      visitTypeId: json["visitTypeId"],
      visitTypeName: json["visitTypeName"],
      realEstateSurveyId: json["realEstateSurveyId"],
      realEstateId: json["realEstateId"],
      realEstateRequestId: json["realEstateRequestId"],
      existedWakeelVisit: json["existedWakeelVisit"] ,
      accepted_agreement: json["accepted_agreement"],
      attachments: json["attachments"] == null
          ? []
          : List<Attachment>.from(
              json["attachments"]!.map((x) => Attachment.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "municipalityId": municipalityId == null ? null : municipalityId,
        "municipalityName": municipalityName == null ? null : municipalityName,
        "subMunicipalityId":
            subMunicipalityId == null ? null : subMunicipalityId,
        "subMunicipalityName":
            subMunicipalityName == null ? null : subMunicipalityName,
        "visitDate": visitDate == null ? null : visitDate,
        "visitTime": visitTime == null ? null : visitTime,
        "serviceConfigId": serviceConfigId == null ? null : serviceConfigId,
        "serviceName": serviceName,
        "statusId": statusId == null ? null : statusId,
        "statusName": statusName == null ? null : statusName,
        "visitTopic": visitTopic,
        "identityNumber": identityNumber == null ? null : identityNumber,
        "identityTypeId": identityTypeId == null ? null : identityTypeId,
        "submitterName": submitterName == null ? null : submitterName,
        "mobileNumber": mobileNumber == null ? null : mobileNumber,
        "cancelable": cancelable == null ? null : cancelable,
        "printable": printable == null ? null : printable,
        "printUrl": printUrl,
        "applyMethod": applyMethod == null ? null : applyMethod,
        "mainClassification":
            mainClassification == null ? null : mainClassification,
        "subClassification": subClassification,
        "departmentName": departmentName == null ? null : departmentName,
        "visitType": visitType == null ? null : visitType,
        "visitLinked": visitLinked == null ? null : visitLinked,
        "prevTrnNo": prevTrnNo,
        "specialCondition": specialCondition,
        "submitterType": submitterType == null ? null : submitterType,
        "uuid": uuid == null ? null : uuid,
        "mainClassName": mainClassName == null ? null : mainClassName,
        "subClassName": subClassName == null ? null : subClassName,
        "appointmentDetails":
            appointmentDetails == null ? null : appointmentDetails,
        "otherValueName": otherValueName,
        "confirmable": confirmable
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
        code: json["code"] == null ? null : json["code"],
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "message": message == null ? null : message,
      };
}

class Attachment {
  final int? id;
  final String? uuid;
  final String? name;
  final String? allowedFilesExtension;
  final bool? attached;
  final bool? approved;
  final String? attachUrl;
  final dynamic notes;
  final bool? updatable;
  final int? maxSize;
  final bool? mandatory;

  Attachment({
    this.id,
    this.uuid,
    this.name,
    this.allowedFilesExtension,
    this.attached,
    this.approved,
    this.attachUrl,
    this.notes,
    this.updatable = true,
    this.maxSize,
    this.mandatory,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
        id: json["id"],
        uuid: json["uuid"],
        name: json["name"],
        allowedFilesExtension: json["allowedFilesExtension"],
        attached: json["attached"],
        approved: json["approved"],
        attachUrl: json["attachUrl"],
        notes: json["notes"],
        updatable: json["updatable"],
        maxSize: json["maxSize"],
        mandatory: json["mandatory"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uuid": uuid,
        "name": name,
        "allowedFilesExtension": allowedFilesExtension,
        "attached": attached,
        "approved": approved,
        "attachUrl": attachUrl,
        "notes": notes,
        "updatable": updatable,
        "maxSize": maxSize,
        "mandatory": mandatory,
      };
}
