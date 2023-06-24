// To parse this JSON data, do
//
//     final daemSubMunicipalityResponse = daemSubMunicipalityResponseFromJson(jsonString);

import 'dart:convert';

import '../../../transaction_inquiry/presentation/core/models/error_result.dart';
import 'daem_item.dart';

DaemSubMunicipalityResponse daemSubMunicipalityResponseFromJson(String str) =>
    DaemSubMunicipalityResponse.fromJson(json.decode(str));

String daemSubMunicipalityResponseToJson(DaemSubMunicipalityResponse data) =>
    json.encode(data.toJson());

class DaemSubMunicipalityResponse {
  DaemSubMunicipalityResponse({
    this.amanaBaladiahList,
    this.errors,
  });

  List<AmanaBaladiahList>? amanaBaladiahList;
  List<ErrorResult>? errors;

  factory DaemSubMunicipalityResponse.fromJson(Map<String, dynamic> json) =>
      DaemSubMunicipalityResponse(
          amanaBaladiahList: json["AmanaBaladiahList"] != null
              ? List<AmanaBaladiahList>.from(json["AmanaBaladiahList"]
                  .map((x) => AmanaBaladiahList.fromJson(x)))
              : null,
          errors: json["errors"] != null
              ? List<ErrorResult>.from(
                  json["errors"].map((x) => ErrorResult.fromJson(x)))
              : []);

  Map<String, dynamic> toJson() => {
        "AmanaBaladiahList":
            List<dynamic>.from(amanaBaladiahList!.map((x) => x.toJson())),
        "errors": List<dynamic>.from(errors!.map((x) => x)),
      };

  List<DaemItem>? getList() {
    return amanaBaladiahList
        ?.map((e) => DaemItem(id: e.baladiah ?? "", name: e.baladiahAR ?? ""))
        .toList();
  }
}

class AmanaBaladiahList {
  AmanaBaladiahList({this.amanat, this.baladiah, this.baladiahAR});

  String? amanat;
  String? baladiah;
  String? baladiahAR;

  factory AmanaBaladiahList.fromJson(Map<String, dynamic> json) =>
      AmanaBaladiahList(
          amanat: json["Amanat"],
          baladiah: json["Baladiah"],
          baladiahAR: json["BaladiahAR"]);

  Map<String, dynamic> toJson() =>
      {"Amanat": amanat, "Baladiah": baladiah, "BaladiahAR": baladiahAR};
}
