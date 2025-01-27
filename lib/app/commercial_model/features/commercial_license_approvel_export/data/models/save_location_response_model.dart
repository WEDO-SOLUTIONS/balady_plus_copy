// To parse this JSON data, do
//
//     final saveLocationResponse = saveLocationResponseFromJson(jsonString);

import 'dart:convert';

import '../../commercial_license_exports.dart';

class SaveLocationResponseModel extends SaveLocationResponse {
  SaveLocationResponseModel({
    super.requestId,
    super.minYears,
    super.maxYears,
    super.contractOptionsResponseDto,
    super.slamaBillOptions,
    super.slamaReportOptions,
    super.selectLicYears,
    super.endorsementText,
    super.boardContractSetting,
    super.showSalamaPermit,
  });

  factory SaveLocationResponseModel.fromJson(Map<String, dynamic> json) =>
      SaveLocationResponseModel(
        requestId: json["requestId"],
        minYears: json["minYears"],
        maxYears: json["maxYears"],
        contractOptionsResponseDto: json["contractOptionsResponseDto"] == null
            ? null
            : ContractOptionsResDto.fromJson(
                json["contractOptionsResponseDto"]),
        slamaBillOptions: json["slamaBillOptions"] == null
            ? []
            : List<String>.from(json["slamaBillOptions"]!.map((x) => x)),
        slamaReportOptions: json["slamaReportOptions"] == null
            ? []
            : List<String>.from(json["slamaReportOptions"]!.map((x) => x)),
        selectLicYears: json["selectLicYears"],
        endorsementText: json["endorsementText"],
        boardContractSetting: json["boardContractSetting"],
        showSalamaPermit: json["showSalamaPermit"],
      );
}

class ContractOptionsResponseDtoModel extends ContractOptionsResDto {
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
