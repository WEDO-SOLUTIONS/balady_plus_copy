import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'friend_search_query.g.dart';

/// R-42: the raw friend-list search text. No debounce — the dataset is a
/// handful of items and filtering is synchronous. No Arabic orthographic
/// normalization (hamza/alef maqsura/taa marbuta folding) — case-insensitive
/// substring match only, per the standing scope decision (BRD open decision
/// D-16 leaves cross-script matching undecided).
@riverpod
class FriendSearchQuery extends _$FriendSearchQuery {
  @override
  String build() => '';

  String get query => state;

  set query(String value) => state = value;
}
