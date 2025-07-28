part of 'bss_payload.dart';

class BssHistoryList {
  const BssHistoryList({
    required this.size,
  });

  /// Number of elements in the list. Can be 0, since we agreed to register the event "showing empty results"
  final int size;
}
