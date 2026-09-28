import 'package:mapness/features/friends_on_map/models/active_share.dart';
import 'package:mapness/features/friends_on_map/models/share_mode.dart';

/// Server-side counterpart of S-19 (R-78-R-87) — see
/// `~/dev/code/wedo/go/balady-friends-service`'s `internal/api/handlers_shares.go`.
abstract class ActiveSharesRepository {
  /// R-78/R-80: creates a new share. [destLat]/[destLon] are required iff
  /// [mode] is [ShareMode.eta] (R-85). Returns the owner-facing id plus the
  /// recipient-facing token (kept deliberately separate — see
  /// `models/active_share.dart`'s doc comment) needed to build the share
  /// link.
  Future<({String id, String token, ActiveShare share})> createShare({
    required ShareMode mode,
    required Duration duration,
    double? destLat,
    double? destLon,
  });

  /// R-83: only non-expired, non-stopped shares owned by the caller.
  Future<List<ActiveShare>> listShares();

  /// R-83's stop action. Idempotent server-side.
  Future<void> stopShare(String id);

  /// Sender-side position/ETA push. [etaArrivalAt]/[etaDistanceMeters] are
  /// only meaningful for an eta-mode share.
  Future<void> reportPosition(
    String id, {
    required double lat,
    required double lon,
    DateTime? etaArrivalAt,
    double? etaDistanceMeters,
  });
}
