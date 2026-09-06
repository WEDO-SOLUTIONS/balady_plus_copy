import 'package:mapness/features/favorite_lists/data/favorite_lists_remote_datasource.dart';
import 'package:mapness/features/favorite_lists/data/models/favorite_list_dto.dart';
import 'package:mapness/features/favorite_lists/providers/favorite_lists_migration.dart';
import 'package:mapness/features/favorite_lists/providers/home_work_favorites.dart';
import 'package:mapness/features/favorite_lists/providers/home_work_favorites_migration.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favorite_lists.g.dart';

@riverpod
Future<FavoriteListsResponseDto> favoriteListsResponse(Ref ref) async {
  await ref.watch(favoriteListsMigrationProvider.future);
  await ref.watch(homeWorkFavoritesMigrationProvider.future);
  final dataSource = await ref.watch(favoriteListsRemoteDataSourceProvider.future);
  return dataSource.getFavoriteLists();
}

@riverpod
Future<List<FavoriteListDto>> favoriteLists(Ref ref) async {
  final response = await ref.watch(favoriteListsResponseProvider.future);
  return response.lists;
}

/// [favoriteLists] with the hidden system Home/Work lists filtered out — use this for any
/// user-facing list rendering or picking (e.g. "My Lists", the list-membership picker), so users
/// never see or can pick the lists used internally to store Home/Work.
@riverpod
Future<List<FavoriteListDto>> visibleFavoriteLists(Ref ref) async {
  final lists = await ref.watch(favoriteListsProvider.future);
  return lists.where((list) => list.name != systemHomeListName && list.name != systemWorkListName).toList();
}

@riverpod
Future<FavoriteListLimitsDto> favoriteListLimits(Ref ref) async {
  final response = await ref.watch(favoriteListsResponseProvider.future);
  return response.limits;
}
