import 'package:mapness/features/favorite_lists/data/favorite_lists_remote_datasource.dart';
import 'package:mapness/features/favorite_lists/data/models/map_marker_dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'aggregated_favorite_markers.g.dart';

@riverpod
Future<List<MapMarkerDto>> aggregatedFavoriteMarkers(Ref ref) async {
  final dataSource = await ref.watch(favoriteListsRemoteDataSourceProvider.future);
  final response = await dataSource.getAggregatedMapMarkers();
  return response.markers;
}
