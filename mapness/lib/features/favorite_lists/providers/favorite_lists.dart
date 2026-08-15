import 'package:mapness/features/favorite_lists/data/favorite_lists_remote_datasource.dart';
import 'package:mapness/features/favorite_lists/data/models/favorite_list_dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favorite_lists.g.dart';

@riverpod
Future<List<FavoriteListDto>> favoriteLists(Ref ref) async {
  final dataSource = await ref.watch(favoriteListsRemoteDataSourceProvider.future);
  final response = await dataSource.getFavoriteLists();
  return response.lists;
}
