import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class ObjectableTransactionsEntity extends Equatable {
  final String? transactionNumber;
  final DateTime? objectionLastApplyDate;
  final DateTime? violationIssueDate;
  final dynamic violationStatusName;
  final dynamic violationStatusId;
  final String? isAllowedForObjection;
  final bool? isAllowedObjection;
  final dynamic createdDate;
  final DateTime? updatedDate;
  final String? municipalityId;
  final String? municipalityName;
  final String? subMunicipalityId;
  final String? subMunicipalityName;
  final String? ownerIdentityNo;
  final dynamic ownerName;
  final String? ownerIdentityTypeId;
  final String? ownerIdentityTypeName;
  final String? objectionTypeId;
  final String? objectionTypeName;
  final String? applicationId;
  final String? applicationName;
  final String? serviceId;
  final String? serviceName;
  final String? redirectUrl;
  final dynamic actions;
  final String? hashingTransactionNumber;
  final String? originalOwnerIdentityTypeId;
  final String? originalMunicipalityId;
  final String? originalSubMunicipalityId;
  final String? serviceTypeId;
  final String? transactionId;
  final dynamic contentTypeId;
  final dynamic contentTypeName;
  final dynamic originalServiceId;
  final String? hashingOriginalServiceId;
  final dynamic licenseNumber;
  final dynamic licenseTypeID;

  const ObjectableTransactionsEntity(
      {this.transactionNumber,
      this.objectionLastApplyDate,
      this.violationIssueDate,
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
      this.applicationId,
      this.applicationName,
      this.serviceId,
      this.serviceName,
      this.redirectUrl,
      this.actions,
      this.hashingTransactionNumber,
      this.originalOwnerIdentityTypeId,
      this.originalMunicipalityId,
      this.originalSubMunicipalityId,
      this.serviceTypeId,
      this.transactionId,
      this.contentTypeId,
      this.contentTypeName,
      this.originalServiceId,
      this.hashingOriginalServiceId,
      this.licenseNumber,
      this.licenseTypeID});

  String get objectionLastApplyDateStr => objectionLastApplyDate != null
      ? DateFormat.yMd().format(objectionLastApplyDate!)
      : "";

  String get violationIssueDateStr => violationIssueDate != null
      ? DateFormat.yMd().format(violationIssueDate!)
      : "";

  @override
  List<Object?> get props => [
        transactionNumber,
        municipalityName,
        subMunicipalityName,
      ];
}
