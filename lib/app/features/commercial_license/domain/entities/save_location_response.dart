// ignore_for_file: public_member_api_docs, sort_constructors_first
// To parse this JSON data, do
//
//     final saveLocationResponse = saveLocationResponseFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

SaveLocationResponse saveLocationResponseFromJson(String str) =>
    SaveLocationResponse.fromJson(json.decode(str));

String saveLocationResponseToJson(SaveLocationResponse data) =>
    json.encode(data.toJson());

class SaveLocationResponse extends Equatable {
  final int? requestId;
  final int? minYears;
  final int? maxYears;
  final ContractOptionsResponseDto? contractOptionsResponseDto;
  final List<String>? slamaBillOptions;
  final List<String>? slamaReportOptions;
  final bool? selectLicYears;
  final String? endorsementText;
  final String? boardContractSetting;
  final bool? showSalamaPermit;

  SaveLocationResponse({
    this.requestId,
    this.minYears,
    this.maxYears,
    this.contractOptionsResponseDto,
    this.slamaBillOptions,
    this.slamaReportOptions,
    this.selectLicYears,
    this.endorsementText,
    this.boardContractSetting,
    this.showSalamaPermit,
  });

  factory SaveLocationResponse.fromJson(Map<String, dynamic> json) =>
      SaveLocationResponse(
        requestId: json["requestId"],
        minYears: json["minYears"],
        maxYears: json["maxYears"],
        contractOptionsResponseDto: json["contractOptionsResponseDto"] == null
            ? null
            : ContractOptionsResponseDto.fromJson(
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

  Map<String, dynamic> toJson() => {
        "requestId": requestId,
        "minYears": minYears,
        "maxYears": maxYears,
        "contractOptionsResponseDto": contractOptionsResponseDto?.toJson(),
        "slamaBillOptions": slamaBillOptions == null
            ? []
            : List<dynamic>.from(slamaBillOptions!.map((x) => x)),
        "slamaReportOptions": slamaReportOptions == null
            ? []
            : List<dynamic>.from(slamaReportOptions!.map((x) => x)),
        "selectLicYears": selectLicYears,
        "endorsementText": endorsementText,
        "boardContractSetting": boardContractSetting,
        "showSalamaPermit": showSalamaPermit,
      };

  @override
  // TODO: implement props
  List<Object?> get props {
    return [
      requestId,
      minYears,
      maxYears,
      contractOptionsResponseDto,
      slamaBillOptions,
      slamaReportOptions,
      selectLicYears,
      endorsementText,
      boardContractSetting,
      showSalamaPermit,
    ];
  }
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

  factory ContractOptionsResponseDto.fromJson(Map<String, dynamic> json) =>
      ContractOptionsResponseDto(
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

  Map<String, dynamic> toJson() => {
        "ejarOptions": ejarOptions == null
            ? []
            : List<dynamic>.from(ejarOptions!.map((x) => x)),
        "deedOptions": deedOptions == null
            ? []
            : List<dynamic>.from(deedOptions!.map((x) => x)),
        "investOptions": investOptions == null
            ? []
            : List<dynamic>.from(investOptions!.map((x) => x)),
      };
}
