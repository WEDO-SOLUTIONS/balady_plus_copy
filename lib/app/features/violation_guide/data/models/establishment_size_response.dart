// To parse this JSON data, do
//
//     final establishmentSizeResponse = establishmentSizeResponseFromJson(jsonString);

import 'dart:convert';

EstablishmentSizeResponse establishmentSizeResponseFromJson(String str) =>
    EstablishmentSizeResponse.fromJson(json.decode(str));

String establishmentSizeResponseToJson(EstablishmentSizeResponse data) =>
    json.encode(data.toJson());

class EstablishmentSizeResponse {
  final List<EstablishmentSizeItem>? result;

  EstablishmentSizeResponse({
    this.result,
  });

  factory EstablishmentSizeResponse.fromJson(Map<String, dynamic> json) =>
      EstablishmentSizeResponse(
        result: json["result"] == null
            ? []
            : List<EstablishmentSizeItem>.from(
                json["result"]!.map((x) => EstablishmentSizeItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result == null
            ? []
            : List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class EstablishmentSizeItem {
  final String? establishmentSizeName;
  final int? establishmentsizeId;

  EstablishmentSizeItem({
    this.establishmentSizeName,
    this.establishmentsizeId,
  });

  factory EstablishmentSizeItem.fromJson(Map<String, dynamic> json) =>
      EstablishmentSizeItem(
        establishmentSizeName: json["EstablishmentSizeName"],
        establishmentsizeId: json["EstablishmentsizeID"],
      );

  Map<String, dynamic> toJson() => {
        "EstablishmentSizeName": establishmentSizeName,
        "EstablishmentsizeID": establishmentsizeId,
      };

  String get text => establishmentSizeName ?? "";
}
