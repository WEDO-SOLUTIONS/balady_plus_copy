import 'package:mapness/features/favorite_lists/providers/favorite_list_detail.dart';
import 'package:mapness/features/favorite_lists/providers/favorite_lists.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favorite_list_membership_map.g.dart';

/// Для каждого списка избранного — состоит ли в нём [placeId].
///
/// Все запросы по спискам (`favoriteListDetailProvider` на каждый listId)
/// запускаются одновременно через `Future.wait`, и экран получает ОДИН
/// AsyncValue вместо N независимых — единый лоадер вместо чекбоксов,
/// появляющихся по одному по мере ответа от каждого списка.
@riverpod
Future<Map<String, bool>> favoriteListMembershipMap(Ref ref, String placeId) async {
  final lists = await ref.watch(favoriteListsProvider.future);
  final entries = await Future.wait(
    lists.map((list) async {
      final detail = await ref.watch(favoriteListDetailProvider(listId: list.id).future);
      final isMember = detail.list.places?.any((place) => place.placeId == placeId) ?? false;
      return MapEntry(list.id, isMember);
    }),
  );
  return Map.fromEntries(entries);
}
