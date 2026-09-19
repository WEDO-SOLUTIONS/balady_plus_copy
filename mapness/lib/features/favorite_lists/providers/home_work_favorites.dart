import 'package:collection/collection.dart';
import 'package:mapness/entities/favourites/favourite_item.dart';
import 'package:mapness/features/favorite_lists/data/favorite_lists_api_exception.dart';
import 'package:mapness/features/favorite_lists/data/favorite_lists_remote_datasource.dart';
import 'package:mapness/features/favorite_lists/data/models/favorite_list_dto.dart';
import 'package:mapness/features/favorite_lists/data/models/icon_type.dart';
import 'package:mapness/features/favorite_lists/data/models/marker_color_code.dart';
import 'package:mapness/features/favorite_lists/providers/favorite_list_place_poi.dart';
import 'package:mapness/features/favourites/helpers/favourite_entity_id.dart';
import 'package:mapness/features/favourites/mappers/directory_object_message_mapper.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_work_favorites.g.dart';

/// Reserved list names used to store Home/Work as regular list memberships in the new
/// favorite_lists API, instead of the buggy legacy `favourites`/`favouriteCacheProvider` flow.
///
/// Deliberately NOT using `customName` to tag a place as home/work inside a single shared list:
/// `customName` is a global per-place nickname shared across every list the place belongs to
/// (confirmed via `PUT/GET/DELETE /places/:placeId/custom-name`, which takes no listId), so any
/// sentinel written there would leak into/clobber a real user-set nickname on any other list
/// containing the same place. Two separate hidden lists, discriminated by membership, avoid that
/// collision entirely.
const systemHomeListName = '__system_home__';
const systemWorkListName = '__system_work__';

class HomeWorkFavorites {
  final FavouriteItem? home;
  final FavouriteItem? work;

  const HomeWorkFavorites({this.home, this.work});

  /// "Home"/"Work" if [objectId] matches the saved slot, so a POI card can show that
  /// instead of falling back to a raw address/"Dropped Pin" title.
  String? titleFor(int? objectId, AppLocalizations l10n) {
    if (objectId == null) {
      return null;
    }
    if (parseObjectIdFromFavouriteEntityId(home?.entity?.id) == objectId) {
      return l10n.home;
    }
    if (parseObjectIdFromFavouriteEntityId(work?.entity?.id) == objectId) {
      return l10n.work;
    }
    return null;
  }
}

Future<String> _getOrCreateSystemListId(
  FavoriteListsRemoteDataSource dataSource,
  String name, {
  required MarkerColorCode markerColorCode,
  required FavoriteIconType iconType,
}) async {
  final existing = (await dataSource.getFavoriteLists()).lists.firstWhereOrNull((list) => list.name == name);
  if (existing != null) {
    return existing.id;
  }
  try {
    final created = await dataSource.createFavoriteList(
      FavoriteListRequestDto(name: name, markerColorCode: markerColorCode, iconType: iconType),
    );
    return created.list.id;
  } on FavoriteListsApiException catch (e) {
    // Lost a create race against another request (e.g. concurrent migration + manual set) —
    // the list that won is already there, use it instead of failing.
    if (e.code == 'DUPLICATE_LIST_NAME') {
      final refetched = (await dataSource.getFavoriteLists()).lists.firstWhereOrNull((list) => list.name == name);
      if (refetched != null) {
        return refetched.id;
      }
    }
    rethrow;
  }
}

@Riverpod(keepAlive: true)
Future<String> homeListId(Ref ref) async {
  // Rebuilds (and re-resolves the list id) whenever the signed-in user changes.
  await ref.watch(authProvider.future);
  final dataSource = await ref.watch(favoriteListsRemoteDataSourceProvider.future);
  return _getOrCreateSystemListId(
    dataSource,
    systemHomeListName,
    markerColorCode: MarkerColorCode.green,
    iconType: FavoriteIconType.home,
  );
}

@Riverpod(keepAlive: true)
Future<String> workListId(Ref ref) async {
  await ref.watch(authProvider.future);
  final dataSource = await ref.watch(favoriteListsRemoteDataSourceProvider.future);
  return _getOrCreateSystemListId(
    dataSource,
    systemWorkListName,
    markerColorCode: MarkerColorCode.green,
    iconType: FavoriteIconType.building,
  );
}

Future<FavouriteItem?> _readSlot(Ref ref, String listId) async {
  final dataSource = await ref.watch(favoriteListsRemoteDataSourceProvider.future);
  final detail = await dataSource.getFavoriteListById(listId);
  final place = detail.list.places?.firstOrNull;
  if (place == null) {
    return null;
  }
  final objectId = int.tryParse(place.placeId);
  if (objectId == null) {
    return null;
  }
  final poi = await ref.watch(favoriteListPlacePoiProvider(objectId).future);
  return poi?.mapToFavourite();
}

@riverpod
Future<HomeWorkFavorites> homeWorkFavorites(Ref ref) async {
  final homeId = await ref.watch(homeListIdProvider.future);
  final workId = await ref.watch(workListIdProvider.future);
  final home = await _readSlot(ref, homeId);
  final work = await _readSlot(ref, workId);
  return HomeWorkFavorites(home: home, work: work);
}

@Riverpod(keepAlive: true)
class HomeWorkFavoritesActions extends _$HomeWorkFavoritesActions {
  @override
  void build() {}

  Future<void> setHome(FavouriteItem item) => _setSlot(isHome: true, item: item);

  Future<void> setWork(FavouriteItem item) => _setSlot(isHome: false, item: item);

  Future<void> deleteHome() => _clearSlot(isHome: true);

  Future<void> deleteWork() => _clearSlot(isHome: false);

  /// For call sites that only have a [FavouriteItem] (e.g. a generic delete action on a
  /// favourites list row) and don't know upfront whether it is the home or work slot.
  Future<void> deleteIfHomeOrWork(FavouriteItem item) async {
    final current = await ref.read(homeWorkFavoritesProvider.future);
    if (current.home?.id == item.id) {
      await deleteHome();
    } else if (current.work?.id == item.id) {
      await deleteWork();
    }
  }

  Future<void> _setSlot({required bool isHome, required FavouriteItem item}) async {
    final placeId = parseObjectIdFromFavouriteEntityId(item.entity?.id)?.toString();
    if (placeId == null) {
      return;
    }
    final listId = await ref.read(isHome ? homeListIdProvider.future : workListIdProvider.future);
    final dataSource = await ref.read(favoriteListsRemoteDataSourceProvider.future);
    final current = await ref.read(homeWorkFavoritesProvider.future);
    final existing = isHome ? current.home : current.work;
    if (existing != null && existing.id != item.id) {
      final existingPlaceId = parseObjectIdFromFavouriteEntityId(existing.entity?.id)?.toString();
      if (existingPlaceId != null) {
        await dataSource.removePlaceFromList(listId, existingPlaceId);
      }
    }
    await dataSource.addPlaceToList(listId, placeId);
    ref.invalidate(homeWorkFavoritesProvider);
  }

  Future<void> _clearSlot({required bool isHome}) async {
    final current = await ref.read(homeWorkFavoritesProvider.future);
    final item = isHome ? current.home : current.work;
    if (item == null) {
      return;
    }
    final placeId = parseObjectIdFromFavouriteEntityId(item.entity?.id)?.toString();
    if (placeId == null) {
      return;
    }
    final listId = await ref.read(isHome ? homeListIdProvider.future : workListIdProvider.future);
    final dataSource = await ref.read(favoriteListsRemoteDataSourceProvider.future);
    await dataSource.removePlaceFromList(listId, placeId);
    ref.invalidate(homeWorkFavoritesProvider);
  }
}
