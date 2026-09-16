import 'package:dio/dio.dart';

/// Machine-readable Appendix B limit codes (S-10, R-39/R-40) — must match
/// the `code` field the Go backend sends verbatim once it implements S-10
/// (see `features/friends_on_map/AGENTS.md`'s "S-10 limits" section for the
/// full wire contract). Not implemented server-side as of this writing —
/// this client is built ready for it.
enum FriendsOnMapLimitCode {
  /// Appendix B: accepted friends per user = 200. `POST
  /// /v1/friend-requests/{id}/accept`, HTTP 409.
  friendLimitReached,

  /// Appendix B: pending outgoing friend requests per user = 50. `POST
  /// /v1/invites/{token}/resolve`, HTTP 409.
  pendingRequestLimitReached,

  /// Appendix B: friend requests created per rolling 24h = 20. `POST
  /// /v1/invites/{token}/resolve`, HTTP 429 + Retry-After.
  requestCreationLimitReached,

  /// Appendix B: invite link resets per rolling 24h = 10. `POST
  /// /v1/me/invite-link/reset`, HTTP 429 + Retry-After.
  inviteResetLimitReached,

  /// R-40, Appendix B: invite link resolution attempts per rolling hour =
  /// 60 (counts failed attempts too). `POST /v1/invites/{token}/resolve`,
  /// HTTP 429 + Retry-After.
  inviteResolutionRateLimited,

  /// S-18, Appendix B: shared lists owned per user = 20. `POST /v1/lists`,
  /// HTTP 409.
  listLimitReached,

  /// S-18, Appendix B: members per shared list = 50. `POST
  /// /v1/lists/{id}/members`, HTTP 409.
  listMemberLimitReached,

  /// S-18, Appendix B: entries per shared list = 200. `POST
  /// /v1/lists/{id}/places`, HTTP 409.
  listItemLimitReached;

  static FriendsOnMapLimitCode? fromWire(String? value) => switch (value) {
    'friend_limit_reached' => friendLimitReached,
    'pending_request_limit_reached' => pendingRequestLimitReached,
    'request_creation_limit_reached' => requestCreationLimitReached,
    'invite_reset_limit_reached' => inviteResetLimitReached,
    'invite_resolution_rate_limited' => inviteResolutionRateLimited,
    'list_limit_reached' => listLimitReached,
    'list_member_limit_reached' => listMemberLimitReached,
    'list_item_limit_reached' => listItemLimitReached,
    _ => null,
  };
}

/// BR-02: which party is at the limit. Only [friendLimitReached] ever sends
/// `peer` — every other limit here is always self-triggered.
enum FriendsOnMapLimitSubject {
  self,
  peer;

  static FriendsOnMapLimitSubject? fromWire(String? value) => switch (value) {
    'self' => self,
    'peer' => peer,
    _ => null,
  };
}

/// Thrown for any non-2xx response from a Friends on Map backend call.
/// [limitCode] is only non-null when the body's `code` field exactly
/// matches one of the 5 Appendix B limit codes above — every other failure
/// (network error, unrelated 4xx/5xx, malformed body) still produces this
/// type, just with [limitCode] null, so callers only ever need to catch one
/// exception type and branch on [isLimit].
class FriendsOnMapApiException implements Exception {
  const FriendsOnMapApiException({
    required this.statusCode,
    required this.message,
    this.limitCode,
    this.subject,
    this.limit,
    this.retryAfter,
  });

  final int? statusCode;
  final String message;
  final FriendsOnMapLimitCode? limitCode;
  final FriendsOnMapLimitSubject? subject;
  final int? limit;
  final Duration? retryAfter;

  bool get isLimit => limitCode != null;

  @override
  String toString() => 'FriendsOnMapApiException($statusCode, $limitCode): $message';
}

/// Maps a [DioException] to [FriendsOnMapApiException]. Never infers a
/// limit from the HTTP status code alone — a 409/429 with no recognized
/// `code` field is treated as a generic failure, not guessed at.
FriendsOnMapApiException mapFriendsOnMapError(DioException e) {
  final data = e.response?.data;
  final body = data is Map ? data.cast<String, dynamic>() : const <String, dynamic>{};
  final message = body['error']?.toString() ?? e.message ?? 'Network error';
  final limitCode = FriendsOnMapLimitCode.fromWire(body['code'] as String?);

  if (limitCode == null) {
    return FriendsOnMapApiException(statusCode: e.response?.statusCode, message: message);
  }

  return FriendsOnMapApiException(
    statusCode: e.response?.statusCode,
    message: message,
    limitCode: limitCode,
    subject: FriendsOnMapLimitSubject.fromWire(body['subject'] as String?),
    limit: (body['limit'] as num?)?.toInt(),
    retryAfter: _retryAfter(e, body),
  );
}

/// Rolling-window codes only: prefers the body's `retryAfterSeconds` (the
/// contract sends both), falls back to parsing the standard `Retry-After`
/// header so a body without it still degrades gracefully instead of losing
/// the countdown entirely.
Duration? _retryAfter(DioException e, Map<String, dynamic> body) {
  final bodySeconds = (body['retryAfterSeconds'] as num?)?.toInt();
  if (bodySeconds != null) {
    return Duration(seconds: bodySeconds);
  }
  final headerValue = e.response?.headers.value('retry-after');
  final headerSeconds = headerValue == null ? null : int.tryParse(headerValue);
  return headerSeconds == null ? null : Duration(seconds: headerSeconds);
}
