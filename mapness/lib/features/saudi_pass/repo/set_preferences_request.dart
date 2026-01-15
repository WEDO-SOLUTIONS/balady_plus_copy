import 'package:freezed_annotation/freezed_annotation.dart';

part 'set_preferences_request.freezed.dart';
part 'set_preferences_request.g.dart';

// ignore_for_file: invalid_annotation_target

@Freezed(toJson: true, fromJson: false)
class SetPreferencesRequest with _$SetPreferencesRequest {
  factory SetPreferencesRequest({
    final String? mobile,
    final String? birthDate,
    @JsonKey(name: 'gender') final String? genderId,
    final List<String>? cities,
    final List<CategoryRequest>? categories,
    final List<String>? recommendedTypes,
    final bool? receiveNearbyDeals,
    final bool? receiveNewOpeningDeals,
  }) = _SetPreferencesRequest;
}

@Freezed(toJson: true, fromJson: false)
class CategoryRequest with _$CategoryRequest {
  factory CategoryRequest({
    required final String id,
    @Default([]) final List<String> subCategories,
  }) = _CategoryRequest;
}
