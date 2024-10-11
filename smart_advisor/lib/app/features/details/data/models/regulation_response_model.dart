import '/app/features/details/domain/entities/regulation_response.dart';

class RegulationResponseModel extends RegulationResponse {
  RegulationResponseModel({
    required super.generalRules,
    required super.specialRules,
    required super.locationRules,
  });

  factory RegulationResponseModel.fromJson(Map<String, dynamic> json) =>
      RegulationResponseModel(
        generalRules: List<String>.from(json["generalRules"].map((x) => x)),
        specialRules: List<String>.from(json["specialRules"].map((x) => x)),
        locationRules: List<String>.from(json["locationRules"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "generalRules": List<dynamic>.from(generalRules.map((x) => x)),
        "specialRules": List<dynamic>.from(specialRules.map((x) => x)),
        "locationRules": List<dynamic>.from(locationRules.map((x) => x)),
      };
}
