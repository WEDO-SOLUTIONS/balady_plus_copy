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
class NameId {
  @JsonKey(defaultValue: '')
  final String id;
  @JsonKey(defaultValue: '')
  final String name;

  const NameId({required this.id, required this.name});

  NameId._fromInstance(NameId nameId) : id = nameId.id, name = nameId.name;

  @override
  bool operator ==(covariant NameId other) =>
      identical(this, other) || runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => '{id: $id, name: $name}';
}

class AgeRange extends NameId {
  AgeRange.fromJson(Map<String, dynamic> json) : super._fromInstance(_$NameIdFromJson(json));
}

class City extends NameId {
  const City({required super.id, required super.name});

  City.fromJson(Map<String, dynamic> json) : super._fromInstance(_$NameIdFromJson(json));
}

class RecommendedType extends NameId {
  RecommendedType.fromJson(Map<String, dynamic> json) : super._fromInstance(_$NameIdFromJson(json));
}

class Gender extends NameId {
  Gender.fromJson(Map<String, dynamic> json) : super._fromInstance(_$NameIdFromJson(json));
}

class Category extends NameId {
  const Category({
    required super.id,
    required super.name,
  });

  static const eat = 'eat';
  static const shopping = 'shopping';
  static const entertainment = 'entertainment';
  static const beautyAndHealth = 'beautyAndHealth';
  static const homeAndAuto = 'homeAndAuto';
  static const services = 'services';

  /// Display order for categories based on design mockup
  static const displayOrder = [
    eat,
    services,
    entertainment,
    shopping,
    beautyAndHealth,
    homeAndAuto,
  ];

  Category.fromJson(Map<String, dynamic> json) : super._fromInstance(_$NameIdFromJson(json));
}

class OfferType extends NameId {
  OfferType.fromJson(Map<String, dynamic> json) : super._fromInstance(_$NameIdFromJson(json));
}

@noRenameNoToJson
class OfferProvider extends NameId {
  @JsonKey(defaultValue: '')
  final String logo;

  const OfferProvider({
    required this.logo,
    required super.id,
    required super.name,
  });

  factory OfferProvider.fromJson(Map<String, dynamic> json) => _$OfferProviderFromJson(json);
}

class SubCategory extends NameId {
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String categoryId;

  const SubCategory({
    required super.id,
    required super.name,
    this.categoryId = '',
  });

  SubCategory.fromJson(Map<String, dynamic> json) : categoryId = '', super._fromInstance(_$NameIdFromJson(json));
}

@immutable
@noRenameNoToJson
class CategoryWithSubCategories {
  final Category category;
  @JsonKey(defaultValue: [])
  final Iterable<SubCategory> subCategories;

  const CategoryWithSubCategories({
    required this.category,
    required this.subCategories,
  });

  factory CategoryWithSubCategories.fromJson(Map<String, dynamic> json) => _$CategoryWithSubCategoriesFromJson(json);

  @override
  bool operator ==(covariant CategoryWithSubCategories other) {
    if (identical(this, other)) {
      return true;
    }

    return other.category == category && other.subCategories == subCategories;
  }

  @override
  int get hashCode => category.hashCode ^ subCategories.hashCode;
}
