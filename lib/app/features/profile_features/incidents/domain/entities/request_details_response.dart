import '../../data/models/request_details_response.dart';

class CrmRequestDetails {
  CrmRequestDetails(
      {this.auditInformation,
      this.customerInformation,
      this.vehicleInformation,
      this.pzInsKey,
      this.caseDeadline,
      this.locationInfo,
      this.pyId,
      this.incidentInformation,
      this.statusAr,
      this.statusWork,
      this.caseGoal,
      this.escalationRequestList,
      this.attachmentList,
      this.pyLabel,
      this.errors,
      this.amanaIncidentId,
      this.comments});

  AuditInformation? auditInformation;
  CustomerInformation? customerInformation;
  VehicleInformation? vehicleInformation;
  String? pzInsKey;
  String? caseDeadline;
  LocationInfo? locationInfo;
  String? pyId;
  IncidentInformation? incidentInformation;
  String? statusAr;
  String? statusWork;
  String? caseGoal;
  List<EscalationRequestList>? escalationRequestList;
  List<AttachmentList>? attachmentList;
  String? pyLabel;
  List<dynamic>? errors;
  String? amanaIncidentId;
  List<Comments>? comments;
}

class AttachmentList {
  AttachmentList({
    this.pyCategory,
    this.pyId,
    this.pzInsKey,
    this.pyLabel,
    this.pxCreateOpName,
    this.pyMemo,
  });

  String? pyCategory;
  String? pyId;
  String? pzInsKey;
  String? pyLabel;
  String? pxCreateOpName;
  String? pyMemo;
}

class CustomerInformation {
  CustomerInformation({
    this.dateOfBirth,
    this.mobileNumber,
    this.firstName,
    this.nationalId,
    this.preferredLanguage,
    this.lastName,
    this.iqamaId,
    this.middleName,
    this.emailAddress,
  });

  String? dateOfBirth;
  String? mobileNumber;
  String? firstName;
  String? nationalId;
  String? preferredLanguage;
  String? lastName;
  String? iqamaId;
  String? middleName;
  String? emailAddress;

  Map<String, dynamic> toJson() => {
        "NationalID": nationalId,
        "IqamaID": iqamaId,
        "FirstName": firstName,
        "MiddleName": middleName,
        "LastName": lastName,
        "DateOfBirth": dateOfBirth,
        "MobileNumber": mobileNumber,
        "EmailAddress": emailAddress,
      };
}

class EscalationRequestList {
  EscalationRequestList({
    this.pyId,
    this.pyStatusWork,
    this.statusAr,
    this.pzInsKey,
  });

  String? pyId;
  String? pyStatusWork;
  String? statusAr;
  String? pzInsKey;
}

class IncidentInformation {
  IncidentInformation(
      {this.subClassificationId,
      this.campaignName,
      this.campaignKey,
      this.unitType,
      this.evaluationStatus,
      this.mainClassificationId,
      this.reopenEligible,
      this.responseTime,
      this.municipalityAgentNotes,
      this.scBusinessTypeId,
      this.parkName,
      this.issueDescription,
      this.specialClassificationType,
      this.priority,
      this.vehicleType,
      this.unitValue,
      this.isCallBackSelected,
      this.scBusinessType,
      this.chassisNumber,
      this.vehicleModel,
      this.campaignId,
      this.parkId,
      this.vehicleClassification,
      this.splClassificationId,
      this.pyGuid,
      this.visibleFlag,
      this.deptManagerNotes});

  String? subClassificationId;
  String? campaignName;
  String? campaignKey;
  String? unitType;
  String? evaluationStatus;
  String? mainClassificationId;
  String? reopenEligible;
  dynamic responseTime;
  String? municipalityAgentNotes;
  String? scBusinessTypeId;
  String? parkName;
  String? issueDescription;
  String? specialClassificationType;
  String? priority;
  String? vehicleType;
  String? unitValue;
  dynamic isCallBackSelected;
  String? scBusinessType;
  String? chassisNumber;
  String? vehicleModel;
  String? campaignId;
  String? parkId;
  String? vehicleClassification;
  String? splClassificationId;
  String? pyGuid;
  String? visibleFlag;
  String? deptManagerNotes;

  Map<String, dynamic> toJson() => {
        "MainClassificationID": mainClassificationId,
        "SubClassificationID": subClassificationId,
        "SplClassificationID": splClassificationId,
        "Priority": priority,
        "ResponseTime": responseTime,
        "IssueDescription": issueDescription,
        "IsCallBackSelected": isCallBackSelected,
        "ParkName": parkName,
        "SCBusinessType": scBusinessType,
        "EvaluationStatus": evaluationStatus
      };
}

class LocationInfo {
  LocationInfo({
    this.subMunicipalityId,
    this.address,
    this.locationDirections,
    this.subSubMunicipalityId,
    this.latitude,
    this.municipalityId,
    this.longitude,
  });

  String? subMunicipalityId;
  String? address;
  String? locationDirections;
  String? subSubMunicipalityId;
  String? latitude;
  String? municipalityId;
  String? longitude;
}

class VehicleInformation {
  VehicleInformation({
    this.chassisNumber,
    this.vehicleModel,
    this.vehiclePlateNumber,
    this.vehicleType,
  });

  String? chassisNumber;
  String? vehicleModel;
  String? vehiclePlateNumber;
  String? vehicleType;
}
