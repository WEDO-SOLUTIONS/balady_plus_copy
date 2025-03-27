import 'package:json_annotation/json_annotation.dart';
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
  });

  bool get isNotPopulated => cities.isEmpty;

  factory Preferences.fromJson(Map<String, dynamic> json) => _$PreferencesFromJson(json);
}
