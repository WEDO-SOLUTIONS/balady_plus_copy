import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class ObjectableTransactionsEntity extends Equatable {
  final String? transactionNumber; //
  final String? applicationId;
  final String? applicationName;
  final String? isAllowedForObjection;
  final String? municipalityId;
  final String? municipalityName;
  final DateTime? objectionLastApplyDate;
  final String? ownerIdentityNo;
  final String? ownerIdentityTypeId;
  final String? ownerIdentityTypeName;
  final String? serviceId;
  final String? serviceName;
  final String? subMunicipalityId;
  final String? subMunicipalityName;
  final DateTime? violationIssueDate;
  final String? objectionTypeId;
  final String? objectionTypeName;

  const ObjectableTransactionsEntity(
      {this.transactionNumber,
      this.applicationId,
      this.applicationName,
      this.isAllowedForObjection,
      this.municipalityId,
      this.municipalityName,
      this.objectionLastApplyDate,
      this.ownerIdentityNo,
      this.ownerIdentityTypeId,
      this.ownerIdentityTypeName,
      this.serviceId,
      this.serviceName,
      this.subMunicipalityId,
      this.subMunicipalityName,
      this.violationIssueDate,
      this.objectionTypeId,
      this.objectionTypeName});

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
