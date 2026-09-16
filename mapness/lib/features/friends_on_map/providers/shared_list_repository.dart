import 'package:mapness/features/friends_on_map/data/remote_shared_list_repository.dart';
import 'package:mapness/features/friends_on_map/data/shared_list_repository.dart';
import 'package:mapness/features/friends_on_map/providers/friends_on_map_network.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'shared_list_repository.g.dart';

/// keepAlive: same reasoning as `meetupRepositoryProvider` — a created,
/// deleted, or otherwise mutated list must survive the relevant screens
/// being unmounted/remounted.
@Riverpod(keepAlive: true)
SharedListRepository sharedListRepository(Ref ref) =>
    RemoteSharedListRepository(ref.watch(friendsOnMapNetworkProvider));
