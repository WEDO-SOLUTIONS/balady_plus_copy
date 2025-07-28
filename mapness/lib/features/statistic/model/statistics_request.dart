typedef BssPayloadMap = List<Map<String, dynamic>>;

class StatisticsRequest {
  StatisticsRequest({
    required this.query,
    required this.eventId,
    required this.timestamp,
  });

  /// Message code. For Balady - 434
  int type = 434;

  /// Globally unique event identifier in "uuid" format
  final String eventId;

  /// Event time with millisecond accuracy.
  /// Defined as the number of milliseconds since Unix Epoch
  final int timestamp;

  /// Search query text
  final String query;

  /// Convert object to JSON
  BssPayloadMap toBssPayload() => [
        {
          'type': type,
          'eventId': eventId.toString(),
          'timestamp': timestamp,
          'query': query,
        }
      ];
}
