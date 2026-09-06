import 'package:mapness/features/favorite_lists/data/favorite_lists_remote_datasource.dart';
import 'package:mapness/features/favorite_lists/providers/favorite_list_membership.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'custom_place_nickname.g.dart';

/// Custom nickname for a place, if one is set.
///
/// The request is only made if the place is already in at least one
/// favorite list (`isPlaceFavoritedProvider`) — the only existing UI for
/// setting customName requires the place to already be in a list, so for
/// everything else (the vast majority of viewed POIs) the request would
/// come back empty anyway — skip it entirely.
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
