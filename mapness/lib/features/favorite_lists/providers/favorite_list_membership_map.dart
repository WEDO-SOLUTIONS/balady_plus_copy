import 'package:mapness/features/favorite_lists/providers/favorite_list_detail.dart';
import 'package:mapness/features/favorite_lists/providers/favorite_lists.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favorite_list_membership_map.g.dart';

/// For every favorite list — whether it contains [placeId].
///
/// All per-list requests (`favoriteListDetailProvider` for each listId)
/// run concurrently via `Future.wait`, so the screen gets ONE AsyncValue
/// instead of N independent ones — a single loader instead of checkboxes
/// popping in one by one as each list responds.
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
