import '../../domain/entities/transaction_details.dart';

class TransactionDetailsModel extends TransactionDetails {
  TransactionDetailsModel(
      {super.licenseTypeName,
      super.regulationClauseId,
      super.violationStatusName,
      super.sadadAmount,
      super.objectionCommitteeDecision,
      super.licenseNumber,
      super.noOfRepetition,
      super.objectionType,
      super.municipalityId,
      super.totalViolationPenaltyAmount,
      super.violationPenaltyAmount,
      super.facilityName,
      super.licenseType,
      super.violatorType,
      super.noOfUnits,
      super.isObjectionAllowed,
      super.objectionRequestNumber,
      super.objectionTypeName,
      super.nonComplianceClauses,
      super.subMunicipalityId,
      super.coordinateY,
      super.regulationClauseDescription,
      super.coordinateX,
      super.objectionRequestDate,
      super.violationStatus,
      super.lastDateOfObjection,
      super.invoiceStatusName,
      super.violationId,
      super.municipalityName,
      super.objectionRequestStatus,
      super.violatorTypeName,
      super.objectionApplicable,
      super.sadadNumber,
      super.subMunicipalityName,
      super.violationRegistrationDate,
      super.violatorId,
      super.invoiceStatus,
      super.objectionRequestStatusName,
      super.objectionTypeId,
      super.objectionRequestStatusId,
      super.serviceGroupId,
      super.serviceId,
      super.serviceGroupName,
      super.serviceName,
      super.serviceTypeId});

  factory TransactionDetailsModel.fromJson(Map<String, dynamic> json) =>
      TransactionDetailsModel(
          licenseTypeName: json["LicenseTypeName"],
          regulationClauseId: json["RegulationClauseID"],
          violationStatusName: json["ViolationStatusName"],
          sadadAmount: json["SadadAmount"] != null
              ? json["SadadAmount"].toDouble()
              : null,
          objectionCommitteeDecision: json["ObjectionCommitteeDecision"],
          licenseNumber: json["LicenseNumber"],
          noOfRepetition: json["NoOfRepetition"],
          objectionType: json["ObjectionType"],
          municipalityId: json["MunicipalityID"],
          totalViolationPenaltyAmount:
              json["TotalViolationPenaltyAmount"] != null
                  ? json["TotalViolationPenaltyAmount"].toDouble()
                  : null,
          violationPenaltyAmount: json["ViolationPenaltyAmount"] != null
              ? json["ViolationPenaltyAmount"].toDouble()
              : null,
          facilityName: json["FacilityName"],
          licenseType: json["LicenseType"],
          violatorType: json["ViolatorType"],
          noOfUnits: json["NoOfUnits"],
          serviceTypeId: json["ServiceTypeId"],
          isObjectionAllowed: json["IsObjectionAllowed"],
          objectionRequestNumber: json["ObjectionRequestNumber"],
          objectionTypeName: json["ObjectionTypeName"],
          nonComplianceClauses: json["NonComplianceClauses"] == null
              ? []
              : List<NonComplianceClause>.from(json["NonComplianceClauses"]!
                  .map((x) => NonComplianceClauseModel.fromJson(x))),
          subMunicipalityId: json["SubMunicipalityID"],
          coordinateY: json["COORDINATE_Y"],
          regulationClauseDescription: json["RegulationClauseDescription"],
          coordinateX: json["COORDINATE_X"],
          objectionRequestDate: json["ObjectionRequestDate"],
          violationStatus: json["ViolationStatus"],
          lastDateOfObjection: json["LastDateOfObjection"] == null
              ? null
              : DateTime.tryParse(json["LastDateOfObjection"]),
          invoiceStatusName: json["InvoiceStatusName"],
          violationId: json["ViolationID"],
          municipalityName: json["MunicipalityName"],
          objectionRequestStatus: json["ObjectionRequestStatus"],
          violatorTypeName: json["ViolatorTypeName"],
          objectionApplicable: json["ObjectionApplicable"],
          sadadNumber: json["SadadNumber"],
          subMunicipalityName: json["SubMunicipalityName"],
          violationRegistrationDate: json["ViolationRegistrationDate"] == null
              ? null
              : DateTime.tryParse(json["ViolationRegistrationDate"]),
          violatorId: json["ViolatorID"],
          invoiceStatus: json["InvoiceStatus"],
          objectionRequestStatusName: json["ObjectionRequestStatusName"],
          objectionTypeId: json["ObjectionTypeId"],
          objectionRequestStatusId: json["ObjectionRequestStatusId"],
          serviceGroupId: json["ServiceGroupId"],
          serviceId: json["ServiceId"],
          serviceGroupName: json["ServiceGroupName"],
          serviceName: json["ServiceName"]);
}

class NonComplianceClauseModel extends NonComplianceClause {
  NonComplianceClauseModel({
    super.nonComplianceSubClauses,
    super.clauseNo,
    super.clauseName,
  });

  factory NonComplianceClauseModel.fromJson(Map<String, dynamic> json) =>
      NonComplianceClauseModel(
        nonComplianceSubClauses: json["NonComplianceSubClauses"] != null
            ? List<NonComplianceSubClausesModel>.from(
                json["NonComplianceSubClauses"]
                    .map((x) => NonComplianceSubClausesModel.fromJson(x)))
            : null,
        clauseNo: json["ClauseNo"],
        clauseName: json["ClauseName"],
      );
}

class NonComplianceSubClausesModel extends NonComplianceSubClauses {
  NonComplianceSubClausesModel(
      {super.attachments, super.subClauseName, super.subClauseNo, super.notes});

  factory NonComplianceSubClausesModel.fromJson(Map<String, dynamic> json) =>
      NonComplianceSubClausesModel(
        attachments: json["Attachments"] != null
            ? List<NonComplinceAttachmentsModel>.from(json["Attachments"]
                .map((x) => NonComplinceAttachmentsModel.fromJson(x)))
            : null,
        subClauseName: json["SubClauseName"],
        notes: json["Notes"],
        subClauseNo: json["SubClauseNo"],
      );
}

class NonComplinceAttachmentsModel extends NonComplinceAttachments {
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
