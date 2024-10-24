//
// abstract class ClassificationCertificateLookupsEntity {
//   final List<ClassificationCertificateLookupEntity> types;
//   final List<ClassificationCertificateLookupEntity> sectors;
//   final List<ClassificationCertificateLookupEntity> classificationCertificateLookups;
//   final List<ClassificationCertificateLookupEntity> services;
//   final List<CityEntity> cities;
//
//   ClassificationCertificateLookupsEntity({
//     required this.types,
//     required this.sectors,
//     required this.classificationCertificateLookups,
//     required this.services,
//     required this.cities,
//   });
//
//   ClassificationCertificateLookupsEntity copyWith({
//     List<ClassificationCertificateLookupEntity>? types,
//     List<ClassificationCertificateLookupEntity>? sectors,
//     List<ClassificationCertificateLookupEntity>? classificationCertificateLookups,
//     List<ClassificationCertificateLookupEntity>? services,
//     List<CityEntity>? cities,
//   });
//
//   Map<String, dynamic> toJson();
// }
//
// abstract class CityEntity {
//   final String cityCode;
//   final String city;
//
//   CityEntity({
//     required this.cityCode,
//     required this.city,
//   });
//
//   CityEntity copyWith({
//     String? cityCode,
//     String? city,
//   });
//
//
//   Map<String, dynamic> toJson();
// }
//
// abstract class ClassificationCertificateLookupEntity {
//   final String lookUpType;
//   final String valueAr;
//   final String lookUpCode;
//   final String valueEn;
//   final String code;
//
//   ClassificationCertificateLookupEntity({
//     required this.lookUpType,
//     required this.valueAr,
//     required this.lookUpCode,
//     required this.valueEn,
//     required this.code,
//   });
//
//   ClassificationCertificateLookupEntity copyWith({
//     String? lookUpType,
//     String? valueAr,
//     String? lookUpCode,
//     String? valueEn,
//     String? code,
//   });
//
//
//   Map<String, dynamic> toJson();
// }
