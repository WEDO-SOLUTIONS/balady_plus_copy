import 'package:mapness/features/friends_on_map/data/friends_on_map_activation_repository.dart';

/// In-memory stand-in for the real activation endpoint. No network call is
/// made — see `features/friends_on_map/AGENTS.md` for the mocked-backend
/// scope decision this implements.
class FakeFriendsOnMapActivationRepository implements FriendsOnMapActivationRepository {
  bool? lastBackgroundLocationGranted;

  @override
  Future<void> activate({required bool backgroundLocationGranted}) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    lastBackgroundLocationGranted = backgroundLocationGranted;
  }
}
