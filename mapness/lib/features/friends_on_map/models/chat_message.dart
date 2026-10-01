/// S-21 (R-117): the two kinds of message — free text and a place card.
enum ChatMessageKind { text, placeCard }

/// R-102 delivery state. [pending] and [failed] only ever exist on this
/// device (the offline outbox, R-103); the server only knows [sent] →
/// [delivered] → [read].
enum ChatMessageStatus { pending, failed, sent, delivered, read }

/// A place carried by a place-card message (R-117) — same shape as a
/// meetup/list-item place: raw coordinates plus a free-text label.
class ChatPlace {
  final double latitude;
  final double longitude;
  final String? label;

  const ChatPlace({required this.latitude, required this.longitude, this.label});
}

/// One message in a one-to-one conversation (S-21). [mine] is computed by
/// the server — this client has no "who am I" concept to compare against.
/// A [deleted] message (R-107) carries no [body]/[place], only the marker.
class ChatMessage {
  /// Server id, or — for a message still in the outbox — its
  /// `clientMessageId`.
  final String id;

  /// Monotonic server-assigned order; null while the message is only in the
  /// outbox. Display order never trusts [composedAt] (a wrong device clock
  /// must not be able to insert messages into the past).
  final int? seq;
  final bool mine;
  final ChatMessageKind kind;
  final String? body;
  final ChatPlace? place;
  final DateTime composedAt;
  final ChatMessageStatus status;
  final bool deleted;

  /// Server creation time; null for an outbox message.
  final DateTime? createdAt;

  const ChatMessage({
    required this.id,
    required this.mine,
    required this.kind,
    required this.composedAt,
    required this.status,
    this.seq,
    this.body,
    this.place,
    this.deleted = false,
    this.createdAt,
  });

  /// The moment shown in the thread: when the server received it, falling
  /// back to when it was composed for an outbox message.
  DateTime get displayTime => createdAt ?? composedAt;
}
