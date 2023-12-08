import 'package:intl/intl.dart';

import '../../../../objectable_transactions/domain/entities/objectable_transaction_entity.dart';

class ViolationsEntity {
  String? billNumber;
  String? violationNumber;
  int? violationAmount;
  DateTime? objectionLastApplyDate;
  DateTime? violationIssueDate;
  String? violationDescription;
  String? regulationClause;
  String? licenseNumber;
  String? licenseNumberOrOwnerIdentityNumber;
  String? licenseNumberBalady;
  String? licenseTypeId;
  String? licenseTypeName;
  String? serviceTypeId;
  dynamic facilityName;
  String? billStatusName;
  String? billStatusId;
  String? violationStatusName;
  String? violationStatusId;
  String? isAllowedForObjection;
  bool? isAllowedObjection;
  DateTime? createdDate;
  DateTime? updatedDate;
  String? municipalityId;
  String? municipalityName;
  String? subMunicipalityId;
  String? subMunicipalityName;
  String? ownerIdentityNo;
  String? ownerName;
  String? ownerIdentityTypeId;
  String? ownerIdentityTypeName;
  String? objectionTypeId;
  String? objectionTypeName;
  dynamic violationTypeId;
  dynamic violationTypeName;
  String? applicationId;
  String? applicationName;
  String? serviceId;
  String? serviceName;
  List<String>? actions;
  String? hashingViolationNumber;
  String? originalOwnerIdentityTypeId;
  String? originalMunicipalityId;
  String? originalSubMunicipalityId;

  ViolationsEntity({
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
    this.serviceTypeId,
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

  String get objectionLastApplyDateStr => objectionLastApplyDate != null
      ? DateFormat.yMd().format(objectionLastApplyDate!)
      : "";

  String get violationIssueDateStr => violationIssueDate != null
      ? DateFormat.yMd().format(violationIssueDate!)
      : "";

  ObjectableTransactionsEntity getObjectableTransactionsEntity() {
    return ObjectableTransactionsEntity(
      objectionLastApplyDate: objectionLastApplyDate,
      violationIssueDate: violationIssueDate,
      serviceTypeId: serviceTypeId,
      transactionId: violationNumber,
      violationStatusName: violationStatusName,
      violationStatusId: violationStatusId,
      isAllowedForObjection: isAllowedForObjection,
      isAllowedObjection: isAllowedObjection,
      createdDate: createdDate,
      updatedDate: updatedDate,
      municipalityId: municipalityId,
      municipalityName: municipalityName,
      subMunicipalityId: subMunicipalityId,
      subMunicipalityName: subMunicipalityName,
      ownerIdentityNo: ownerIdentityNo,
      ownerName: ownerName,
      ownerIdentityTypeId: ownerIdentityTypeId,
      ownerIdentityTypeName: ownerIdentityTypeName,
      objectionTypeId: objectionTypeId,
      objectionTypeName: objectionTypeName,
      applicationId: applicationId,
      applicationName: applicationName,
      serviceId: serviceId,
      serviceName: serviceName,
      transactionNumber: violationNumber,
      actions: actions,
      originalOwnerIdentityTypeId: originalOwnerIdentityTypeId,
      originalMunicipalityId: originalMunicipalityId,
      originalSubMunicipalityId: originalSubMunicipalityId,
    );
  }
}
