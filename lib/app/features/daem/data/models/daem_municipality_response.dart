// To parse this JSON data, do
//
//     final daemMunicipalityResponse = daemMunicipalityResponseFromJson(jsonString);

import 'dart:convert';

import '../../../transaction_inquiry/presentation/core/models/error_result.dart';
import 'daem_item.dart';

DaemMunicipalityResponse daemMunicipalityResponseFromJson(String str) =>
    DaemMunicipalityResponse.fromJson(json.decode(str));

String daemMunicipalityResponseToJson(DaemMunicipalityResponse data) =>
    json.encode(data.toJson());

class DaemMunicipalityResponse {
  DaemMunicipalityResponse({
    this.amanaBaladiahList,
    this.errors,
  });

  List<AmanaBaladiahList>? amanaBaladiahList;
  List<ErrorResult>? errors;

  factory DaemMunicipalityResponse.fromJson(Map<String, dynamic> json) =>
      DaemMunicipalityResponse(
        amanaBaladiahList: json["AmanaBaladiahList"] != null
            ? List<AmanaBaladiahList>.from(json["AmanaBaladiahList"]
                .map((x) => AmanaBaladiahList.fromJson(x)))
            : null,
        errors: json["errors"] != null
            ? List<ErrorResult>.from(
                json["errors"].map((x) => ErrorResult.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "AmanaBaladiahList":
            List<dynamic>.from(amanaBaladiahList!.map((x) => x.toJson())),
        "errors": List<dynamic>.from(errors!.map((x) => x)),
      };

  List<DaemItem>? getList() {
    return amanaBaladiahList
        ?.map((e) => DaemItem(id: e.amanat ?? "", name: e.amanaAR ?? ""))
        .toList();
  }
}

class AmanaBaladiahList {
  AmanaBaladiahList({this.amanat, this.amanaAR});

  String? amanat;
  String? amanaAR;

  factory AmanaBaladiahList.fromJson(Map<String, dynamic> json) =>
      AmanaBaladiahList(amanat: json["Amanat"], amanaAR: json["AmanaAR"]);

  Map<String, dynamic> toJson() => {"Amanat": amanat, "AmanaAR": amanaAR};
}
