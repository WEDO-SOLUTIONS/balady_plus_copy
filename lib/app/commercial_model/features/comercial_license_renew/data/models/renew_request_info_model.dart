import '../../domain/entities/renew_request_info.dart';

class RenewRequestInfoModel extends RenewRequestInfo {
  RenewRequestInfoModel(
      {super.cleanContractResponseDto,
      super.ownershipResponseDto,
      super.salamaResponseDto,
      super.insidePetrolStation});

  factory RenewRequestInfoModel.fromJson(Map<String, dynamic> json) =>
      RenewRequestInfoModel(
          cleanContractResponseDto: json["cleanContractResponseDto"] == null
              ? null
              : CleanContractResponseDtoModel.fromJson(
                  json["cleanContractResponseDto"]),
          ownershipResponseDto: json["ownershipResponseDto"] == null
              ? null
              : OwnershipResponseDtoModel.fromJson(
                  json["ownershipResponseDto"]),
          salamaResponseDto: json["salamaResponseDto"] == null
              ? null
              : SalamaResponseDtoModel.fromJson(json["salamaResponseDto"]),
          insidePetrolStation: json["insidePetrolStation"]);
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
        cleanContractInfo: json["cleanContractInfo"] != null
            ? CleanContractInfoModel.fromMap(json["cleanContractInfo"])
            : null,
        cleanContractOptions: json["cleanContractOptions"] == null
            ? null
            : CleanContractOptionsModel.fromJson(json["cleanContractOptions"]),
        warnings: json["warnings"],
        citizenPledgedToClean: json["citizenPledgedToClean"],
      );
}

class CleanContractInfoModel extends CleanContractInfo {
  CleanContractInfoModel({
    super.contractNumber,
    super.municipalityName,
    super.shopName,
  });

  factory CleanContractInfoModel.fromMap(Map<String, dynamic> map) {
    return CleanContractInfoModel(
      contractNumber: map['contractNumber'] != null
          ? map['contractNumber'].toString()
          : null,
      municipalityName: map['municipalityName'] != null
          ? map['municipalityName'] as String
          : null,
      shopName: map['shopName'] != null ? map['shopName'] as String : null,
    );
  }
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
        tenancyContractInfo: json["tenancyContractInfo"] != null
            ? TenancyContractInfoModel.fromMap(json["tenancyContractInfo"])
            : null,
        deedInfoResponse: json["deedInfoResponse"] != null
            ? DeedInfoResponseModel.fromMap(json["deedInfoResponse"])
            : null,
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

class TenancyContractInfoModel extends TenancyContractInfo {
  TenancyContractInfoModel({
    super.contractEndDate,
    super.nationalId,
    super.tenancyContractNumber,
    super.versionNumber,
  });

  factory TenancyContractInfoModel.fromMap(Map<String, dynamic> map) {
    return TenancyContractInfoModel(
      contractEndDate: map['contractEndDate'] != null
          ? map['contractEndDate'] as String
          : null,
      nationalId:
          map['nationalId'] != null ? map['nationalId'] as String : null,
      tenancyContractNumber: map['tenancyContractNumber'] != null
          ? map['tenancyContractNumber'] as String
          : null,
      versionNumber:
          map['versionNumber'] != null ? map['versionNumber'] as String : null,
    );
  }
}

class DeedInfoResponseModel extends DeedInfoResponse {
  DeedInfoResponseModel({
    super.deedDate,
    super.deedNumber,
    super.ownerId,
    super.ownerIdType,
    super.ownershipType,
  });

  factory DeedInfoResponseModel.fromMap(Map<String, dynamic> map) {
    return DeedInfoResponseModel(
      deedDate: map['deedDate'] != null ? map['deedDate'] as String : null,
      deedNumber:
          map['deedNumber'] != null ? map['deedNumber'] as String : null,
      ownerId: map['ownerId'] != null ? map['ownerId'] as String : null,
      ownerIdType:
          map['ownerIdType'] != null ? map['ownerIdType'] as String : null,
      ownershipType:
          map['ownershipType'] != null ? map['ownershipType'] as String : null,
    );
  }
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
  SalamaResponseDtoModel(
      {super.allowedDocuments,
      super.salamaBillOptions,
      super.salamaReportOptions,
      super.salamaPermitOptions,
      super.salamaPermitNumber,
      super.salamaBillNumber,
      super.salamaBillReport,
      super.salamaReportInstructions,
      super.salamaBillInstructions});

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
          salamaBillInstructions: json["salamaBillInstructions"],
          salamaReportInstructions: json["salamaReportInstructions"]);
}
