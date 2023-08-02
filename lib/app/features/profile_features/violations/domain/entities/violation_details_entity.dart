import 'package:intl/intl.dart';

import '../../../../../core/utils/constants/remote_config.dart';
import '../../../../objections/domain/entities/objection_details.dart';

class ViolationDetailsEntity {
  String? subMunicipalityId;
  String? regulationClauseId;
  String? regulationClauseDescription;
  int? sadadAmount;
  String? licenseNumber;
  String? violationStatus;
  String? lastDateOfObjection;
  String? violationId;
  String? municipalityName;
  int? noOfRepetition;
  String? municipalityId;
  int? totalViolationPenaltyAmount;
  int? violationPenaltyAmount;
  String? licenseType;
  String? licenseTypeName;
  String? violatorType;
  String? violatorTypeName;
  int? noOfUnits;
  String? objectionApplicable;
  List<NonComplianceClause>? nonComplianceClauses;
  String? sadadNumber;
  String? subMunicipalityName;
  DateTime? violationRegistrationDate;
  String? violatorId;
  String? invoiceStatus;
  String? invoiceStatusName;
  String? violationStatusName;
  String? objectionType;
  String? objectionTypeName;
  String? facilityName;
  bool? isObjectionAllowed;
  String? objectionCommitteeDecision;
  String? objectionRequestStatus;
  String? objectionRequestNumber;
  String? objectionRequestDate;
  String? coordinatEY;
  String? coordinatEX;
  String? hashingObjectionRequestNumber;
  String? hashingSadadNumber;
  String? objectionRequestStatusName;
  String? objectionApplicableId;
  String? objectionApplicableName;
  String? objectionRequestStatusId;
  String? serviceGroupId;
  String? serviceId;
  String? objectionTypeId;
  String? hashingViolationNumber;

  ViolationDetailsEntity({
    this.subMunicipalityId,
    this.regulationClauseId,
    this.regulationClauseDescription,
    this.sadadAmount,
    this.licenseNumber,
    this.violationStatus,
    this.lastDateOfObjection,
    this.violationId,
    this.municipalityName,
    this.noOfRepetition,
    this.municipalityId,
    this.totalViolationPenaltyAmount,
    this.violationPenaltyAmount,
    this.licenseType,
    this.licenseTypeName,
    this.violatorType,
    this.violatorTypeName,
    this.noOfUnits,
    this.objectionApplicable,
    this.nonComplianceClauses,
    this.sadadNumber,
    this.subMunicipalityName,
    this.violationRegistrationDate,
    this.violatorId,
    this.invoiceStatus,
    this.invoiceStatusName,
    this.violationStatusName,
    this.objectionType,
    this.objectionTypeName,
    this.facilityName,
    this.isObjectionAllowed,
    this.objectionCommitteeDecision,
    this.objectionRequestStatus,
    this.objectionRequestNumber,
    this.objectionRequestDate,
    this.coordinatEY,
    this.coordinatEX,
    this.hashingObjectionRequestNumber,
    this.hashingSadadNumber,
    this.objectionRequestStatusName,
    this.objectionApplicableId,
    this.objectionApplicableName,
    this.objectionRequestStatusId,
    this.serviceGroupId,
    this.serviceId,
    this.objectionTypeId,
    this.hashingViolationNumber,
  });


  String get licenseNumberOrID => (licenseNumber?.isNotEmpty ?? false)
      ? licenseNumber ?? ""
      : violatorId ?? "";
  // String get getLastDateOfObjection => lastDateOfObjection != null
  //     ? DateFormat.yMd().format(lastDateOfObjection!)
  //     : "";
  String get getViolationRegistrationDate => violationRegistrationDate != null
      ? DateFormat.yMd().format(violationRegistrationDate!)
      : "";

  double? get lat => double.tryParse(coordinatEX ?? "");
  double? get lon => double.tryParse(coordinatEY ?? "");


  /*String? get getViolationPenaltyAmount =>
      violationPenaltyAmount?.truncateToDouble() == violationPenaltyAmount
          ? violationPenaltyAmount?.toInt().toString()
          : "${violationPenaltyAmount?.toString()} ";*/

  String? get getViolationPenaltyAmount {
    String formattedNumber =
    NumberFormat('#,##0.########').format(totalViolationPenaltyAmount);

    return "$formattedNumber ر.س.";
  }

  String? get getSadadAmount {
    String formattedNumber = NumberFormat('#,##0.########').format(sadadAmount);

    return "$formattedNumber ر.س.";
  }

}

class NonComplianceClause {
  dynamic clauseNo;
  String? clauseName;
  List<NonComplianceSubClause>? nonComplianceSubClauses;

  NonComplianceClause({
    this.clauseNo,
    this.clauseName,
    this.nonComplianceSubClauses,
  });
}

class NonComplianceSubClause {
  int? subClauseNo;
  String? subClauseName;
  String? notes;
  List<ReasonAttachment>? attachments;

  NonComplianceSubClause({
    this.subClauseNo,
    this.subClauseName,
    this.notes,
    this.attachments,
  });
}
