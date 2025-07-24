// To parse this JSON data, do
//
//     final submitRatingRequest = submitRatingRequestFromJson(jsonString);

import 'dart:convert';

SubmitRatingRequest submitRatingRequestFromJson(String str) =>
    SubmitRatingRequest.fromJson(json.decode(str));

String submitRatingRequestToJson(SubmitRatingRequest data) =>
    json.encode(data.toJson());

class SubmitRatingRequest {
  final String? selfEvaluationType;
  final String? businessActivityId;
  final String? municipalityId;
  final String? subMunicipalityId;
  final int? licenseNumber;
  final List<InspectionSubClausesList>? inspectionSubClausesList;

  SubmitRatingRequest(
      {this.selfEvaluationType,
      this.businessActivityId,
      this.municipalityId,
      this.subMunicipalityId,
      this.inspectionSubClausesList,
      this.licenseNumber});

  SubmitRatingRequest copyWith({
    String? selfEvaluationType,
    String? businessActivityId,
    String? municipalityId,
    String? subMunicipalityId,
    int? licenseNumber,
    List<InspectionSubClausesList>? inspectionSubClausesList,
  }) =>
      SubmitRatingRequest(
          selfEvaluationType: selfEvaluationType ?? this.selfEvaluationType,
          businessActivityId: businessActivityId ?? this.businessActivityId,
          municipalityId: municipalityId ?? this.municipalityId,
          subMunicipalityId: subMunicipalityId ?? this.subMunicipalityId,
          inspectionSubClausesList:
              inspectionSubClausesList ?? this.inspectionSubClausesList,
          licenseNumber: licenseNumber ?? this.licenseNumber);

  factory SubmitRatingRequest.fromJson(Map<String, dynamic> json) =>
      SubmitRatingRequest(
        selfEvaluationType: json["SelfEvaluationType"],
        businessActivityId: json["BusinessActivityID"],
        municipalityId: json["MunicipalityID"],
        subMunicipalityId: json["SubMunicipalityID"],
        inspectionSubClausesList: json["InspectionSubClausesList"] == null
            ? []
            : List<InspectionSubClausesList>.from(
                json["InspectionSubClausesList"]!
                    .map((x) => InspectionSubClausesList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "LicenseNumber": licenseNumber,
        "SelfEvaluationType": selfEvaluationType,
        "BusinessActivityID": businessActivityId,
        "MunicipalityID": municipalityId,
        "SubMunicipalityID": subMunicipalityId,
        "InspectionSubClausesList": inspectionSubClausesList == null
            ? []
            : List<dynamic>.from(
                inspectionSubClausesList!.map((x) => x.toJson())),
      };
}

class InspectionSubClausesList {
  final dynamic nonComplianceReasonList;
  final String? subClauseNo;
  final String? inspectionTypeNo;
  final String? subClauseName;
  final String? clauseNo;
  final String? clauseName;
  final dynamic commentForNonCompliance;
  final int? complianceStatus;

  InspectionSubClausesList({
    this.nonComplianceReasonList,
    this.subClauseNo,
    this.inspectionTypeNo,
    this.subClauseName,
    this.clauseNo,
    this.clauseName,
    this.commentForNonCompliance,
    this.complianceStatus,
  });

  InspectionSubClausesList copyWith({
    dynamic nonComplianceReasonList,
    String? subClauseNo,
    String? inspectionTypeNo,
    String? subClauseName,
    String? clauseNo,
    String? clauseName,
    dynamic commentForNonCompliance,
    int? complianceStatus,
  }) =>
      InspectionSubClausesList(
        nonComplianceReasonList:
            nonComplianceReasonList ?? this.nonComplianceReasonList,
        subClauseNo: subClauseNo ?? this.subClauseNo,
        inspectionTypeNo: inspectionTypeNo ?? this.inspectionTypeNo,
        subClauseName: subClauseName ?? this.subClauseName,
        clauseNo: clauseNo ?? this.clauseNo,
        clauseName: clauseName ?? this.clauseName,
        commentForNonCompliance:
            commentForNonCompliance ?? this.commentForNonCompliance,
        complianceStatus: complianceStatus ?? this.complianceStatus,
      );

  factory InspectionSubClausesList.fromJson(Map<String, dynamic> json) =>
      InspectionSubClausesList(
        nonComplianceReasonList: json["NonComplianceReasonList"],
        subClauseNo: json["SubClauseNo"],
        inspectionTypeNo: json["InspectionTypeNo"],
        subClauseName: json["SubClauseName"],
        clauseNo: json["ClauseNo"],
        clauseName: json["ClauseName"],
        commentForNonCompliance: json["CommentForNonCompliance"],
        complianceStatus: json["ComplianceStatus"],
      );

  Map<String, dynamic> toJson() => {
        "NonComplianceReasonList": nonComplianceReasonList,
        "SubClauseNo": subClauseNo,
        "InspectionTypeNo": inspectionTypeNo,
        //  "SubClauseName": subClauseName?.replaceAll("/", "").replaceAll("&", ""),
        "ClauseNo": clauseNo,
        "ClauseName": clauseName,
        "CommentForNonCompliance": commentForNonCompliance,
        "ComplianceStatus": complianceStatus,
      };

  String getClausesName() => clauseName?.trim() ?? "";
}
