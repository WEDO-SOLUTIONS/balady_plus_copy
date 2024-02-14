import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../objectable_transactions/domain/entities/transaction_details.dart';

class ViolationDetailsEntity extends TransactionDetails {
  ViolationDetailsEntity({
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
    super.coordinateX,
    super.coordinateY,
    // super.hashingObjectionRequestNumber,
    // super.hashingSadadNumber,
    super.objectionRequestStatusName,
    // super.objectionApplicableId,
    // super.objectionApplicableName,
    super.objectionRequestStatusId,
    super.serviceGroupId,
    super.serviceId,
    super.objectionTypeId,
    super.serviceGroupName,
    super.serviceName,
    // super.hashingViolationNumber,
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

  double? get lat => double.tryParse(coordinateX ?? "");
  double? get lon => double.tryParse(coordinateY ?? "");

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
