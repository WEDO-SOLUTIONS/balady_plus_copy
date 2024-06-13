import 'dart:convert';

MyAppointmentsResponse myAppointmentsResponseFromJson(String str) =>
    MyAppointmentsResponse.fromJson(json.decode(str));

String myAppointmentsResponseToJson(MyAppointmentsResponse data) =>
    json.encode(data.toJson());

class MyAppointmentsResponse {
  MyAppointmentsResponse({
    this.statusDetails,
    this.data,
  });

  List<StatusDetail>? statusDetails;
  Data? data;

  factory MyAppointmentsResponse.fromJson(Map<String, dynamic> json) =>
      MyAppointmentsResponse(
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
  List<AppointmentItem>? result;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        responseCode: json["responseCode"],
        responseMessage: json["responseMessage"],
        result: json["result"] == null
            ? null
            : List<AppointmentItem>.from(
                json["result"].map((x) => AppointmentItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "responseCode": responseCode,
        "responseMessage": responseMessage,
        "result": result == null
            ? null
            : List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class AppointmentItem {
  AppointmentItem({
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
    this.cancelable,
    this.printable,
    this.printUrl,
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
  String? statusName;
  bool? cancelable;
  bool? printable;
  dynamic printUrl;
  String? mainClassName;
  String? subClassName;
  String? appointmentDetails;
  dynamic otherValueName;

  factory AppointmentItem.fromJson(Map<String, dynamic> json) =>
      AppointmentItem(
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
        cancelable: json["cancelable"],
        printable: json["printable"],
        printUrl: json["printUrl"],
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
        "cancelable": cancelable,
        "printable": printable,
        "printUrl": printUrl,
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
