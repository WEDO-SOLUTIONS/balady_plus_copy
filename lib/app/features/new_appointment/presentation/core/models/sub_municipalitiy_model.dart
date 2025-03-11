import 'dart:convert';

SubMunicipality subMunicipalityFromJson(String str) =>
    SubMunicipality.fromJson(json.decode(str));

String subMunicipalityToJson(SubMunicipality data) =>
    json.encode(data.toJson());

class SubMunicipality {
  SubMunicipality({
    this.statusDetails,
    this.data,
  });
  
  SubMunicipalityStatusDetail? statusDetails;
  SubMunicipalityData? data;
  
  factory SubMunicipality.fromJson(Map<String, dynamic> json) =>
      SubMunicipality(
        statusDetails: json["statusDetails"] == null
            ? null
            : SubMunicipalityStatusDetail.fromJson(json["statusDetails"]),
        data: json["data"] == null
            ? null
            : SubMunicipalityData.fromJson(json["data"]),
      );
  
  Map<String, dynamic> toJson() => {
        "statusDetails": statusDetails == null
            ? null
            : statusDetails!.toJson(),
        "data": data == null ? null : data!.toJson(),
      };
}

class SubMunicipalityData {
  SubMunicipalityData({
    this.responseCode,
    this.responseMessage,
    this.result,
  });

  dynamic responseCode;
  String? responseMessage;
  List<SubMunicipalityItem>? result;

  factory SubMunicipalityData.fromJson(Map<String, dynamic> json) =>
      SubMunicipalityData(
        responseCode: json["responseCode"],
        responseMessage: json["responseMessage"],
        result: json["result"] == null
            ? null
            : List<SubMunicipalityItem>.from(
                json["result"].map((x) => SubMunicipalityItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "responseCode": responseCode,
        "responseMessage": responseMessage,
        "result": result == null
            ? null
            : List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class SubMunicipalityItem {
  SubMunicipalityItem({
    this.id,
    this.amanaId,
    this.name,
    this.baladyCityId,
    this.segmantId,
  });

  String? id;
  dynamic amanaId;
  String? name;
  int? baladyCityId;
  int? segmantId;

  factory SubMunicipalityItem.fromJson(Map<String, dynamic> json) =>
      SubMunicipalityItem(
        id: json["id"],
        amanaId: json["amanaId"],
        name: json["name"],
        baladyCityId: json["baladyCityId"],
        segmantId: json["segmantId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "amanaId": amanaId,
        "name": name,
        "baladyCityId": baladyCityId,
        "segmantId": segmantId,
      };
}

class SubMunicipalityStatusDetail {
  SubMunicipalityStatusDetail({
    this.code,
    this.message,
  });

  int? code;
  String? message;

  factory SubMunicipalityStatusDetail.fromJson(Map<String, dynamic> json) =>
      SubMunicipalityStatusDetail(
        code: json["code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
      };
}
