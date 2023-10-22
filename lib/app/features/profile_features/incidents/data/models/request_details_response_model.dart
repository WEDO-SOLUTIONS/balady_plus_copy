// To parse this JSON data, do
//
//     final crmRequestDetails = crmRequestDetailsFromJson(jsonString);

import 'dart:convert';

import 'package:balady_plus/app/features/profile_features/incidents/data/models/request_details_response.dart'
    show AuditInformation, Comments;

import '../../domain/entities/request_details_response.dart';

class CrmRequestDetailsModel extends CrmRequestDetails {
  CrmRequestDetailsModel(
      {super.auditInformation,
      super.customerInformation,
      super.vehicleInformation,
      super.pzInsKey,
      super.caseDeadline,
      super.locationInfo,
      super.pyId,
      super.incidentInformation,
      super.statusAr,
      super.statusWork,
      super.caseGoal,
      super.escalationRequestList,
      super.attachmentList,
      super.pyLabel,
      super.errors,
      super.amanaIncidentId,
      super.comments});

  factory CrmRequestDetailsModel.fromJson(Map<String, dynamic> json) {
    return CrmRequestDetailsModel(
        auditInformation: json["AuditInformation"] == null
            ? null
            : AuditInformation.fromJson(json["AuditInformation"]),
        customerInformation: json["CustomerInformation"] == null
            ? null
            : CustomerInformationModel.fromJson(json["CustomerInformation"]),
        vehicleInformation: json["VehicleInformation"] == null
            ? null
            : VehicleInformationModel.fromJson(json["VehicleInformation"]),
        pzInsKey: json["pzInsKey"],
        caseDeadline: json["CaseDeadline"],
        locationInfo: json["LocationInfo"] == null
            ? null
            : LocationInfoModel.fromJson(json["LocationInfo"]),
        pyId: json["pyID"],
        incidentInformation: json["IncidentInformation"] == null
            ? null
            : IncidentInformationModel.fromJson(json["IncidentInformation"]),
        statusAr: json["Status_Ar"],
        statusWork: json["StatusWork"],
        caseGoal: json["CaseGoal"],
        attachmentList: json["AttachmentList"] == null
            ? []
            : List<AttachmentListModel>.from(json["AttachmentList"]!
                .map((x) => AttachmentListModel.fromJson(x))),
        pyLabel: json["pyLabel"],
        errors: json["errors"] == null
            ? []
            : List<dynamic>.from(json["errors"]!.map((x) => x)),
        amanaIncidentId: json["AmanaIncidentID"],
        comments: json["CommentList"] != null
            ? List<CommentsModel>.from(
                json["CommentList"].map((x) => CommentsModel.fromJson(x)))
            : []);
  }
}

class AttachmentListModel extends AttachmentList {
  AttachmentListModel({
    super.pyCategory,
    super.pyId,
    super.pzInsKey,
    super.pyLabel,
    super.pxCreateOpName,
    super.pyMemo,
  });

  factory AttachmentListModel.fromJson(Map<String, dynamic> json) =>
      AttachmentListModel(
        pyCategory: json["pyCategory"],
        pyId: json["pyID"],
        pzInsKey: json["pzInsKey"],
        pyLabel: json["pyLabel"],
        pxCreateOpName: json["pxCreateOpName"],
        pyMemo: json["pyMemo"],
      );
}

class CustomerInformationModel extends CustomerInformation {
  CustomerInformationModel({
    super.dateOfBirth,
    super.mobileNumber,
    super.firstName,
    super.nationalId,
    super.preferredLanguage,
    super.lastName,
    super.iqamaId,
    super.middleName,
    super.emailAddress,
  });

  factory CustomerInformationModel.fromJson(Map<String, dynamic> json) =>
      CustomerInformationModel(
        dateOfBirth: json["DateOfBirth"],
        mobileNumber: json["MobileNumber"],
        firstName: json["FirstName"],
        nationalId: json["NationalID"],
        preferredLanguage: json["PreferredLanguage"],
        lastName: json["LastName"],
        iqamaId: json["IqamaID"],
        middleName: json["MiddleName"],
        emailAddress: json["EmailAddress"],
      );
}

class IncidentInformationModel extends IncidentInformation {
  IncidentInformationModel(
      {super.subClassificationId,
      super.campaignName,
      super.campaignKey,
      super.unitType,
      super.evaluationStatus,
      super.mainClassificationId,
      super.reopenEligible,
      super.responseTime,
      super.municipalityAgentNotes,
      super.scBusinessTypeId,
      super.parkName,
      super.issueDescription,
      super.specialClassificationType,
      super.priority,
      super.vehicleType,
      super.unitValue,
      super.isCallBackSelected,
      super.scBusinessType,
      super.chassisNumber,
      super.vehicleModel,
      super.campaignId,
      super.parkId,
      super.vehicleClassification,
      super.splClassificationId,
      super.pyGuid,
      super.visibleFlag,
      super.deptManagerNotes});

  factory IncidentInformationModel.fromJson(Map<String, dynamic> json) =>
      IncidentInformationModel(
          subClassificationId: json["SubClassificationID"],
          campaignName: json["CampaignName"],
          campaignKey: json["CampaignKey"],
          unitType: json["UnitType"],
          evaluationStatus: json["EvaluationStatus"],
          mainClassificationId: json["MainClassificationID"],
          reopenEligible: json["ReopenEligible"],
          responseTime: json["ResponseTime"],
          municipalityAgentNotes: json["MunicipalityAgentNotes"],
          scBusinessTypeId: json["SCBusinessTypeID"],
          parkName: json["ParkName"],
          issueDescription: json["IssueDescription"],
          specialClassificationType: json["SpecialClassificationType"],
          priority: json["Priority"],
          vehicleType: json["VehicleType"],
          unitValue: json["UnitValue"],
          isCallBackSelected: json["IsCallBackSelected"],
          scBusinessType: json["SCBusinessType"],
          chassisNumber: json["ChassisNumber"],
          vehicleModel: json["VehicleModel"],
          campaignId: json["CampaignID"],
          parkId: json["ParkID"],
          vehicleClassification: json["VehicleClassification"],
          splClassificationId: json["SplClassificationID"],
          pyGuid: json["pyGUID"],
          visibleFlag: json["VisibleFlag"],
          deptManagerNotes: json["DeptManagerNotes"]);
}

class LocationInfoModel extends LocationInfo {
  LocationInfoModel({
    super.subMunicipalityId,
    super.address,
    super.locationDirections,
    super.subSubMunicipalityId,
    super.latitude,
    super.municipalityId,
    super.longitude,
  });

  factory LocationInfoModel.fromJson(Map<String, dynamic> json) =>
      LocationInfoModel(
        subMunicipalityId: json["SubMunicipalityID"],
        address: json["Address"],
        locationDirections: json["LocationDirections"],
        subSubMunicipalityId: json["Sub_SubMunicipalityID"],
        latitude: json["Latitude"],
        municipalityId: json["MunicipalityID"],
        longitude: json["Longitude"],
      );
}

class VehicleInformationModel extends VehicleInformation {
  VehicleInformationModel({
    super.chassisNumber,
    super.vehicleModel,
    super.vehiclePlateNumber,
    super.vehicleType,
  });

  factory VehicleInformationModel.fromJson(Map<String, dynamic> json) =>
      VehicleInformationModel(
        chassisNumber: json["ChassisNumber"],
        vehicleModel: json["VehicleModel"],
        vehiclePlateNumber: json["VehiclePlateNumber"],
        vehicleType: json["VehicleType"],
      );
}

class CommentsModel extends Comments {
  CommentsModel({
    super.comment,
    super.commentAddedOn,
  });

  factory CommentsModel.fromJson(Map<String, dynamic> json) => CommentsModel(
        comment: json["Comment"],
        commentAddedOn: json["CommentAddedOn"],
      );

  Map<String, dynamic> toJson() => {
        "Comment": comment,
        "CommentAddedOn": commentAddedOn,
      };
}
