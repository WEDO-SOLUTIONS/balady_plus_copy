import '../../domain/entities/renew_request_info.dart';

class RenewRequestInfoModel extends RenewRequestInfo {
  RenewRequestInfoModel({
    super.cleanContractResponseDto,
    super.ownershipResponseDto,
    super.salamaResponseDto,
  });

  factory RenewRequestInfoModel.fromJson(Map<String, dynamic> json) =>
      RenewRequestInfoModel(
        cleanContractResponseDto: json["cleanContractResponseDto"] == null
            ? null
            : CleanContractResponseDtoModel.fromJson(
                json["cleanContractResponseDto"]),
        ownershipResponseDto: json["ownershipResponseDto"] == null
            ? null
            : OwnershipResponseDtoModel.fromJson(json["ownershipResponseDto"]),
        salamaResponseDto: json["salamaResponseDto"] == null
            ? null
            : SalamaResponseDtoModel.fromJson(json["salamaResponseDto"]),
      );
}

class CleanContractResponseDtoModel extends CleanContractResponseDto {
  CleanContractResponseDtoModel({
    super.cleanContractEndDate,
    super.cleanContractInfo,
    super.cleanContractOptions,
    super.warnings,
    super.citizenPledgedToClean,
  });

  factory CleanContractResponseDtoModel.fromJson(Map<String, dynamic> json) =>
      CleanContractResponseDtoModel(
        cleanContractEndDate: json["cleanContractEndDate"],
        cleanContractInfo: json["cleanContractInfo"],
        cleanContractOptions: json["cleanContractOptions"] == null
            ? null
            : CleanContractOptionsModel.fromJson(json["cleanContractOptions"]),
        warnings: json["warnings"],
        citizenPledgedToClean: json["citizenPledgedToClean"],
      );
}

class CleanContractOptionsModel extends CleanContractOptions {
  CleanContractOptionsModel({
    super.cleanOption,
    super.contractOption,
  });

  factory CleanContractOptionsModel.fromJson(Map<String, dynamic> json) =>
      CleanContractOptionsModel(
        cleanOption: json["cleanOption"],
        contractOption: json["contractOption"],
      );
}

class OwnershipResponseDtoModel extends OwnershipResponseDto {
  OwnershipResponseDtoModel({
    super.contractOptionsResponseDto,
    super.tenancyContractInfo,
    super.deedInfoResponse,
    super.investmentContractNumber,
    super.contractOption,
    super.contractWarnings,
    super.modifyOwnershipWarning,
    super.contractType,
    super.contractDownloadUrl,
    super.contractDate,
    super.contractNumber,
  });

  factory OwnershipResponseDtoModel.fromJson(Map<String, dynamic> json) =>
      OwnershipResponseDtoModel(
        contractOptionsResponseDto: json["contractOptionsResponseDto"] == null
            ? null
            : ContractOptionsResponseDtoModel.fromJson(
                json["contractOptionsResponseDto"]),
        tenancyContractInfo: json["tenancyContractInfo"],
        deedInfoResponse: json["deedInfoResponse"],
        investmentContractNumber: json["investmentContractNumber"],
        contractOption: json["contractOption"],
        contractWarnings: json["contractWarnings"],
        modifyOwnershipWarning: json["modifyOwnershipWarning"],
        contractType: json["contractType"],
        contractDownloadUrl: json["contractDownloadUrl"],
        contractDate: json["contractDate"],
        contractNumber: json["contractNumber"],
      );
}

class ContractOptionsResponseDtoModel extends ContractOptionsResponseDto {
  ContractOptionsResponseDtoModel({
    super.ejarOptions,
    super.deedOptions,
    super.investOptions,
  });

  factory ContractOptionsResponseDtoModel.fromJson(Map<String, dynamic> json) =>
      ContractOptionsResponseDtoModel(
        ejarOptions: json["ejarOptions"] == null
            ? []
            : List<String>.from(json["ejarOptions"]!.map((x) => x)),
        deedOptions: json["deedOptions"] == null
            ? []
            : List<String>.from(json["deedOptions"]!.map((x) => x)),
        investOptions: json["investOptions"] == null
            ? []
            : List<String>.from(json["investOptions"]!.map((x) => x)),
      );
}

class SalamaResponseDtoModel extends SalamaResponseDto {
  SalamaResponseDtoModel({
    super.allowedDocuments,
    super.salamaBillOptions,
    super.salamaReportOptions,
    super.salamaPermitOptions,
    super.salamaPermitNumber,
    super.salamaBillNumber,
    super.salamaBillReport,
  });

  factory SalamaResponseDtoModel.fromJson(Map<String, dynamic> json) =>
      SalamaResponseDtoModel(
        allowedDocuments: json["allowedDocuments"] == null
            ? []
            : List<String>.from(json["allowedDocuments"]!.map((x) => x)),
        salamaBillOptions: json["salamaBillOptions"] != null
            ? List<String>.from(json["salamaBillOptions"]!.map((x) => x))
            : [],
        salamaReportOptions: json["salamaReportOptions"] != null
            ? List<String>.from(json["salamaReportOptions"]!.map((x) => x))
            : [],
        salamaPermitOptions: json["salamaPermitOptions"] == null
            ? []
            : List<String>.from(json["salamaPermitOptions"]!.map((x) => x)),
        salamaPermitNumber: json["salamaPermitNumber"],
        salamaBillNumber: json["salamaBillNumber"],
        salamaBillReport: json["salamaBillReport"],
      );
}
