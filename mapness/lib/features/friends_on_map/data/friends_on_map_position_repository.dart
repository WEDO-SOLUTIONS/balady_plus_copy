import 'package:geolocator/geolocator.dart';

/// Server-side counterpart of position reporting (conceptually `POST
/// /v1/me/position` / `/v1/me/positions:batch`). Mocked for this iteration —
/// see `features/friends_on_map/AGENTS.md`.
abstract class FriendsOnMapPositionRepository {
  Future<void> reportPosition(Position position);
}
