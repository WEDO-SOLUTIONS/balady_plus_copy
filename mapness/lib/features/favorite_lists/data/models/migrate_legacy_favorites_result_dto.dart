import 'package:freezed_annotation/freezed_annotation.dart';

part 'migrate_legacy_favorites_result_dto.freezed.dart';

part 'migrate_legacy_favorites_result_dto.g.dart';

@freezed
abstract class MigrateLegacyFavoritesResultDto with _$MigrateLegacyFavoritesResultDto {
  factory MigrateLegacyFavoritesResultDto({
    required final bool alreadyMigrated,
    required final bool showMigrationBanner,
  }) = _MigrateLegacyFavoritesResultDto;

  factory MigrateLegacyFavoritesResultDto.fromJson(Map<String, dynamic> json) =>
      _$MigrateLegacyFavoritesResultDtoFromJson(json);
}
