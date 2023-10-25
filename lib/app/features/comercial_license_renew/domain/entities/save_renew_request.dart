// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:balady_plus/app/features/comercial_license_renew/renew_commercial_license_exports.dart';

class SaveRenewRequest extends Equatable {
  final int? requestId;
  final bool? citizenPledgedToClean;
  final String? cleanContractEndDate;
  final int? cleanContractNumber;

  final String? contractDate;
  final String? contractNumber;
  final String? contractOption;
  final String? contractType;

  final EjarInfoRequest? ejarContractInfo;
  final String? investmentContractNumber;

  final int? sadadPeriod;
  final String? salamaBillNumber;
  final String? salamaReportNumber;
  final String? salamaPermitNumber;

  Map<String, dynamic> toMap() => {
        "citizenPledgedToClean": citizenPledgedToClean,
        "cleanContractEndDate": cleanContractEndDate,
        "cleanContractNumber": cleanContractNumber,
        "ownershipInfo": {
          "contractDate": contractDate,
          "contractNumber": contractNumber,
          "contractOption": contractOption,
          "contractType": contractType,
          /* "deedInfo": {
            "DeedNumber": "string",
            "OwnerId": "string",
            "OwnerIdType": "string"
        },*/
          if (ejarContractInfo != null &&
              ejarContractInfo?.tenancyContractNumber != null)
            "ejarContractInfo": ejarContractInfo?.toMap(),
          "investmentContractNumber": investmentContractNumber
        },
        "sadadPeriod": sadadPeriod,
        "salamaBillNumber": salamaBillNumber,
        "salamaReportNumber": salamaReportNumber,
        "salamaPermitNumber": salamaPermitNumber
      };
  @override
  List<Object?> get props => [
        requestId,
        ejarContractInfo,
        sadadPeriod,
        salamaBillNumber,
        salamaReportNumber
      ];
  SaveRenewRequest({
    this.requestId,
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
  });
}
