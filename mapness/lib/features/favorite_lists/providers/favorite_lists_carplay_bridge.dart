import 'dart:ui';

import 'package:dgis_map/library.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mapness/features/favorite_lists/data/models/favorite_list_dto.dart';
import 'package:mapness/features/favorite_lists/data/models/favorite_list_place_dto.dart';
import 'package:mapness/features/favorite_lists/data/models/marker_color_code.dart';
import 'package:mapness/features/favorite_lists/providers/favorite_list_detail.dart';
import 'package:mapness/features/favorite_lists/providers/favorite_list_place_poi.dart';
import 'package:mapness/features/favorite_lists/providers/favorite_lists.dart';
import 'package:mapness/features/poi_card/extensions/geopoint_mapper.dart';
import 'package:mapness/shared/lib/make_address.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/utils/logger/logger.dart';

extension on Color {
  String get hexValue => '#${(value & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
}

String _colorHex(FavoriteListDto list) {
  final apiHex = list.markerColor?.hexValue;
  if (apiHex != null && apiHex.isNotEmpty) {
    return apiHex;
  }
  return list.markerColorCode.color.hexValue;
}

String _subtitle(FavoriteListDto list, String languageCode) {
  final dateFormat = DateFormat('dd.MM.yy', languageCode);
  final placeCount = list.placeCount ?? 0;
  // TODO(claude): localize string and handle Arabic plural forms properly
  return [
    'Created ${dateFormat.format(list.createdAt)}',
    'Modified ${dateFormat.format(list.updatedAt)}',
    '$placeCount place${placeCount == 1 ? '' : 's'}',
  ].join(' • ');
}

/// Resolves a single place's title (honoring a user-set [FavoriteListPlaceDto.customName]),
/// address and coordinates via the same DGis SDK lookup the phone UI uses
/// (`favorite_list_places_tile.dart`), so both surfaces stay consistent. Returns `null` when
/// the place can't be resolved (unparseable id, SDK miss, or a transient SDK error) — the
/// caller drops it rather than failing the whole list.
Future<FavoriteListItemMessage?> _resolvePlaceItem(ProviderContainer container, FavoriteListPlaceDto place) async {
  final objectId = int.tryParse(place.placeId);
  if (objectId == null) {
    return null;
  }

  try {
    final poi = await container.read(favoriteListPlacePoiProvider(objectId).future);
    final coordinates = poi?.markerPosition?.toGeoPointMessage();
    if (poi == null || coordinates == null) {
      return null;
    }

    return FavoriteListItemMessage(
      id: place.placeId,
      title: place.customName ?? poi.title,
      subtitle: poi.makeAddress(),
      coordinates: coordinates,
    );
  } catch (e) {
    logger.log('favorite place ${place.placeId} POI lookup failed: $e', logLevel: MapnessLogLevel.error);
    return null;
  }
}

/// Builds the grouped favorite-lists payload sent to CarPlay.
Future<FavoriteListsStateMessage> buildFavoriteListsStateMessage(ProviderContainer container) async {
  final lists = await container.read(favoriteListsProvider.future);
  final languageCode = container.read(appLanguageProvider).baladyCompat;

  final listMessages = await Future.wait(
    lists.map((list) async {
      final colorHex = _colorHex(list);
      final subtitle = _subtitle(list, languageCode);
      try {
        final detail = await container.read(favoriteListDetailProvider(listId: list.id).future);
        final places = detail.list.places ?? const [];

        final items = (await Future.wait(places.map((place) => _resolvePlaceItem(container, place)))).nonNulls.toList();

        return FavoriteListMessage(id: list.id, name: list.name, colorHex: colorHex, subtitle: subtitle, items: items);
      } catch (e) {
        // One list's detail request failing (e.g. a transient network hiccup) must not blank
        // out every other already-resolved list — surface it as name-only instead.
        logger.log('favorite list ${list.id} detail failed: $e', logLevel: MapnessLogLevel.error);
        return FavoriteListMessage(
          id: list.id,
          name: list.name,
          colorHex: colorHex,
          subtitle: subtitle,
          items: const [],
        );
      }
    }),
  );

  return FavoriteListsStateMessage(lists: listMessages);
}
