
import 'city_lookups_model.dart';
import 'classification_certificate_lookup_model.dart';

class ClassificationCertificateLookupsModel  {
  final List<ClassificationCertificateLookupModel> types;
  final List<ClassificationCertificateLookupModel> sectors;
  final List<ClassificationCertificateLookupModel> classificationCertificateLookups;
  final List<ClassificationCertificateLookupModel> services;
  final List<CityLookupsModel> cities;

  ClassificationCertificateLookupsModel({
    required this.types,
    required this.sectors,
    required this.classificationCertificateLookups,
    required this.services,
    required this.cities,
  });

  ClassificationCertificateLookupsModel copyWith({
    List<ClassificationCertificateLookupModel>? types,
    List<ClassificationCertificateLookupModel>? sectors,
    List<ClassificationCertificateLookupModel>? classificationCertificateLookups,
    List<ClassificationCertificateLookupModel>? services,
    List<CityLookupsModel>? cities,
  }) =>
      ClassificationCertificateLookupsModel(
        types: types ?? this.types,
        sectors: sectors ?? this.sectors,
        classificationCertificateLookups: classificationCertificateLookups ?? this.classificationCertificateLookups,
        services: services ?? this.services,
        cities: cities ?? this.cities,
      );

  factory ClassificationCertificateLookupsModel.fromJson(Map<String, dynamic> json) => ClassificationCertificateLookupsModel(
    types: List<ClassificationCertificateLookupModel>.from(json["types"]['items'].map((x) => ClassificationCertificateLookupModel.fromJson(x))),
    sectors: List<ClassificationCertificateLookupModel>.from(json["sectors"]['items'].map((x) => ClassificationCertificateLookupModel.fromJson(x))),
    classificationCertificateLookups: List<ClassificationCertificateLookupModel>.from(json["degrees"]['items'].map((x) => ClassificationCertificateLookupModel.fromJson(x))),
    services: List<ClassificationCertificateLookupModel>.from(json["services"]['items'].map((x) => ClassificationCertificateLookupModel.fromJson(x))),
    cities: List<CityLookupsModel>.from(json["cities"]['items'].map((x) => CityLookupsModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "types": List<dynamic>.from(types.map((x) => x.toJson())),
    "sectors": List<dynamic>.from(sectors.map((x) => x.toJson())),
    "ClassificationCertificateLookups": List<dynamic>.from(classificationCertificateLookups.map((x) => x.toJson())),
    "services": List<dynamic>.from(services.map((x) => x.toJson())),
    "cities": List<dynamic>.from(cities.map((x) => x.toJson())),
  };
}


