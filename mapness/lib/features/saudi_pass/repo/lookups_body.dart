import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mapness/features/saudi_pass/repo/momra_body.dart';

part 'lookups_body.g.dart';

@noRenameNoToJson
class LookupsBody extends MomraBody<Lookups, LookupsData> {
  LookupsBody({required super.statusDetails, super.data});

  factory LookupsBody.fromJson(Map<String, dynamic> json) => _$LookupsBodyFromJson(json);
}

@noRenameNoToJson
class LookupsData extends Data<Lookups> {
  LookupsData({
    required super.responseCode,
    required super.responseMessage,
    required super.responseId,
    required super.result,
  });

  factory LookupsData.fromJson(Map<String, dynamic> json) => _$LookupsDataFromJson(json);
}

@noRenameNoToJson
class Lookups {
  final Iterable<AgeRange> ageRanges;
  final Iterable<City> cities;
  final Iterable<RecommendedType> recommendedTypes;
  final Iterable<Gender> genders;
  final Iterable<Category> categories;

  Lookups({
    required this.ageRanges,
    required this.cities,
    required this.recommendedTypes,
    required this.genders,
    required this.categories,
  });

  factory Lookups.fromJson(Map<String, dynamic> json) => _$LookupsFromJson(json);
}

@immutable
@noRenameNoToJson
class _NameId {
  final String id;
  final String name;

  const _NameId({required this.id, required this.name});

  _NameId._fromInstance(_NameId nameId)
      : id = nameId.id,
        name = nameId.name;

  @override
  bool operator ==(covariant _NameId other) =>
      identical(this, other) || runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => '{id: $id, name: $name}';
}

class AgeRange extends _NameId {
  AgeRange.fromJson(Map<String, dynamic> json) : super._fromInstance(_$NameIdFromJson(json));
}

class City extends _NameId {
  City.fromJson(Map<String, dynamic> json) : super._fromInstance(_$NameIdFromJson(json));
}

class RecommendedType extends _NameId {
  RecommendedType.fromJson(Map<String, dynamic> json) : super._fromInstance(_$NameIdFromJson(json));
}

class Gender extends _NameId {
  Gender.fromJson(Map<String, dynamic> json) : super._fromInstance(_$NameIdFromJson(json));
}

class Category extends _NameId {
  Category.fromJson(Map<String, dynamic> json) : super._fromInstance(_$NameIdFromJson(json));
}

class OfferType extends _NameId {
  OfferType.fromJson(Map<String, dynamic> json) : super._fromInstance(_$NameIdFromJson(json));
}

@noRenameNoToJson
class OfferProvider extends _NameId {
  final String logo;

  const OfferProvider({required this.logo, required super.id, required super.name});

  factory OfferProvider.fromJson(Map<String, dynamic> json) => _$OfferProviderFromJson(json);
}
