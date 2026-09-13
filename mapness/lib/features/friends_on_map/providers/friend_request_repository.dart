import 'package:mapness/features/friends_on_map/data/fake_friend_request_repository.dart';
import 'package:mapness/features/friends_on_map/data/friend_request_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'friend_request_repository.g.dart';

// Backend mocked for this iteration — see AGENTS.md. This is the only seam
// a real Dio-backed implementation needs to replace.
//
// keepAlive: holds the seeded incoming requests and any outgoing requests
// created via Scan/deep-link as mutable in-memory state — must survive
// navigating away from the requests/Add Friend screens and back, same
// reasoning as `friendsRepositoryProvider`.
@Riverpod(keepAlive: true)
FriendRequestRepository friendRequestRepository(Ref ref) => FakeFriendRequestRepository();
