import 'package:balady_plus/app/core/utils/enums/enums.dart';

class RenewRequestInfo {
  final CleanContractResponseDto? cleanContractResponseDto;
  final OwnershipResponseDto? ownershipResponseDto;
  final SalamaResponseDto? salamaResponseDto;
  final bool? insidePetrolStation;

  RenewRequestInfo(
      {this.cleanContractResponseDto,
      this.ownershipResponseDto,
      this.salamaResponseDto,
      this.insidePetrolStation});

  CRRenewCleanOption? getCleanOption() {
    if (cleanContractResponseDto?.cleanContractOptions?.cleanOption ==
        "OPTIONAL") {
      return CRRenewCleanOption.optional;
    }

    if (cleanContractResponseDto?.cleanContractOptions?.cleanOption ==
        "CLEAN_CONTRACT") {
      return CRRenewCleanOption.cleanContract;
    }

    if (cleanContractResponseDto?.cleanContractOptions?.cleanOption ==
        "BALADIA_SADAD") {
      return CRRenewCleanOption.baladiaSadad;
    }
    return null;
  }

  CRRenewCleanContract? getContractOption() {
    if (cleanContractResponseDto?.cleanContractOptions?.cleanOption ==
        "SERVICE") {
      return CRRenewCleanContract.service;
    }

    if (cleanContractResponseDto?.cleanContractOptions?.cleanOption ==
        "ATTACH") {
      return CRRenewCleanContract.attach;
    }

    if (cleanContractResponseDto?.cleanContractOptions?.cleanOption ==
        "ATTACH,SERVICE") {
      return CRRenewCleanContract.attachService;
    }
    return null;
  }
}

class CleanContractResponseDto {
  final dynamic cleanContractEndDate;
  final CleanContractInfo? cleanContractInfo;
  final CleanContractOptions? cleanContractOptions;
  final String? warnings;
  final bool? citizenPledgedToClean;

  CleanContractResponseDto({
    this.cleanContractEndDate,
    this.cleanContractInfo,
    this.cleanContractOptions,
    this.warnings,
    this.citizenPledgedToClean,
  });
}

class CleanContractInfo {
  String? contractNumber;
  String? municipalityName;
  String? shopName;
  CleanContractInfo({
    this.contractNumber,
    this.municipalityName,
    this.shopName,
  });
}

class CleanContractOptions {
  final String? cleanOption;
  final String? contractOption;

  CleanContractOptions({
    this.cleanOption,
    this.contractOption,
  });
}

class OwnershipResponseDto {
  final ContractOptionsResponseDto? contractOptionsResponseDto;
  final TenancyContractInfo? tenancyContractInfo;
  final DeedInfoResponse? deedInfoResponse;
  final dynamic investmentContractNumber;
  final String? contractOption;
  final dynamic contractWarnings;
  final String? modifyOwnershipWarning;
  final String? contractType;
  final String? contractDownloadUrl;
  final String? contractDate;
  final String? contractNumber;

  OwnershipResponseDto({
    this.contractOptionsResponseDto,
    this.tenancyContractInfo,
    this.deedInfoResponse,
    this.investmentContractNumber,
    this.contractOption,
    this.contractWarnings,
    this.modifyOwnershipWarning,
    this.contractType,
    this.contractDownloadUrl,
    this.contractDate,
    this.contractNumber,
  });
}

class TenancyContractInfo {
  String? contractEndDate;
  String? nationalId;
  String? tenancyContractNumber;
  String? versionNumber;
  TenancyContractInfo({
    this.contractEndDate,
    this.nationalId,
    this.tenancyContractNumber,
    this.versionNumber,
  });

  TenancyContractInfo copyWith({
    String? contractEndDate,
    String? nationalId,
    String? tenancyContractNumber,
    String? versionNumber,
  }) {
    return TenancyContractInfo(
      contractEndDate: contractEndDate ?? this.contractEndDate,
      nationalId: nationalId ?? this.nationalId,
      tenancyContractNumber:
          tenancyContractNumber ?? this.tenancyContractNumber,
      versionNumber: versionNumber ?? this.versionNumber,
    );
  }
}

class DeedInfoResponse {
  String? deedDate;
  String? deedNumber;
  String? ownerId;
  String? ownerIdType;
  String? ownershipType;
  DeedInfoResponse({
    this.deedDate,
    this.deedNumber,
    this.ownerId,
    this.ownerIdType,
    this.ownershipType,
  });
}

class ContractOptionsResponseDto {
  final List<String>? ejarOptions;
  final List<String>? deedOptions;
  final List<String>? investOptions;

  ContractOptionsResponseDto({
    this.ejarOptions,
    this.deedOptions,
    this.investOptions,
  });
}

class SalamaResponseDto {
  final List<String>? allowedDocuments;
  final List<String>? salamaBillOptions;
  final List<String>? salamaReportOptions;
  final List<String>? salamaPermitOptions;
  final dynamic salamaPermitNumber;
  final dynamic salamaBillNumber;
  final dynamic salamaBillReport;
  final String? salamaBillInstructions;
  final String? salamaReportInstructions;

  SalamaResponseDto(
      {this.allowedDocuments,
      this.salamaBillOptions,
      this.salamaReportOptions,
      this.salamaPermitOptions,
      this.salamaPermitNumber,
      this.salamaBillNumber,
      this.salamaBillReport,
      this.salamaBillInstructions,
      this.salamaReportInstructions});
}
