import 'package:mapness/features/friends_on_map/data/friend_request_repository.dart';
import 'package:mapness/features/friends_on_map/models/friend.dart';
import 'package:mapness/features/friends_on_map/models/friend_request.dart';
import 'package:mapness/features/friends_on_map/models/invite_resolution.dart';

/// In-memory stand-in for the friend-request graph.
///
/// R-35 (duplicate request / already friends) is deliberately not modeled:
/// there is no second real account in a single-device mock to be "already
/// friends" with, and every non-self token here belongs to nobody real —
/// faking that check would mean inventing state with nothing behind it.
///
/// [_incomingRequests] is seeded with two fixed fake requests so accept /
/// decline / R-22 (accepting adds a real friend) are all genuinely
/// exercisable — the same seeding approach `FakeFriendsRepository` uses for
/// its 3 sample friends. A real backend would have actual other users
/// sending these; ours doesn't, so it fabricates a couple.
///
/// [_outgoingRequests] used to be a bare `List<String>` of tokens
/// (`pendingRequestTokens`); it's now a list of [FriendRequest] with a name
/// deterministically fabricated from the token at `resolveInvite`-success
/// time, so "sent to X" and a cancellable "Sent" entry are meaningful
/// instead of "sent to (unknown)" — a real backend's resolve response would
/// carry the invite owner's actual identity, which we have no way to know.
///
/// See `features/friends_on_map/AGENTS.md`.
class FakeFriendRequestRepository implements FriendRequestRepository {
  static const _fabricatedNames = ['Layla Al-Sulaiman', 'Omar Al-Qahtani', 'Reem Al-Dosari', 'Yousef Al-Mutairi'];

  final List<FriendRequest> _incomingRequests = [
    const FriendRequest(id: 'req-1', displayName: 'Fatima Al-Zahrani', direction: FriendRequestDirection.incoming),
    const FriendRequest(id: 'req-2', displayName: 'Khalid Al-Ghamdi', direction: FriendRequestDirection.incoming),
  ];

  final List<FriendRequest> _outgoingRequests = [];

  @override
  Future<InviteResolution> resolveInvite({required String token, required String ownToken}) async {
    if (token == ownToken) {
      return InviteResolution.selfRequest;
    }
    final name = _fabricatedNames[token.hashCode.abs() % _fabricatedNames.length];
    _outgoingRequests.add(FriendRequest(id: token, displayName: name, direction: FriendRequestDirection.outgoing));
    return InviteResolution.success;
  }

  @override
  Future<List<FriendRequest>> getIncomingRequests() async => List.unmodifiable(_incomingRequests);

  @override
  Future<List<FriendRequest>> getOutgoingRequests() async => List.unmodifiable(_outgoingRequests);

  @override
  Future<Friend> acceptRequest(String id) async {
    final request = _incomingRequests.firstWhere((r) => r.id == id);
    _incomingRequests.removeWhere((r) => r.id == id);
    // Small deterministic offset from the same `_kingdomTower` landmark seed
    // location `FakeFriendsRepository` uses (see its doc comment), so an
    // accepted friend is immediately visible as a marker (R-48) too, not
    // just the 3 seeded samples. Note: this offset can add up to ~0.0099
    // degrees (~1.1km) depending on the request id's hash, which can land
    // outside the default zoom-17 screen for some ids — not fixed here,
    // out of scope for the "no markers visible" bug this coordinate anchor
    // was fixing.
    final offset = (request.id.hashCode.abs() % 100) / 10000;
    return Friend(
      id: request.id,
      displayName: request.displayName,
      profilePictureUrl: request.profilePictureUrl,
      latitude: 24.712301 + offset,
      longitude: 46.674175 + offset,
    );
  }

  @override
  Future<void> declineRequest(String id) async {
    _incomingRequests.removeWhere((r) => r.id == id);
  }

  @override
  Future<void> cancelRequest(String id) async {
    _outgoingRequests.removeWhere((r) => r.id == id);
  }
}
