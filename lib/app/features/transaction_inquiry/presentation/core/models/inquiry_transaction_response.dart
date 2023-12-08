// To parse this JSON data, do
//
//     final inquiryTransactionResponse = inquiryTransactionResponseFromJson(jsonString);

import 'dart:convert';

InquiryTransactionResponse inquiryTransactionResponseFromJson(String str) =>
    InquiryTransactionResponse.fromJson(json.decode(str));

String inquiryTransactionResponseToJson(InquiryTransactionResponse data) =>
    json.encode(data.toJson());

class InquiryTransactionResponse {
  InquiryTransactionResponse({
    this.statusDetails,
    this.data,
  });

  List<StatusDetail>? statusDetails;
  Data? data;

  factory InquiryTransactionResponse.fromJson(Map<String, dynamic> json) =>
      InquiryTransactionResponse(
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
  List<Result>? result;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
      responseCode: json["responseCode"] == null ? null : json["responseCode"],
      responseMessage:
          json["responseMessage"] == null ? null : json["responseMessage"],
      result: json["result"] != null && json["result"].length > 0
          ? List<Result>.from(json["result"].map((x) => Result.fromJson(x)))
          : null);

  Map<String, dynamic> toJson() => {
        "responseCode": responseCode == null ? null : responseCode,
        "responseMessage": responseMessage == null ? null : responseMessage,
        "result": result == null
            ? null
            : List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class Result {
  Result({
    this.folderId,
    this.type,
    this.typeAr,
    this.subject,
    this.referenceNumber,
    this.note,
    this.creationDate,
    this.creationDateHijri,
    this.privacy,
    this.priority,
    this.attachmentDescription,
    this.nationalId,
    this.phoneNumber,
    this.eXternalReference,
    this.eXternalRefDate,
    this.eXternalRefDateHijri,
    this.source,
    this.agency,
    this.branchname,
    this.target,
    this.transferFromDeptAr,
    this.transferToDeptAr,
    this.transferFromAr,
    this.transferToAr,
    this.registeredBy,
    this.status,
    this.outgoingNumber,
    this.finalDestination,
    this.transfers,
  });

  String? folderId;
  String? type;
  dynamic typeAr;
  String? subject;
  String? referenceNumber;
  dynamic note;
  String? creationDate;
  String? creationDateHijri;
  String? privacy;
  String? priority;
  dynamic attachmentDescription;
  dynamic nationalId;
  String? phoneNumber;
  String? eXternalReference;
  String? eXternalRefDate;
  String? eXternalRefDateHijri;
  String? source;
  dynamic agency;
  dynamic branchname;
  dynamic target;
  dynamic transferFromDeptAr;
  dynamic transferToDeptAr;
  dynamic transferFromAr;
  dynamic transferToAr;
  dynamic registeredBy;
  String? status;
  dynamic outgoingNumber;
  String? finalDestination;
  List<Transfer>? transfers;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        folderId: json["folder_Id"] == null ? null : json["folder_Id"],
        type: json["type"] == null ? null : json["type"],
        typeAr: json["type_ar"],
        subject: json["subject"] == null ? null : json["subject"],
        referenceNumber:
            json["reference_Number"] == null ? null : json["reference_Number"],
        note: json["note"],
        creationDate:
            json["creation_Date"] == null ? null : json["creation_Date"],
        creationDateHijri: json["creation_Date_Hijri"] == null
            ? null
            : json["creation_Date_Hijri"],
        privacy: json["privacy"] == null ? null : json["privacy"],
        priority: json["priority"] == null ? null : json["priority"],
        attachmentDescription: json["attachment_Description"],
        nationalId: json["national_Id"],
        phoneNumber: json["phone_Number"] == null ? null : json["phone_Number"],
        eXternalReference: json["eXTERNAL_REFERENCE"] == null
            ? null
            : json["eXTERNAL_REFERENCE"],
        eXternalRefDate: json["eXTERNAL_REF_DATE"] == null
            ? null
            : json["eXTERNAL_REF_DATE"],
        eXternalRefDateHijri: json["eXTERNAL_REF_DATE_HIJRI"] == null
            ? null
            : json["eXTERNAL_REF_DATE_HIJRI"],
        source: json["source"] == null ? null : json["source"],
        agency: json["agency"],
        branchname: json["branchname"],
        target: json["target"],
        transferFromDeptAr: json["transfer_from_dept_AR"],
        transferToDeptAr: json["transfer_To_dept_AR"],
        transferFromAr: json["transfer_from_AR"],
        transferToAr: json["transfer_To__AR"],
        registeredBy: json["registered_By"],
        status: json["status"] == null ? null : json["status"],
        outgoingNumber: json["outgoing_number"],
        finalDestination: json["final_destination"] == null
            ? null
            : json["final_destination"],
        transfers: json["Transfers"] == null
            ? null
            : List<Transfer>.from(
                json["Transfers"].map((x) => Transfer.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "folder_Id": folderId == null ? null : folderId,
        "type": type == null ? null : type,
        "type_ar": typeAr,
        "subject": subject == null ? null : subject,
        "reference_Number": referenceNumber == null ? null : referenceNumber,
        "note": note,
        "creation_Date": creationDate == null ? null : creationDate,
        "creation_Date_Hijri":
            creationDateHijri == null ? null : creationDateHijri,
        "privacy": privacy == null ? null : privacy,
        "priority": priority == null ? null : priority,
        "attachment_Description": attachmentDescription,
        "national_Id": nationalId,
        "phone_Number": phoneNumber == null ? null : phoneNumber,
        "eXTERNAL_REFERENCE":
            eXternalReference == null ? null : eXternalReference,
        "eXTERNAL_REF_DATE": eXternalRefDate == null ? null : eXternalRefDate,
        "eXTERNAL_REF_DATE_HIJRI":
            eXternalRefDateHijri == null ? null : eXternalRefDateHijri,
        "source": source == null ? null : source,
        "agency": agency,
        "branchname": branchname,
        "target": target,
        "transfer_from_dept_AR": transferFromDeptAr,
        "transfer_To_dept_AR": transferToDeptAr,
        "transfer_from_AR": transferFromAr,
        "transfer_To__AR": transferToAr,
        "registered_By": registeredBy,
        "status": status == null ? null : status,
        "outgoing_number": outgoingNumber,
        "final_destination": finalDestination == null ? null : finalDestination,
        "Transfers": transfers == null
            ? null
            : List<dynamic>.from(transfers!.map((x) => x.toJson())),
      };
}

class Transfer {
  Transfer({
    this.transferId,
    this.transferType,
    this.transferFromDept,
    this.transferToDept,
    this.transferSubject,
    this.transferStatus,
    this.accepted,
    this.parentTransfer,
    this.transferFrom,
    this.transferTo,
    this.transferDate,
    this.transferHijriDate,
    this.externalReference,
  });

  String? transferId;
  String? transferType;
  String? transferFromDept;
  String? transferToDept;
  dynamic transferSubject;
  String? transferStatus;
  String? accepted;
  dynamic parentTransfer;
  String? transferFrom;
  String? transferTo;
  String? transferDate;
  String? transferHijriDate;
  dynamic externalReference;

  factory Transfer.fromJson(Map<String, dynamic> json) => Transfer(
        transferId: json["transfer_Id"] == null ? null : json["transfer_Id"],
        transferType:
            json["TRANSFER_TYPE"] == null ? null : json["TRANSFER_TYPE"],
        transferFromDept: json["TRANSFER_FROM_DEPT"] == null
            ? null
            : json["TRANSFER_FROM_DEPT"],
        transferToDept:
            json["TRANSFER_TO_DEPT"] == null ? null : json["TRANSFER_TO_DEPT"],
        transferSubject: json["TRANSFER_SUBJECT"],
        transferStatus:
            json["TRANSFER_STATUS"] == null ? null : json["TRANSFER_STATUS"],
        accepted: json["ACCEPTED"] == null ? null : json["ACCEPTED"],
        parentTransfer: json["PARENT_TRANSFER"],
        transferFrom:
            json["TRANSFER_FROM"] == null ? null : json["TRANSFER_FROM"],
        transferTo: json["TRANSFER_TO"] == null ? null : json["TRANSFER_TO"],
        transferDate:
            json["TRANSFER_DATE"] == null ? null : json["TRANSFER_DATE"],
        transferHijriDate: json["TRANSFER_HIJRI_DATE"] == null
            ? null
            : json["TRANSFER_HIJRI_DATE"],
        externalReference: json["EXTERNAL_REFERENCE"],
      );

  Map<String, dynamic> toJson() => {
        "transfer_Id": transferId == null ? null : transferId,
        "TRANSFER_TYPE": transferType == null ? null : transferType,
        "TRANSFER_FROM_DEPT":
            transferFromDept == null ? null : transferFromDept,
        "TRANSFER_TO_DEPT": transferToDept == null ? null : transferToDept,
        "TRANSFER_SUBJECT": transferSubject,
        "TRANSFER_STATUS": transferStatus == null ? null : transferStatus,
        "ACCEPTED": accepted == null ? null : accepted,
        "PARENT_TRANSFER": parentTransfer,
        "TRANSFER_FROM": transferFrom == null ? null : transferFrom,
        "TRANSFER_TO": transferTo == null ? null : transferTo,
        "TRANSFER_DATE": transferDate == null ? null : transferDate,
        "TRANSFER_HIJRI_DATE":
            transferHijriDate == null ? null : transferHijriDate,
        "EXTERNAL_REFERENCE": externalReference,
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
