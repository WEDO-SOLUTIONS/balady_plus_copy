import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/constants/remote_config.dart';

class TransactionDetails {
  TransactionDetails(
      {this.licenseTypeName,
      this.regulationClauseId,
      this.violationStatusName,
      this.sadadAmount,
      this.objectionCommitteeDecision,
      this.licenseNumber,
      this.noOfRepetition,
      this.objectionType,
      this.municipalityId,
      this.totalViolationPenaltyAmount,
      this.violationPenaltyAmount,
      this.facilityName,
      this.licenseType,
      this.violatorType,
      this.noOfUnits,
      this.isObjectionAllowed,
      this.objectionRequestNumber,
      this.objectionTypeName,
      this.nonComplianceClauses,
      this.subMunicipalityId,
      this.coordinateY,
      this.regulationClauseDescription,
      this.coordinateX,
      this.objectionRequestDate,
      this.violationStatus,
      this.lastDateOfObjection,
      this.invoiceStatusName,
      this.violationId,
      this.municipalityName,
      this.objectionRequestStatus,
      this.violatorTypeName,
      this.objectionApplicable,
      this.sadadNumber,
      this.subMunicipalityName,
      this.violationRegistrationDate,
      this.violatorId,
      this.invoiceStatus,
      this.serviceTypeId,

      ///
      this.objectionRequestStatusName,
      this.objectionTypeId,
      this.objectionRequestStatusId,
      this.serviceGroupId,
      this.serviceId,
      this.serviceGroupName,
      this.serviceName});

  String? licenseTypeName;
  String? regulationClauseId;
  String? violationStatusName;
  double? sadadAmount;
  String? objectionCommitteeDecision;
  String? licenseNumber;
  int? noOfRepetition;
  String? objectionType;
  String? municipalityId;
  double? totalViolationPenaltyAmount;
  double? violationPenaltyAmount;
  String? facilityName;
  String? licenseType;
  String? violatorType;
  String? serviceTypeId;
  int? noOfUnits;
  bool? isObjectionAllowed;
  String? objectionRequestNumber;
  String? objectionTypeName;
  List<NonComplianceClause>? nonComplianceClauses;
  String? objectionRequestStatusName;
  String? objectionTypeId;
  String? subMunicipalityId;
  String? coordinateY;
  String? regulationClauseDescription;
  String? coordinateX;
  String? objectionRequestDate;
  String? violationStatus;
  DateTime? lastDateOfObjection;
  String? invoiceStatusName;
  String? violationId;
  String? municipalityName;
  String? objectionRequestStatus;
  String? violatorTypeName;
  String? objectionApplicable;
  String? sadadNumber;
  String? subMunicipalityName;
  DateTime? violationRegistrationDate;
  String? violatorId;
  String? invoiceStatus;
  String? objectionRequestStatusId;
  String? serviceId;
  String? serviceGroupId;
  String? serviceGroupName;
  String? serviceName;

  String get licenseNumberOrID => (licenseNumber?.isNotEmpty ?? false)
      ? licenseNumber ?? ""
      : violatorId ?? "";
  String get getLastDateOfObjection => lastDateOfObjection != null
      ? DateFormat.yMd().format(lastDateOfObjection!)
      : "";
  String get getViolationRegistrationDate => violationRegistrationDate != null
      ? DateFormat.yMd().format(violationRegistrationDate!)
      : "";

  double? get lat => double.tryParse(coordinateX ?? "");
  double? get lon => double.tryParse(coordinateY ?? "");

  bool get notAllowedToObject {
    return lastDateOfObjection?.isBefore(DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day)) ??
        true;
  }

  /*String? get getViolationPenaltyAmount =>
      violationPenaltyAmount?.truncateToDouble() == violationPenaltyAmount
          ? violationPenaltyAmount?.toInt().toString()
          : "${violationPenaltyAmount?.toString()} ";*/

  String? get getViolationPenaltyAmount {
    String formattedNumber =
        NumberFormat('#,##0.########').format(totalViolationPenaltyAmount);

    return "$formattedNumber ${"sar_text".tr()}";
  }

  String? get getSadadAmount {
    String formattedNumber = NumberFormat('#,##0.########').format(sadadAmount);

    return "$formattedNumber ${"sar_text".tr()}";
  }
}

class NonComplianceClause {
  NonComplianceClause({
    this.nonComplianceSubClauses,
    this.clauseNo,
    this.clauseName,
  });

  List<NonComplianceSubClauses>? nonComplianceSubClauses;
  int? clauseNo;
  String? clauseName;
}

class NonComplianceSubClauses {
  int? subClauseNo;
  String? subClauseName;
  String? notes;
  List<NonComplinceAttachments>? attachments;
  NonComplianceSubClauses(
      {this.subClauseNo, this.subClauseName, this.attachments, this.notes});
}

class NonComplinceAttachments {
  final String? contentLocation;
  final String? fileName;

  NonComplinceAttachments({
    this.contentLocation,
    this.fileName,
  });

  String? getUrl() {
    return RemoteConfig.apigeeURL +
        "/v1/dms-mobile/files/${contentLocation?.split("/").last}";
  }
}
