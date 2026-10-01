import 'package:mapness/features/friends_on_map/models/chat_message.dart';

/// A message composed on this device and not yet acknowledged by the server
/// (R-103's local queue). Persisted as JSON so a kill/relaunch doesn't lose
/// it; the [clientMessageId] makes re-sending idempotent on the server.
class OutboxMessage {
  final String friendId;
  final String clientMessageId;
  final ChatMessageKind kind;
  final String? body;
  final ChatPlace? place;
  final DateTime composedAt;

  /// True once the server definitively refused it (a 4xx) — it stays in the
  /// thread as "not sent" for the user to retry or discard, and is never
  /// auto-retried (a network failure never sets this).
  final bool failed;

  const OutboxMessage({
    required this.friendId,
    required this.clientMessageId,
    required this.kind,
    required this.composedAt,
    this.body,
    this.place,
    this.failed = false,
  });

  OutboxMessage copyWith({bool? failed}) => OutboxMessage(
    friendId: friendId,
    clientMessageId: clientMessageId,
    kind: kind,
    composedAt: composedAt,
    body: body,
    place: place,
    failed: failed ?? this.failed,
  );

  ChatMessage toChatMessage() => ChatMessage(
    id: clientMessageId,
    mine: true,
    kind: kind,
    body: body,
    place: place,
    composedAt: composedAt,
    status: failed ? ChatMessageStatus.failed : ChatMessageStatus.pending,
  );

  Map<String, dynamic> toJson() => {
    'friendId': friendId,
    'clientMessageId': clientMessageId,
    'kind': kind == ChatMessageKind.text ? 'text' : 'place_card',
    'body': body,
    'place': place == null ? null : {'latitude': place!.latitude, 'longitude': place!.longitude, 'label': place!.label},
    'composedAt': composedAt.toUtc().toIso8601String(),
    'failed': failed,
  };

  factory OutboxMessage.fromJson(Map<String, dynamic> json) {
    final place = json['place'] as Map<String, dynamic>?;
    return OutboxMessage(
      friendId: json['friendId'] as String,
      clientMessageId: json['clientMessageId'] as String,
      kind: json['kind'] == 'place_card' ? ChatMessageKind.placeCard : ChatMessageKind.text,
      body: json['body'] as String?,
      place: place == null
          ? null
          : ChatPlace(
              latitude: (place['latitude'] as num).toDouble(),
              longitude: (place['longitude'] as num).toDouble(),
              label: place['label'] as String?,
            ),
      composedAt: DateTime.parse(json['composedAt'] as String),
      failed: json['failed'] as bool? ?? false,
    );
  }
}
