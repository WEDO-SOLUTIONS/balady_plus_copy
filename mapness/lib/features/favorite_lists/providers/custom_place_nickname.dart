import 'package:mapness/features/favorite_lists/data/favorite_lists_remote_datasource.dart';
import 'package:mapness/features/favorite_lists/providers/favorite_list_membership.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'custom_place_nickname.g.dart';

/// Пользовательское имя (nickname) для места, если оно задано.
///
/// Запрос делается только если место уже в хотя бы одном списке избранного
/// (`isPlaceFavoritedProvider`) — единственный существующий UI для установки
/// customName требует, чтобы место уже было в списке, так что для всех
/// остальных (подавляющее большинство просматриваемых POI) запрос заведомо
/// вернул бы пусто — не делаем его вообще.
@riverpod
Future<String?> customPlaceNickname(Ref ref, String placeId) async {
  final isFavorited = ref.watch(isPlaceFavoritedProvider(placeId));
  if (!isFavorited) {
    return null;
  }
  final dataSource = await ref.watch(favoriteListsRemoteDataSourceProvider.future);
  try {
    final response = await dataSource.getCustomPlaceNickname(placeId);
    return response.customName;
  } catch (_) {
    return null;
  }
}
