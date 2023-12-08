class ViolationClassificationResponse {
  final String? subMunicipalityId;
  final String? classificationId;
  final String? subMunicipalityName;
  final String? municipalityName;
  final String? classificationName;
  final String? municipalityId;

  ViolationClassificationResponse({
    this.subMunicipalityId,
    this.classificationId,
    this.subMunicipalityName,
    this.municipalityName,
    this.classificationName,
    this.municipalityId,
  });

  factory ViolationClassificationResponse.fromJson(Map<String, dynamic> json) =>
      ViolationClassificationResponse(
        subMunicipalityId: json["SubMunicipalityID"],
        classificationId: json["ClassificationID"],
        subMunicipalityName: json["SubMunicipalityName"],
        municipalityName: json["MunicipalityName"],
        classificationName: json["ClassificationName"],
        municipalityId: json["MunicipalityID"],
      );

  Map<String, dynamic> toJson() => {
        "SubMunicipalityID": subMunicipalityId,
        "ClassificationID": classificationId,
        "SubMunicipalityName": subMunicipalityName,
        "MunicipalityName": municipalityName,
        "ClassificationName": classificationName,
        "MunicipalityID": municipalityId,
      };
}
