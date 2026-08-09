import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/providers/hive.dart';

/// Local-only "Recent Activity" feed for the Profile tab.
///
/// The TIFO backend has no history endpoint yet (BE-233 follow-up: request a
/// `GET /activity` contract — type/label/tokenDelta/timestamp per event, so the
/// server-known history that already backs `/me`'s `stats` block can be
/// exposed). Until then this device-local log records events as they happen,
/// so it can only reflect activity from this point forward — it does not
/// backfill matches/trips that occurred before the log existed.
const kTifoActivityMaxEntries = 20;

const _kTifoActivityBoxName = 'tifo_activity';
const _kTifoActivityKey = 'entries';

enum TifoActivityType { win, loss, tripCompleted }

class TifoActivityEntry {
  const TifoActivityEntry({required this.type, required this.label, required this.timestamp, this.tokenDelta});

  final TifoActivityType type;
  final String label;
  final DateTime timestamp;

  /// Token balance change to show alongside the label (e.g. "+3 ⚡"), null when
  /// not applicable.
  final int? tokenDelta;

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'label': label,
    'timestamp': timestamp.toIso8601String(),
    if (tokenDelta != null) 'tokenDelta': tokenDelta,
  };

  static TifoActivityEntry? fromJson(Object? raw) {
    if (raw is! Map) {
      return null;
    }
    final type = TifoActivityType.values.asNameMap()[raw['type']?.toString()];
    final label = raw['label']?.toString();
    final timestamp = DateTime.tryParse(raw['timestamp']?.toString() ?? '');
    if (type == null || label == null || timestamp == null) {
      return null;
    }
    return TifoActivityEntry(
      type: type,
      label: label,
      timestamp: timestamp,
      tokenDelta: (raw['tokenDelta'] as num?)?.toInt(),
    );
  }
}

class TifoActivityLogController extends AsyncNotifier<List<TifoActivityEntry>> {
  @override
  Future<List<TifoActivityEntry>> build() async {
    final box = await ref.watch(hiveProvider(_kTifoActivityBoxName).future);
    final raw = box.get(_kTifoActivityKey);
    if (raw is! List) {
      return const [];
    }
    return raw.map(TifoActivityEntry.fromJson).nonNulls.toList(growable: false);
  }

  /// Prepends [entry], persists it, and caps the log at [kTifoActivityMaxEntries]
  /// so the box doesn't grow unbounded over a long-lived install.
  Future<void> add(TifoActivityEntry entry) async {
    final box = await ref.read(hiveProvider(_kTifoActivityBoxName).future);
    final current = state.value ?? const <TifoActivityEntry>[];
    final updated = [entry, ...current].take(kTifoActivityMaxEntries).toList(growable: false);
    await box.put(_kTifoActivityKey, [for (final e in updated) e.toJson()]);
    state = AsyncData(updated);
  }
}

final tifoActivityLogProvider = AsyncNotifierProvider<TifoActivityLogController, List<TifoActivityEntry>>(
  TifoActivityLogController.new,
);
