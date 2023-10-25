import '../../../../core/utils/enums/enums.dart';

class RenewRequestInfo {
  final CleanContractResponseDto? cleanContractResponseDto;
  final OwnershipResponseDto? ownershipResponseDto;
  final SalamaResponseDto? salamaResponseDto;

  RenewRequestInfo({
    this.cleanContractResponseDto,
    this.ownershipResponseDto,
    this.salamaResponseDto,
  });

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
  final dynamic cleanContractInfo;
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
  final dynamic tenancyContractInfo;
  final dynamic deedInfoResponse;
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

  SalamaResponseDto({
    this.allowedDocuments,
    this.salamaBillOptions,
    this.salamaReportOptions,
    this.salamaPermitOptions,
    this.salamaPermitNumber,
    this.salamaBillNumber,
    this.salamaBillReport,
  });
}
