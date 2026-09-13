import 'package:mapness/features/friends_on_map/data/friends_repository.dart';
import 'package:mapness/features/friends_on_map/models/friend.dart';

/// In-memory stand-in for the real friend list endpoint. Seeded with a
/// fixed sample so the list, search and empty-state UI are each
/// independently verifiable without a real backend — see
/// `features/friends_on_map/AGENTS.md` for the mocked-backend scope
/// decision this implements. The backing list is mutable so an accepted
/// friend request (R-22) can actually appear here.
class FakeFriendsRepository implements FriendsRepository {
  final List<Friend> _friends = [
    const Friend(id: '1', displayName: 'Sara Al-Otaibi'),
    const Friend(id: '2', displayName: 'Mohammed bin Khalid Al-Harbi'),
    const Friend(id: '3', displayName: 'Noura'),
  ];

  @override
  Future<List<Friend>> getFriends() async => List.unmodifiable(_friends);

  @override
  Future<void> addFriend(Friend friend) async {
    _friends.add(friend);
  }
}
