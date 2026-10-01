import 'package:mapness/features/favorite_lists/data/favorite_lists_remote_datasource.dart';
import 'package:mapness/features/favorite_lists/data/models/favorite_list_dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favorite_list_detail.g.dart';

@riverpod
class FavoriteListDetail extends _$FavoriteListDetail {
  @override
  Future<FavoriteListDetailResponseDto> build({required String listId}) async {
    final dataSource = await ref.watch(favoriteListsRemoteDataSourceProvider.future);
    return dataSource.getFavoriteListById(listId);
  }
}
