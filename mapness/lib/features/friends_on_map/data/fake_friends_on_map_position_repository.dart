import 'package:geolocator/geolocator.dart';
import 'package:mapness/features/friends_on_map/data/friends_on_map_position_repository.dart';

/// In-memory stand-in for the real position endpoint. Overwrites one field —
/// no history is ever kept, matching R-15. No network call is made — see
/// `features/friends_on_map/AGENTS.md` for the mocked-backend scope decision
/// this implements.
class FakeFriendsOnMapPositionRepository implements FriendsOnMapPositionRepository {
  Position? lastReported;

  @override
  Future<void> reportPosition(Position position) async {
    lastReported = position;
  }
}
