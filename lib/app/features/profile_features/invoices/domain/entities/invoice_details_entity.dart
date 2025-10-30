class InvoiceDetailsEntity {
  final String? accountNumber;
  final DateTime? updateTime;
  final String? id;
  final double? amount;
  final DateTime? creationDate;
  final int? invoiceStatusId;
  final String? invoiceStatusName;
  final int? invoiceTypeId;
  final String? invoiceTypeName;
  final String? loginIdentityId;
  final String? loginIdentityType;
  final dynamic tag;
  final DateTime? dueDate;
  final DateTime? sadadDate;
  final DateTime? updatedDate;
  final List<Detail>? details;
  final int? applicationId;
  final String? applicationName;
  final String? ownerIdentityNumber;
  final int? requestNumber;
  final int? requestId;
  final dynamic ownerIdentityTypeId;
  final dynamic ownerIdentityTypeName;
  final int? mainRequestTypeId;
  final String? mainRequestTypeName;
  final int? requestTypeId;
  final String? requestTypeName;
  final String? hashingInvoiceNumber;
  final String? ownerName;
  final List<Violation>? violations;
  final List<Objection>? objections;

  InvoiceDetailsEntity({
    this.accountNumber,
    this.updateTime,
    this.id,
    this.amount,
    this.creationDate,
    this.invoiceStatusId,
    this.invoiceStatusName,
    this.invoiceTypeId,
    this.invoiceTypeName,
    this.loginIdentityId,
    this.loginIdentityType,
    this.tag,
    this.dueDate,
    this.sadadDate,
    this.updatedDate,
    this.details,
    this.applicationId,
    this.applicationName,
    this.ownerIdentityNumber,
    this.requestNumber,
    this.requestId,
    this.ownerIdentityTypeId,
    this.ownerIdentityTypeName,
    this.mainRequestTypeId,
    this.mainRequestTypeName,
    this.requestTypeId,
    this.requestTypeName,
    this.hashingInvoiceNumber,
    this.ownerName,
    this.violations,
    this.objections,
  });
}

class Detail {
  final String? feeId;
  final String? feeName;
  final double? amount;
  // final String? municipalityId;
  // final String? municipalityName;
  // final String? subMunicipalityId;
  // final dynamic subMunicipalityName;

  Detail({
    this.feeId,
    this.feeName,
    this.amount,
    // this.municipalityId,
    // this.municipalityName,
    // this.subMunicipalityId,
    // this.subMunicipalityName,
  });
}

class Objection {
  final String? objectedTransactionNumber;
  final String? hashingObjectedId;
  final String? objectedServiceName;
  final String? requestNumberAsText;
  final String? requestStatusName;
  final DateTime? creationDate;

  Objection({
    this.objectedTransactionNumber,
    this.hashingObjectedId,
    this.objectedServiceName,
    this.requestNumberAsText,
    this.requestStatusName,
    this.creationDate,
  });
}

class Violation {
  final String? billNumber;
  final String? violationNumber;
  final double? violationAmount;
  final DateTime? objectionLastApplyDate;
  final DateTime? violationIssueDate;
  final String? violationDescription;
  final String? regulationClause;
  final dynamic licenseNumber;
  final String? licenseNumberOrOwnerIdentityNumber;
  final String? licenseNumberBalady;
  final String? licenseTypeId;
  final String? licenseTypeName;
  final dynamic facilityName;
  final String? billStatusName;
  final String? billStatusId;
  final String? violationStatusName;
  final String? violationStatusId;
  final String? isAllowedForObjection;
  final bool? isAllowedObjection;
  final DateTime? createdDate;
  final DateTime? updatedDate;
  final String? municipalityId;
  final String? municipalityName;
  final String? subMunicipalityId;
  final String? subMunicipalityName;
  final String? ownerIdentityNo;
  final String? ownerName;
  final String? ownerIdentityTypeId;
  final String? ownerIdentityTypeName;
  final String? objectionTypeId;
  final String? objectionTypeName;
  final dynamic violationTypeId;
  final dynamic violationTypeName;
  final String? applicationId;
  final String? applicationName;
  final String? serviceId;
  final String? serviceName;
  final List<String>? actions;
  final String? hashingViolationNumber;
  final String? originalOwnerIdentityTypeId;
  final String? originalMunicipalityId;
  final String? originalSubMunicipalityId;

  Violation({
    this.billNumber,
    this.violationNumber,
    this.violationAmount,
    this.objectionLastApplyDate,
    this.violationIssueDate,
    this.violationDescription,
    this.regulationClause,
    this.licenseNumber,
    this.licenseNumberOrOwnerIdentityNumber,
    this.licenseNumberBalady,
    this.licenseTypeId,
    this.licenseTypeName,
    this.facilityName,
    this.billStatusName,
    this.billStatusId,
    this.violationStatusName,
    this.violationStatusId,
    this.isAllowedForObjection,
    this.isAllowedObjection,
    this.createdDate,
    this.updatedDate,
    this.municipalityId,
    this.municipalityName,
    this.subMunicipalityId,
    this.subMunicipalityName,
    this.ownerIdentityNo,
    this.ownerName,
    this.ownerIdentityTypeId,
    this.ownerIdentityTypeName,
    this.objectionTypeId,
    this.objectionTypeName,
    this.violationTypeId,
    this.violationTypeName,
    this.applicationId,
    this.applicationName,
    this.serviceId,
    this.serviceName,
    this.actions,
    this.hashingViolationNumber,
    this.originalOwnerIdentityTypeId,
    this.originalMunicipalityId,
    this.originalSubMunicipalityId,
  });
}
