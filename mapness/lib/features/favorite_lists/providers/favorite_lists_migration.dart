import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/features/favorite_lists/data/favorite_lists_remote_datasource.dart';
import 'package:mapness/features/favorite_lists/data/models/migrate_legacy_favorites_result_dto.dart';
import 'package:mapness/features/favourites/providers/favourite_cache.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favorite_lists_migration.g.dart';

const _migratedFlagPrefix = 'favorite_lists_migrated_';

@Riverpod(keepAlive: true)
class FavoriteListsMigration extends _$FavoriteListsMigration {
  @override
  Future<MigrateLegacyFavoritesResultDto?> build() async {
    final authState = await ref.watch(authProvider.future);
    final idNo = authState?.idNo;
    if (idNo == null || idNo.isEmpty) {
      return null;
    }

    final prefs = ref.watch(sharedPrefsProvider);
    final flagKey = '$_migratedFlagPrefix$idNo';
    if (prefs.getBool(flagKey) ?? false) {
      return null;
    }

    final legacy = await ref.read(favouriteCacheProvider.future);
    final legacyPlaceIds = {
      ...legacy.items.map((e) => e.id),
      if (legacy.home != null) legacy.home!.id,
      if (legacy.work != null) legacy.work!.id,
    }.toList();

    if (legacyPlaceIds.isEmpty) {
      await prefs.setBool(flagKey, true);
      return null;
    }

    try {
      final dataSource = await ref.read(favoriteListsRemoteDataSourceProvider.future);
      final result = await dataSource.migrateLegacyFavorites(legacyPlaceIds);
      await prefs.setBool(flagKey, true);
      logger.log(
        'Favorite lists migration succeeded: alreadyMigrated=${result.alreadyMigrated}, '
        'showMigrationBanner=${result.showMigrationBanner}',
        logLevel: MapnessLogLevel.info,
      );
      return result;
    } on Exception catch (e) {
      logger.log('Favorite lists migration failed: $e', logLevel: MapnessLogLevel.warning);
      return null;
    }
  }
}
