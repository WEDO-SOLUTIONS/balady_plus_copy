import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mapness/features/saudi_pass/repo/lookups_body.dart';
import 'package:mapness/features/saudi_pass/repo/momra_body.dart';

part 'get_preferences_body.g.dart';

@noRenameNoToJson
class GetPreferencesBody extends MomraBody<Preferences, PreferencesData> {
  GetPreferencesBody({required super.statusDetails, super.data});

  factory GetPreferencesBody.fromJson(Map<String, dynamic> json) => _$GetPreferencesBodyFromJson(json);
}

@noRenameNoToJson
class PreferencesData extends Data<Preferences> {
  PreferencesData({
    required super.responseCode,
    required super.responseMessage,
    required super.responseId,
    required super.result,
  });

  factory PreferencesData.fromJson(Map<String, dynamic> json) => _$PreferencesDataFromJson(json);
}

@noRenameNoToJson
@immutable
class Preferences {
  final String id;
  final String? mobile;
  final String? birthDate;
  final Gender? gender;
  final bool saudi;
  @JsonKey(defaultValue: {})
  final Iterable<City> cities;
  @JsonKey(defaultValue: {})
  final Iterable<Category> categories;
  @JsonKey(defaultValue: {})
  final Iterable<RecommendedType> recommendedTypes;
  final bool receiveNearbyDeals;
  final bool receiveNewOpeningDeals;

  Preferences({
    required this.id,
    required this.mobile,
    required this.birthDate,
    required this.gender,
    required this.saudi,
    required this.cities,
    required this.categories,
    required this.recommendedTypes,
    required this.receiveNearbyDeals,
    required this.receiveNewOpeningDeals,
  }) : isNotPopulated = !(cities.isNotEmpty |categories.isNotEmpty | recommendedTypes.isNotEmpty);

  final bool isNotPopulated;

  factory Preferences.fromJson(Map<String, dynamic> json) => _$PreferencesFromJson(json);

  static const iterableEquality = IterableEquality();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Preferences &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          mobile == other.mobile &&
          birthDate == other.birthDate &&
          gender == other.gender &&
          saudi == other.saudi &&
          iterableEquality.equals(cities, other.cities) &&
          iterableEquality.equals(categories, other.categories) &&
          iterableEquality.equals(recommendedTypes, other.recommendedTypes) &&
          receiveNearbyDeals == other.receiveNearbyDeals &&
          receiveNewOpeningDeals == other.receiveNewOpeningDeals;

  @override
  int get hashCode =>
      id.hashCode ^
      mobile.hashCode ^
      birthDate.hashCode ^
      gender.hashCode ^
      saudi.hashCode ^
      cities.hashCode ^
      categories.hashCode ^
      recommendedTypes.hashCode ^
      receiveNearbyDeals.hashCode ^
      receiveNewOpeningDeals.hashCode;
}
