import 'dart:convert';

Municipality municipalityFromJson(String str) =>
    Municipality.fromJson(json.decode(str));

String municipalityToJson(Municipality data) => json.encode(data.toJson());

class Municipality {
  Municipality({
    this.statusDetails,
    this.data,
  });

  StatusDetail? statusDetails;
  Data? data;

    // factory AppointmentDetails.fromJson(Map<String, dynamic> json) =>
    //   AppointmentDetails(
    //     statusDetails: json["statusDetails"] == null
    //         ? null
    //         : StatusDetail.fromJson(json["statusDetails"]),
    //     data: json["data"] == null ? null : Data.fromJson(json["data"]),
    //   );

  factory Municipality.fromJson(Map<String, dynamic> json) => Municipality(
            statusDetails: json["statusDetails"] == null
            ? null
            : StatusDetail.fromJson(json["statusDetails"]),
        data: json["data"] != null ? Data.fromJson(json["data"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "statusDetails": statusDetails?.toJson(),
        "data": data!.toJson(),
      };
}

class Data {
  Data({
    this.responseCode,
    this.responseMessage,
    this.result,
  });

  String? responseCode;
  String? responseMessage;
  List<MunicipalityItem>? result;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        responseCode: json["responseCode"],
        responseMessage: json["responseMessage"],
        result: json["result"] != null
            ? List<MunicipalityItem>.from(
                json["result"].map((x) => MunicipalityItem.fromJson(x)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "responseCode": responseCode,
        "responseMessage": responseMessage,
        "result": List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class MunicipalityItem {
  MunicipalityItem({
    this.id,
    this.amanaId,
    this.name,
    this.externalSystemUrl,
    this.externalSystem,
  });

  String? id;
  dynamic amanaId;
  String? name;
  String? externalSystemUrl;
  bool? externalSystem;

  factory MunicipalityItem.fromJson(Map<String, dynamic> json) =>
      MunicipalityItem(
        id: json["id"],
        amanaId: json["amanaId"],
        name: json["name"],
        externalSystemUrl: json["externalSystemUrl"],
        externalSystem: json["externalSystem"],

      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "amanaId": amanaId,
        "name": name,
      };
}

class StatusDetail {
  StatusDetail({
    this.code,
    this.message,
  });

  int? code;
  String? message;

  factory StatusDetail.fromJson(Map<String, dynamic> json) => StatusDetail(
        code: json["code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
      };
}
