import 'package:mapness/features/friends_on_map/data/fake_friends_repository.dart';
import 'package:mapness/features/friends_on_map/data/friends_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'friends_repository.g.dart';

// Backend mocked for this iteration — see AGENTS.md. This is the only seam
// a real Dio-backed implementation needs to replace.
@riverpod
FriendsRepository friendsRepository(Ref ref) => FakeFriendsRepository();
