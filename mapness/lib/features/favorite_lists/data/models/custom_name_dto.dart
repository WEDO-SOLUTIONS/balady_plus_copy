import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mapness/features/favorite_lists/data/models/place_type.dart';

part 'custom_name_dto.freezed.dart';

part 'custom_name_dto.g.dart';

@freezed
abstract class CustomNameRequestDto with _$CustomNameRequestDto {
  factory CustomNameRequestDto({
    required final String customName,
  }) = _CustomNameRequestDto;

  factory CustomNameRequestDto.fromJson(Map<String, dynamic> json) => _$CustomNameRequestDtoFromJson(json);
}

@freezed
abstract class CustomNameResponseDto with _$CustomNameResponseDto {
  factory CustomNameResponseDto({
    required final String placeId,
    required final PlaceType placeType,
    required final String? customName,
  }) = _CustomNameResponseDto;

  factory CustomNameResponseDto.fromJson(Map<String, dynamic> json) => _$CustomNameResponseDtoFromJson(json);
}

@freezed
abstract class DeleteCustomNameResultDto with _$DeleteCustomNameResultDto {
  factory DeleteCustomNameResultDto({
    required final String placeId,
    required final PlaceType placeType,
    required final bool deleted,
  }) = _DeleteCustomNameResultDto;

  factory DeleteCustomNameResultDto.fromJson(Map<String, dynamic> json) => _$DeleteCustomNameResultDtoFromJson(json);
}
