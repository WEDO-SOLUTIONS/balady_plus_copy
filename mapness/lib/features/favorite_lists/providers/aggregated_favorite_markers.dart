import 'package:mapness/features/favorite_lists/data/favorite_lists_remote_datasource.dart';
import 'package:mapness/features/favorite_lists/data/models/map_marker_dto.dart';
import 'package:mapness/features/sso_auth/data/token_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'aggregated_favorite_markers.g.dart';

@riverpod
Future<List<MapMarkerDto>> aggregatedFavoriteMarkers(Ref ref) async {
  // Anonymous users have no favorites; the API answers 401 without a token, which would break
  // everything that awaits this (POI card, map markers). Rebuilds once a token appears.
  final token = await ref.watch(tokenProvider.future);
  if (token.isEmpty) {
    return const [];
  }
  final dataSource = await ref.watch(favoriteListsRemoteDataSourceProvider.future);
  final response = await dataSource.getAggregatedMapMarkers();
  return response.markers;
}
