import 'package:mapness/features/friends_on_map/data/friends_repository.dart';
import 'package:mapness/features/friends_on_map/models/friend.dart';

/// In-memory stand-in for the real friend list endpoint. Returns a fixed
/// sample so the list, search and empty-state UI are each independently
/// verifiable without a real backend — see
/// `features/friends_on_map/AGENTS.md` for the mocked-backend scope
/// decision this implements.
class FakeFriendsRepository implements FriendsRepository {
  static const _sampleFriends = [
    Friend(id: '1', displayName: 'Sara Al-Otaibi'),
    Friend(id: '2', displayName: 'Mohammed bin Khalid Al-Harbi'),
    Friend(id: '3', displayName: 'Noura'),
  ];

  @override
  Future<List<Friend>> getFriends() async => _sampleFriends;
}
