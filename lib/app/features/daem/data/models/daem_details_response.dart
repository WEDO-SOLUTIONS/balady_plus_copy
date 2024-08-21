// To parse this JSON data, do
//
//     final daemDetailsResponse = daemDetailsResponseFromJson(jsonString);

import 'dart:convert';

import 'package:intl/intl.dart';

import '../../../../core/services/local/helpers.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

DaemDetailsResponse daemDetailsResponseFromJson(String str) =>
    DaemDetailsResponse.fromJson(json.decode(str));

String daemDetailsResponseToJson(DaemDetailsResponse data) =>
    json.encode(data.toJson());

class DaemDetailsResponse {
  DaemDetailsResponse({
    this.pyId,
    this.daemInformation,
    this.statusAr,
    this.customerInformation,
    this.statusWork,
    this.pzInsKey,
    this.attachmentList,
    this.pyLabel,
    //this.daemHistoryDetails,
    this.errors,
  });

  String? pyId;
  DaemInformation? daemInformation;
  String? statusAr;
  CustomerInformation? customerInformation;
  String? statusWork;
  String? pzInsKey;
  List<AttachmentList>? attachmentList;
  String? pyLabel;
  //List<DaemHistoryDetail>? daemHistoryDetails;
  List<dynamic>? errors;

  factory DaemDetailsResponse.fromJson(Map<String, dynamic> json) =>
      DaemDetailsResponse(
        pyId: json["pyID"],
        daemInformation: json["DaemInformation"] != null
            ? DaemInformation.fromJson(json["DaemInformation"])
            : null,
        statusAr: json["Status_Ar"],
        customerInformation: json["CustomerInformation"] != null
            ? CustomerInformation.fromJson(json["CustomerInformation"])
            : null,
        statusWork: json["StatusWork"],
        pzInsKey: json["pzInsKey"],
        attachmentList: json["AttachmentList"] != null
            ? List<AttachmentList>.from(
                json["AttachmentList"].map((x) => AttachmentList.fromJson(x)))
            : null,
        pyLabel: json["pyLabel"],
        /*daemHistoryDetails: json["DAEMHistoryDetails"] != null
            ? List<DaemHistoryDetail>.from(json["DAEMHistoryDetails"]
                .map((x) => DaemHistoryDetail.fromJson(x)))
            : null,*/
        errors: List<dynamic>.from(json["errors"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "pyID": pyId,
        "DaemInformation": daemInformation!.toJson(),
        "Status_Ar": statusAr,
        "CustomerInformation": customerInformation!.toJson(),
        "StatusWork": statusWork,
        "pzInsKey": pzInsKey,
        "AttachmentList":
            List<dynamic>.from(attachmentList!.map((x) => x.toJson())),
        "pyLabel": pyLabel,
        // "DAEMHistoryDetails":
        //    List<dynamic>.from(daemHistoryDetails!.map((x) => x.toJson())),
        "errors": List<dynamic>.from(errors!.map((x) => x)),
      };
//  List<DaemHistoryDetail> get getDaemHistoryDetails =>
  //    daemHistoryDetails?.reversed.toList() ?? [];
}

class AttachmentList {
  AttachmentList({
    this.pyCategory,
    this.pyId,
    this.pzInsKey,
    this.pyLabel,
    this.pyMemo,
  });

  String? pyCategory;
  String? pyId;
  String? pzInsKey;
  String? pyLabel;
  String? pyMemo;

  factory AttachmentList.fromJson(Map<String, dynamic> json) => AttachmentList(
        pyCategory: json["pyCategory"],
        pyId: json["pyID"],
        pzInsKey: json["pzInsKey"],
        pyLabel: json["pyLabel"],
        pyMemo: json["pyMemo"],
      );

  Map<String, dynamic> toJson() => {
        "pyCategory": pyCategory,
        "pyID": pyId,
        "pzInsKey": pzInsKey,
        "pyLabel": pyLabel,
        "pyMemo": pyMemo,
      };
}

class CustomerInformation {
  CustomerInformation({
    this.mobileNumber,
    this.fullName,
    this.iqamaId,
    this.emailAddress,
  });

  String? mobileNumber;
  String? fullName;
  String? iqamaId;
  String? emailAddress;

  factory CustomerInformation.fromJson(Map<String, dynamic> json) =>
      CustomerInformation(
        mobileNumber: json["MobileNumber"],
        fullName: json["FullName"],
        iqamaId: json["IqamaID"],
        emailAddress: json["EmailAddress"],
      );

  Map<String, dynamic> toJson() => {
        "MobileNumber": mobileNumber,
        "FullName": fullName,
        "IqamaID": iqamaId,
        "EmailAddress": emailAddress,
      };
}

class DaemHistoryDetail {
  DaemHistoryDetail({
    this.userComments,
    this.statusAr,
    this.incidentStatus,
    this.incidentId,
    this.recordInsertDateTime,
  });

  String? userComments;
  String? statusAr;
  String? incidentStatus;
  String? incidentId;
  String? recordInsertDateTime;

  factory DaemHistoryDetail.fromJson(Map<String, dynamic> json) =>
      DaemHistoryDetail(
        userComments: json["UserComments"],
        statusAr: json["Status_Ar"],
        incidentStatus: json["IncidentStatus"],
        incidentId: json["IncidentID"],
        recordInsertDateTime: json["RecordInsertDateTime"],
      );

  Map<String, dynamic> toJson() => {
        "UserComments": userComments,
        "Status_Ar": statusAr,
        "IncidentStatus": incidentStatus,
        "IncidentID": incidentId,
        "RecordInsertDateTime": recordInsertDateTime,
      };

  String getDate() {
    DateTime? dateTime;
    try {
      if (recordInsertDateTime != null && recordInsertDateTime!.isNotEmpty) {
        String dateWithT = recordInsertDateTime!.substring(0, 15) + "z";

        dateTime = DateTime.parse(dateWithT).toLocal();
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      String dateWithT =
          recordInsertDateTime!.substring(0, 8); //+ 'T' + date.substring(8);
      dateTime = DateTime.parse(dateWithT);
    }

    return dateTime != null
        ? Helpers.changeToEnglish(DateFormat.yMMMd('ar').format(dateTime))
        : " ";
  }
}

class DaemInformation {
  DaemInformation(
      {this.incidentDescription,
      this.area,
      this.category,
      this.issueType,
      this.subCategory,
      this.baladiah,
      this.location,
      this.baladiahAR,
      this.categoryAR,
      this.locationAR,
      this.lastUserComment});

  String? incidentDescription;
  String? area;
  String? category;
  String? issueType;
  String? subCategory;
  String? baladiah;
  String? location;
  String? categoryAR;
  String? baladiahAR;
  String? locationAR;
  String? lastUserComment;

  factory DaemInformation.fromJson(Map<String, dynamic> json) =>
      DaemInformation(
          incidentDescription: json["IncidentDescription"],
          area: json["Area"],
          category: json["Category"],
          issueType: json["IssueType"],
          subCategory: json["SubCategory"],
          baladiah: json["Baladiah"],
          location: json["Location"],
          baladiahAR: json["BaladiahAR"],
          categoryAR: json["CategoryAR"],
          locationAR: json["LocationAR"],
          lastUserComment: json["LastUserComment"]);

  Map<String, dynamic> toJson() => {
        "IncidentDescription": incidentDescription,
        "Area": area,
        "Category": category,
        "IssueType": issueType,
        "SubCategory": subCategory,
        "Baladiah": baladiah,
        "Location": location,
        "BaladiahAR": baladiahAR,
        "CategoryAR": categoryAR,
        "LocationAR": locationAR,
        "LastUserComment": lastUserComment
      };

  String getLastUserComment() {
    return lastUserComment ?? "";
  }
}
