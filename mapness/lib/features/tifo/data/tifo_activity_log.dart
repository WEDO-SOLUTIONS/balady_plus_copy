import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/tifo/providers/tifo_session_provider.dart';
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

/// The pre-TFS-86042 key: ONE feed for the whole device, shared by every
/// account that ever signed in on it. Read once so an existing install's
/// entries can be dropped rather than kept lying around.
const _kTifoActivityLegacyKey = 'entries';

/// Entries are stored per profile. A device-wide key meant a newly registered
/// or logged-out user opened the Profile tab onto somebody else's match
/// history (TFS 86042).
String _entriesKey(String userId) => 'entries:$userId';

enum TifoActivityType { win, loss, tripCompleted }

class TifoActivityEntry {
  const TifoActivityEntry({required this.type, required this.timestamp, this.tokenDelta});

  final TifoActivityType type;
  final DateTime timestamp;

  /// Token balance change to show alongside the label (e.g. "+3 ⚡"), null when
  /// not applicable.
  final int? tokenDelta;

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'timestamp': timestamp.toIso8601String(),
    if (tokenDelta != null) 'tokenDelta': tokenDelta,
  };

  /// The label is intentionally NOT persisted: entries are read back and
  /// displayed on demand via [TifoActivityType], so an entry written in one
  /// app language always renders in whatever language is active later —
  /// switching languages mid-session (or between sessions) never leaves
  /// stale-language text sitting in a saved entry.
  static TifoActivityEntry? fromJson(Object? raw) {
    if (raw is! Map) {
      return null;
    }
    final type = TifoActivityType.values.asNameMap()[raw['type']?.toString()];
    final timestamp = DateTime.tryParse(raw['timestamp']?.toString() ?? '');
    if (type == null || timestamp == null) {
      return null;
    }
    return TifoActivityEntry(type: type, timestamp: timestamp, tokenDelta: (raw['tokenDelta'] as num?)?.toInt());
  }
}

class TifoActivityLogController extends AsyncNotifier<List<TifoActivityEntry>> {
  /// Whose feed is currently loaded, or null while signed out — [add] writes
  /// under this and only this.
  String? _userId;

  @override
  Future<List<TifoActivityEntry>> build() async {
    // `select` and not a plain watch: the session state changes on every
    // balance/roster refresh, and the feed must only reload when the IDENTITY
    // behind it changes.
    final userId = ref.watch(tifoSessionProvider.select((s) => s.profile?.userId));
    _userId = userId;
    final box = await ref.watch(hiveProvider(_kTifoActivityBoxName).future);

    // One-time cleanup of the shared device-wide feed. Not migrated onto the
    // current profile: there is no way to tell which account those entries
    // belonged to, and guessing is what the bug was.
    if (box.get(_kTifoActivityLegacyKey) != null) {
      await box.delete(_kTifoActivityLegacyKey);
    }

    if (userId == null) {
      return const []; // signed out — nothing of anyone's to show
    }
    final raw = box.get(_entriesKey(userId));
    if (raw is! List) {
      return const [];
    }
    return raw.map(TifoActivityEntry.fromJson).nonNulls.toList(growable: false);
  }

  /// Prepends [entry], persists it, and caps the log at [kTifoActivityMaxEntries]
  /// so the box doesn't grow unbounded over a long-lived install.
  Future<void> add(TifoActivityEntry entry) async {
    final userId = _userId;
    if (userId == null) {
      return; // no profile to attribute it to; dropping beats mis-filing it
    }
    final box = await ref.read(hiveProvider(_kTifoActivityBoxName).future);
    final current = state.value ?? const <TifoActivityEntry>[];
    final updated = [entry, ...current].take(kTifoActivityMaxEntries).toList(growable: false);
    await box.put(_entriesKey(userId), [for (final e in updated) e.toJson()]);
    state = AsyncData(updated);
  }
}

final tifoActivityLogProvider = AsyncNotifierProvider<TifoActivityLogController, List<TifoActivityEntry>>(
  TifoActivityLogController.new,
);
