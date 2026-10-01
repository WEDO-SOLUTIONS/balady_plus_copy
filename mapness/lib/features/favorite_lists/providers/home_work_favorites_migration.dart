import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/features/favorite_lists/data/favorite_lists_remote_datasource.dart';
import 'package:mapness/features/favorite_lists/providers/aggregated_favorite_markers.dart';
import 'package:mapness/features/favorite_lists/providers/home_work_favorites.dart';
import 'package:mapness/features/favourites/helpers/favourite_entity_id.dart';
import 'package:mapness/features/favourites/providers/favourite_cache.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_work_favorites_migration.g.dart';

const _migratedFlagPrefix = 'home_work_favorites_migrated_';

/// One-shot migration of the legacy Hive-cached `FavouritesState.home`/`.work` into the new
/// system Home/Work lists (see `home_work_favorites.dart`). Kept separate from
/// `FavoriteListsMigration` (which now excludes home/work from its `legacyPlaceIds` set) so a
/// failure in one doesn't block the other and each retries independently on next app start.
@Riverpod(keepAlive: true)
class HomeWorkFavoritesMigration extends _$HomeWorkFavoritesMigration {
  @override
  Future<void> build() async {
    final authState = await ref.watch(authProvider.future);
    final idNo = authState?.idNo;
    if (idNo == null || idNo.isEmpty) {
      return;
    }

    final prefs = ref.watch(sharedPrefsProvider);
    final flagKey = '$_migratedFlagPrefix$idNo';
    if (prefs.getBool(flagKey) ?? false) {
      return;
    }

    final legacy = await ref.read(favouriteCacheProvider.future);
    if (legacy.home == null && legacy.work == null) {
      await prefs.setBool(flagKey, true);
      return;
    }

    try {
      final dataSource = await ref.read(favoriteListsRemoteDataSourceProvider.future);
      final home = legacy.home;
      if (home != null) {
        final placeId = parseObjectIdFromFavouriteEntityId(home.entity?.id)?.toString();
        if (placeId != null) {
          final listId = await ref.read(homeListIdProvider.future);
          await dataSource.addPlaceToList(listId, placeId);
        }
      }
      final work = legacy.work;
      if (work != null) {
        final placeId = parseObjectIdFromFavouriteEntityId(work.entity?.id)?.toString();
        if (placeId != null) {
          final listId = await ref.read(workListIdProvider.future);
          await dataSource.addPlaceToList(listId, placeId);
        }
      }
      await prefs.setBool(flagKey, true);
      ref
        ..invalidate(homeWorkFavoritesProvider)
        ..invalidate(aggregatedFavoriteMarkersProvider);
    } on Exception catch (e) {
      logger.log('Home/Work favorites migration failed: $e', logLevel: MapnessLogLevel.warning);
    }
  }
}
