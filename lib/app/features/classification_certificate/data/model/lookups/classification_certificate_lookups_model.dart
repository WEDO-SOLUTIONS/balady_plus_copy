
import 'city_lookups_model.dart';
import 'classification_certificate_lookup_model.dart';

class ClassificationCertificateLookupsModel  {
  final List<ClassificationCertificateLookupModel> classificationType;
  final List<ClassificationCertificateLookupModel> sectors;
  final List<ClassificationCertificateLookupModel> degrees;
  final List<ClassificationCertificateLookupModel> services;
  final List<CityLookupsModel> cities;

  ClassificationCertificateLookupsModel({
    required this.classificationType,
    required this.sectors,
    required this.degrees,
    required this.services,
    required this.cities,
  });

  ClassificationCertificateLookupsModel copyWith({
    List<ClassificationCertificateLookupModel>? classificationType,
    List<ClassificationCertificateLookupModel>? sectors,
    List<ClassificationCertificateLookupModel>? degrees,
    List<ClassificationCertificateLookupModel>? services,
    List<CityLookupsModel>? cities,
  }) =>
      ClassificationCertificateLookupsModel(
        classificationType: classificationType ?? this.classificationType,
        sectors: sectors ?? this.sectors,
        degrees: degrees ?? this.degrees,
        services: services ?? this.services,
        cities: cities ?? this.cities,
      );

  factory ClassificationCertificateLookupsModel.fromJson(Map<String, dynamic> json) => ClassificationCertificateLookupsModel(
    classificationType: List<ClassificationCertificateLookupModel>.from(json["types"]['items'].map((x) => ClassificationCertificateLookupModel.fromJson(x))),
    sectors: List<ClassificationCertificateLookupModel>.from(json["sectors"]['items'].map((x) => ClassificationCertificateLookupModel.fromJson(x))),
    degrees: List<ClassificationCertificateLookupModel>.from(json["degrees"]['items'].map((x) => ClassificationCertificateLookupModel.fromJson(x))),
    services: List<ClassificationCertificateLookupModel>.from(json["services"]['items'].map((x) => ClassificationCertificateLookupModel.fromJson(x))),
    cities: List<CityLookupsModel>.from(json["cities"]['items'].map((x) => CityLookupsModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "types": List<dynamic>.from(classificationType.map((x) => x.toJson())),
    "sectors": List<dynamic>.from(sectors.map((x) => x.toJson())),
    "ClassificationCertificateLookups": List<dynamic>.from(degrees.map((x) => x.toJson())),
    "services": List<dynamic>.from(services.map((x) => x.toJson())),
    "cities": List<dynamic>.from(cities.map((x) => x.toJson())),
  };
}


