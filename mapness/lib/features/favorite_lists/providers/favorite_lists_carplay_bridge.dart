import 'dart:ui';

import 'package:dgis_map/library.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mapness/features/favorite_lists/data/favorite_lists_remote_datasource.dart';
import 'package:mapness/features/favorite_lists/data/models/favorite_list_dto.dart';
import 'package:mapness/features/favorite_lists/data/models/marker_color_code.dart';
import 'package:mapness/features/favorite_lists/providers/favorite_lists_migration.dart';
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

/// Builds the grouped favorite-lists payload sent to CarPlay/Android Auto.
///
/// Reads the (keepAlive) data source directly instead of going through
/// `favoriteListsProvider`/`favoriteListDetailProvider` (autoDispose family providers): calling
/// `container.read(autoDisposeProvider.future)` from outside any widget subscription doesn't
/// keep the provider alive, so Riverpod disposes it mid-flight and the read hangs forever
/// instead of completing — this is what made every list show up empty, even ones that do have
/// places on the phone.
Future<FavoriteListsStateMessage> buildFavoriteListsStateMessage(ProviderContainer container) async {
  await container.read(favoriteListsMigrationProvider.future);
  final dataSource = await container.read(favoriteListsRemoteDataSourceProvider.future);

  final lists = (await dataSource.getFavoriteLists()).lists;
  final languageCode = container.read(appLanguageProvider).baladyCompat;

  final listMessages = await Future.wait(
    lists.map((list) async {
      final colorHex = _colorHex(list);
      final subtitle = _subtitle(list, languageCode);
      try {
        final detail = await dataSource.getFavoriteListById(list.id);
        final places = detail.list.places ?? const [];

        // Places are resolved natively by CarPlay/Android Auto (see `FavoriteListsScreen.kt` /
        // `FavoritesScreen.swift`) from `placeRefs` via their own SDK session, so no SDK lookup
        // happens on the Dart side.
        final placeRefs = places
            .map((place) => FavoriteListPlaceRefMessage(placeId: place.placeId, customName: place.customName))
            .toList();

        return FavoriteListMessage(
          id: list.id,
          name: list.name,
          colorHex: colorHex,
          subtitle: subtitle,
          placeRefs: placeRefs,
        );
      } catch (e) {
        // One list's detail request failing (e.g. a transient network hiccup) must not blank
        // out every other already-resolved list — surface it as name-only instead.
        logger.log('favorite list ${list.id} detail failed: $e', logLevel: MapnessLogLevel.error);
        return FavoriteListMessage(
          id: list.id,
          name: list.name,
          colorHex: colorHex,
          subtitle: subtitle,
          placeRefs: const [],
        );
      }
    }),
  );

  return FavoriteListsStateMessage(lists: listMessages);
}
