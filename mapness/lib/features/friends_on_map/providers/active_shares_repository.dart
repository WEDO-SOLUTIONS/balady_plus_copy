import 'package:mapness/features/friends_on_map/data/active_shares_repository.dart';
import 'package:mapness/features/friends_on_map/data/remote_active_shares_repository.dart';
import 'package:mapness/features/friends_on_map/providers/friends_on_map_network.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'active_shares_repository.g.dart';

/// S-19 (R-78-R-87) — see `~/dev/code/wedo/go/balady-friends-service`'s
/// `internal/api/handlers_shares.go`. keepAlive: same reasoning as every
/// other repository binding in this feature (`friends_repository.dart`) — an
/// active share must survive whichever sheet is currently reading it being
/// unmounted and remounted.
@Riverpod(keepAlive: true)
ActiveSharesRepository activeSharesRepository(Ref ref) =>
    RemoteActiveSharesRepository(ref.watch(friendsOnMapNetworkProvider));
