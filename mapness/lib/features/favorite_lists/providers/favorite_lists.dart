import 'package:mapness/features/favorite_lists/data/favorite_lists_remote_datasource.dart';
import 'package:mapness/features/favorite_lists/data/models/favorite_list_dto.dart';
import 'package:mapness/features/favorite_lists/providers/favorite_lists_migration.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favorite_lists.g.dart';

@riverpod
Future<FavoriteListsResponseDto> favoriteListsResponse(Ref ref) async {
  await ref.watch(favoriteListsMigrationProvider.future);
  final dataSource = await ref.watch(favoriteListsRemoteDataSourceProvider.future);
  return dataSource.getFavoriteLists();
}

@riverpod
Future<List<FavoriteListDto>> favoriteLists(Ref ref) async {
  final response = await ref.watch(favoriteListsResponseProvider.future);
  return response.lists;
}

@riverpod
Future<FavoriteListLimitsDto> favoriteListLimits(Ref ref) async {
  final response = await ref.watch(favoriteListsResponseProvider.future);
  return response.limits;
}
