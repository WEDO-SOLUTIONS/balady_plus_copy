import 'package:mapness/features/friends_on_map/models/friend.dart';
import 'package:mapness/features/friends_on_map/providers/friends_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'friends_list.g.dart';

/// R-09: the friend graph is independent of activation/deactivation, so this
/// is not gated on `friendsOnMapActivatedProvider` — only reachability
/// (the current entry point lives on the status view) is gated, not the
/// data itself.
@riverpod
Future<List<Friend>> friendsList(Ref ref) => ref.watch(friendsRepositoryProvider).getFriends();
