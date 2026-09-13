import 'package:mapness/features/friends_on_map/data/fake_friend_request_repository.dart';
import 'package:mapness/features/friends_on_map/data/friend_request_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'friend_request_repository.g.dart';

// Backend mocked for this iteration — see AGENTS.md. This is the only seam
// a real Dio-backed implementation needs to replace.
@riverpod
FriendRequestRepository friendRequestRepository(Ref ref) => FakeFriendRequestRepository();
