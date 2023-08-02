import '../../../../objections/domain/entities/objection_details.dart';
import '../../violations_exports.dart';

class ViolationDetailsModel extends ViolationDetailsEntity{
  ViolationDetailsModel({
    super.subMunicipalityId,
    super.regulationClauseId,
    super.regulationClauseDescription,
    super.sadadAmount,
    super.licenseNumber,
    super.violationStatus,
    super.lastDateOfObjection,
    super.violationId,
    super.municipalityName,
    super.noOfRepetition,
    super.municipalityId,
    super.totalViolationPenaltyAmount,
    super.violationPenaltyAmount,
    super.licenseType,
    super.licenseTypeName,
    super.violatorType,
    super.violatorTypeName,
    super.noOfUnits,
    super.objectionApplicable,
    super.nonComplianceClauses,
    super.sadadNumber,
    super.subMunicipalityName,
    super.violationRegistrationDate,
    super.violatorId,
    super.invoiceStatus,
    super.invoiceStatusName,
    super.violationStatusName,
    super.objectionType,
    super.objectionTypeName,
    super.facilityName,
    super.isObjectionAllowed,
    super.objectionCommitteeDecision,
    super.objectionRequestStatus,
    super.objectionRequestNumber,
    super.objectionRequestDate,
    super.coordinatEY,
    super.coordinatEX,
    super.hashingObjectionRequestNumber,
    super.hashingSadadNumber,
    super.objectionRequestStatusName,
    super.objectionApplicableId,
    super.objectionApplicableName,
    super.objectionRequestStatusId,
    super.serviceGroupId,
    super.serviceId,
    super.objectionTypeId,
    super.hashingViolationNumber,
  });

  factory ViolationDetailsModel.fromJson(Map<String, dynamic> json) =>
      ViolationDetailsModel(
        subMunicipalityId: json["subMunicipalityID"],
        regulationClauseId: json["regulationClauseID"],
        regulationClauseDescription: json["regulationClauseDescription"],
        sadadAmount: json["sadadAmount"],
        licenseNumber: json["licenseNumber"],
        violationStatus: json["violationStatus"],
        lastDateOfObjection: json["lastDateOfObjection"],
        violationId: json["violationID"],
        municipalityName: json["municipalityName"],
        noOfRepetition: json["noOfRepetition"],
        municipalityId: json["municipalityID"],
        totalViolationPenaltyAmount: json["totalViolationPenaltyAmount"],
        violationPenaltyAmount: json["violationPenaltyAmount"],
        licenseType: json["licenseType"],
        licenseTypeName: json["licenseTypeName"],
        violatorType: json["violatorType"],
        violatorTypeName: json["violatorTypeName"],
        noOfUnits: json["noOfUnits"],
        objectionApplicable: json["objectionApplicable"],
        nonComplianceClauses: json["nonComplianceClauses"] == null
            ? []
            : List<NonComplianceClause>.from(json["nonComplianceClauses"]!
                .map((x) => NonComplianceClauseModel.fromJson(x))),
        sadadNumber: json["sadadNumber"],
        subMunicipalityName: json["subMunicipalityName"],
        violationRegistrationDate: json["violationRegistrationDate"] == null
            ? null
            : DateTime.parse(json["violationRegistrationDate"]),
        violatorId: json["violatorID"],
        invoiceStatus: json["invoiceStatus"],
        invoiceStatusName: json["invoiceStatusName"],
        violationStatusName: json["violationStatusName"],
        objectionType: json["objectionType"],
        objectionTypeName: json["objectionTypeName"],
        facilityName: json["facilityName"],
        isObjectionAllowed: json["isObjectionAllowed"],
        objectionCommitteeDecision: json["objectionCommitteeDecision"],
        objectionRequestStatus: json["objectionRequestStatus"],
        objectionRequestNumber: json["objectionRequestNumber"],
        objectionRequestDate: json["objectionRequestDate"],
        coordinatEY: json["coordinatE_Y"],
        coordinatEX: json["coordinatE_X"],
        hashingObjectionRequestNumber: json["hashingObjectionRequestNumber"],
        hashingSadadNumber: json["hashingSadadNumber"],
        objectionRequestStatusName: json["objectionRequestStatusName"],
        objectionApplicableId: json["objectionApplicableId"],
        objectionApplicableName: json["objectionApplicableName"],
        objectionRequestStatusId: json["objectionRequestStatusId"],
        serviceGroupId: json["serviceGroupId"],
        serviceId: json["serviceId"],
        objectionTypeId: json["objectionTypeId"],
        hashingViolationNumber: json["hashingViolationNumber"],
      );
}

class NonComplianceClauseModel extends NonComplianceClause{
  NonComplianceClauseModel({
    super.clauseNo,
    super.clauseName,
    super.nonComplianceSubClauses,
  });

  factory NonComplianceClauseModel.fromJson(Map<String, dynamic> json) =>
      NonComplianceClauseModel(
        clauseNo: json["clauseNo"],
        clauseName: json["clauseName"],
        nonComplianceSubClauses: json["nonComplianceSubClauses"] == null
            ? []
            : List<NonComplianceSubClause>.from(json["nonComplianceSubClauses"]!
                .map((x) => NonComplianceSubClauseModel.fromJson(x))),
      );
}

class NonComplianceSubClauseModel extends NonComplianceSubClause{
  NonComplianceSubClauseModel({
    super.subClauseNo,
    super.subClauseName,
    super.notes,
    super.attachments,
  });

  factory NonComplianceSubClauseModel.fromJson(Map<String, dynamic> json) =>
      NonComplianceSubClauseModel(
        subClauseNo: json["subClauseNo"],
        subClauseName: json["subClauseName"],
        notes: json["notes"],
        attachments: json["attachments"] == null
            ? []
            : List<NonComplinceAttachmentsModel>.from(json["attachments"]!
                .map((x) => NonComplinceAttachmentsModel.fromJson(x))),
      );
}

class NonComplinceAttachmentsModel extends ReasonAttachment {
  NonComplinceAttachmentsModel({
    super.contentLocation,
    super.fileName,
  });

  factory NonComplinceAttachmentsModel.fromJson(Map<String, dynamic> json) =>
      NonComplinceAttachmentsModel(
        contentLocation: json["ContentLocation"],
        fileName: json["FileName"],
      );
}
