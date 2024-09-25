import 'package:equatable/equatable.dart';

import 'package:balady_plus/app/commercial_model/features/comercial_license_renew/renew_commercial_license_exports.dart';

class SaveRenewRequest extends Equatable {
  final int? requestId;
  final bool? citizenPledgedToClean;
  final String? cleanContractEndDate;
  final int? cleanContractNumber;

  final String? contractDate;
  final String? contractNumber;
  final String? contractOption;
  final String? contractType;
  final DeedInfoRequest? deedInfoRequest;

  final EjarInfoRequest? ejarContractInfo;
  final String? investmentContractNumber;

  final int? sadadPeriod;
  final String? salamaBillNumber;
  final String? salamaReportNumber;
  final String? salamaPermitNumber;
  final bool? salamaPermitExist;
  final bool? insidePetrolStation;

  Map<String, dynamic> toMap() => {
        "citizenPledgedToClean": citizenPledgedToClean,
        "cleanContractEndDate": cleanContractEndDate,
        "cleanContractNumber": cleanContractNumber,
        "ownershipInfo": {
          "contractDate": contractDate,
          "contractNumber": contractNumber,
          "contractOption": contractOption,
          "contractType": contractType,
          "deedInfo": {
            "DeedNumber": deedInfoRequest?.deedNumber,
            "OwnerId": deedInfoRequest?.ownerId,
            "OwnerIdType": "CR_700"
          },
          if (ejarContractInfo != null &&
              ejarContractInfo?.tenancyContractNumber != null)
            "ejarContractInfo": ejarContractInfo?.toMap(),
          "investmentContractNumber": investmentContractNumber
        },
        "sadadPeriod": sadadPeriod,
        "salamaBillNumber": salamaBillNumber,
        "salamaReportNumber": salamaReportNumber,
        if (salamaPermitNumber != null && salamaPermitNumber!.isNotEmpty)
          "salamaPermitNumber": salamaPermitNumber,
        "salamaPermitExist": salamaPermitExist,
        "insidePetrolStation": insidePetrolStation
      };
  @override
  List<Object?> get props => [
        requestId,
        ejarContractInfo,
        sadadPeriod,
        salamaBillNumber,
        salamaReportNumber,
        deedInfoRequest,
        salamaPermitExist,
        insidePetrolStation
      ];
  SaveRenewRequest(
      {this.requestId,
      this.citizenPledgedToClean,
      this.cleanContractEndDate,
      this.cleanContractNumber,
      this.contractDate,
      this.contractNumber,
      this.contractOption,
      this.contractType,
      this.ejarContractInfo,
      this.investmentContractNumber,
      this.sadadPeriod,
      this.salamaBillNumber,
      this.salamaReportNumber,
      this.salamaPermitNumber,
      this.deedInfoRequest,
      this.salamaPermitExist,
      this.insidePetrolStation});
}
