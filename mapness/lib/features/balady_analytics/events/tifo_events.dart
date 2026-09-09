import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:mapness/features/balady_analytics/balady_analytics.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

/// TIFO analytics — Event Spec v1, six events (docs/analytics-tracking-plan.md). Covers what
/// the backend cannot see: attention, friction, drop-off, device timing. Caps and event-name
/// literals live here, not at call sites — see each method's doc for its cap.
abstract final class TifoEvents {
  // ─── Event names (immutable — see the tracking plan) ───────────────────────

  static const String _activated = 'tifo_activated';
  static const String _tutorialOutcome = 'tifo_tutorial_outcome';
  static const String _surfaceViewed = 'tifo_surface_viewed';
  static const String _blocked = 'tifo_blocked';
  static const String _playExit = 'tifo_play_exit';
  static const String _entryOutcome = 'tifo_entry_outcome';

  // ─── Injectable dependencies (production defaults; swapped in tests) ───────

  /// Wall clock, used for the debounce window and the Asia/Riyadh day stamp.
  @visibleForTesting
  static DateTime Function() now = DateTime.now;

  /// Current PostHog session id, or null with no session configured/reachable — degrades the
  /// per-session caps to per-app-run (safe direction: a few extra `tifo_surface_viewed`).
  @visibleForTesting
  static Future<String?> Function() sessionId = _posthogSessionId;

  /// Cross-launch storage for the two persisted caps.
  @visibleForTesting
  static TifoEventsStore store = const HiveTifoEventsStore();

  // ─── Cap state ────────────────────────────────────────────────────────────

  /// Session the [_viewedSurfaces] / [_blockedAt] sets belong to. A new
  /// PostHog session resets both.
  static String? _capsSession;
  static final Set<TifoSurface> _viewedSurfaces = {};
  static final Map<TifoBlockReason, DateTime> _blockedAt = {};

  /// Mirrors the persisted activation flag so a second call in the same run
  /// doesn't race the (async) Hive read.
  static bool _activatedSent = false;

  /// Minimum gap between two `tifo_blocked` events carrying the same reason.
  static const Duration blockedDebounce = Duration(seconds: 30);

  /// Asia/Riyadh is UTC+3 all year (no DST), so the game day is a fixed offset
  /// from UTC — the same rule the backend applies to the daily allowance.
  static const Duration _riyadhOffset = Duration(hours: 3);

  // ─── Events ───────────────────────────────────────────────────────────────

  /// The player became a player: `POST /clubs/select` succeeded. [source] is where the gate
  /// walk STARTED, not the confirm screen — answers "which entry point converts". Capped to
  /// one per install by a persisted flag.
  static Future<void> activated({required String clubId, required TifoActivationSource source}) async {
    if (_activatedSent) {
      return;
    }
    _activatedSent = true;
    try {
      if (await store.isActivatedRecorded()) {
        return;
      }
      await store.recordActivated();
    } on Object catch (_) {
      // Storage unavailable — send anyway. A duplicate on a broken Hive box is
      // cheaper than losing the activation funnel's first step entirely.
    }
    BaladyAnalytics.instance.track(
      _activated,
      properties: {
        'club_id': clubId,
        'source': source.wire,
      },
    );
  }

  /// The player left the guided tutorial, however that happened. [lastStep] is
  /// 1-based — the screen they were on when they left.
  static void tutorialOutcome({required TifoTutorialResult result, required int lastStep}) {
    BaladyAnalytics.instance.track(
      _tutorialOutcome,
      properties: {
        'result': result.wire,
        'last_step': lastStep,
      },
    );
  }

  /// First open of a TIFO surface in this PostHog session. [apiMs]/[renderMs] are omitted
  /// when unknown (a cache-painted tier has no request — `lt100` would lie). `first_of_day`
  /// piggybacks the player's first TIFO surface of the Asia/Riyadh day, at no extra event.
  static Future<void> surfaceViewed({required TifoSurface surface, int? apiMs, int? renderMs}) async {
    await _syncCapsSession();
    if (!_viewedSurfaces.add(surface)) {
      return;
    }
    var firstOfDay = false;
    final today = _riyadhDay(now());
    try {
      firstOfDay = await store.lastSurfaceDay() != today;
      if (firstOfDay) {
        await store.recordSurfaceDay(today);
      }
    } on Object catch (_) {
      // Storage unavailable — report the day marker as false rather than
      // inflating the daily-active count.
      firstOfDay = false;
    }
    BaladyAnalytics.instance.track(
      _surfaceViewed,
      properties: {
        'surface': surface.wire,
        if (apiMs != null) 'api_ms_bucket': msBucket(apiMs),
        if (renderMs != null) 'render_ms_bucket': msBucket(renderMs),
        'first_of_day': firstOfDay,
      },
    );
  }

  /// The UI refused a user intent. [surface] is where it happened. Debounced: the same
  /// [reason] fires at most once per [blockedDebounce] within a session, so a repeatedly
  /// tapped disabled CTA costs one event, not ten.
  static Future<void> blocked({required TifoBlockReason reason, required TifoSurface surface}) async {
    await _syncCapsSession();
    final at = now();
    final last = _blockedAt[reason];
    if (last != null && at.difference(last) < blockedDebounce) {
      return;
    }
    _blockedAt[reason] = at;
    BaladyAnalytics.instance.track(
      _blocked,
      properties: {
        'reason': reason.wire,
        'surface': surface.wire,
      },
    );
  }

  /// The client left an active game — the client-side half of a session the server only sees
  /// as "opened, then silence". One per run; the guard lives at the call site, which alone
  /// knows where a run begins and ends. [outcome] exists only for `completed`; never invented.
  static void playExit({
    required TifoPlayPhase phase,
    required TifoPlayExitReason reason,
    TifoPlayOutcome? outcome,
  }) {
    BaladyAnalytics.instance.track(
      _playExit,
      properties: {
        'phase': phase.wire,
        'reason': reason.wire,
        if (outcome != null) 'outcome': outcome.wire,
      },
    );
  }

  /// How the stories-style entry popup was dismissed — first fork in the activation funnel
  /// between `tifo_surface_viewed` and `tifo_activated`. No cap of its own: the popup already
  /// shows once per run (`hasSeenEntry`), so the event is bounded by app launches.
  static void entryOutcome({required TifoEntryAction action}) {
    BaladyAnalytics.instance.track(
      _entryOutcome,
      properties: {
        'action': action.wire,
      },
    );
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  /// Timing bucket for a millisecond measurement. Boundaries are inclusive on
  /// the lower end: 100 → `100_300`, 3000 → `gt3000`.
  @visibleForTesting
  static String msBucket(int ms) {
    if (ms < 100) {
      return 'lt100';
    }
    if (ms < 300) {
      return '100_300';
    }
    if (ms < 700) {
      return '300_700';
    }
    if (ms < 1500) {
      return '700_1500';
    }
    if (ms < 3000) {
      return '1500_3000';
    }
    return 'gt3000';
  }

  /// `yyyy-mm-dd` of [at] in Asia/Riyadh (UTC+3, no DST).
  @visibleForTesting
  static String riyadhDay(DateTime at) => _riyadhDay(at);

  static String _riyadhDay(DateTime at) {
    final local = at.toUtc().add(_riyadhOffset);
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '${local.year}-$month-$day';
  }

  /// Drops the per-session caps when PostHog has rotated the session.
  static Future<void> _syncCapsSession() async {
    String? id;
    try {
      id = await sessionId();
    } on Object catch (_) {
      id = null;
    }
    // A null id means "unknown session", not "new session" — treating every
    // null as a rotation would re-send the whole surface set on every call.
    final key = id ?? _capsSession ?? _unknownSession;
    if (key != _capsSession) {
      _capsSession = key;
      _viewedSurfaces.clear();
      _blockedAt.clear();
    }
  }

  static const String _unknownSession = 'unknown';

  static Future<String?> _posthogSessionId() => Posthog().getSessionId();

  /// Clears every in-memory cap. Tests only — production state is per app run.
  @visibleForTesting
  static void resetForTesting() {
    _capsSession = null;
    _viewedSurfaces.clear();
    _blockedAt.clear();
    _activatedSent = false;
  }
}

/// Where the play-gate walk that ended in a club pick was started. `building_sheet` and
/// `leaderboard` extend the spec's list — folding them into `banner` would hide two
/// highest-intent doors into the game. `deeplink` is declared but unused (no deep links yet).
enum TifoActivationSource {
  tutorial('tutorial'),
  banner('banner'),
  mapPill('map_pill'),
  districtSheet('district_sheet'),

  /// Reserved: no TIFO deep link exists yet.
  deeplink('deeplink'),

  buildingSheet('building_sheet'),
  leaderboard('leaderboard');

  const TifoActivationSource(this.wire);

  /// Value sent as the `source` property.
  final String wire;
}

/// How a guided-tutorial run ended.
enum TifoTutorialResult {
  /// Next pressed on the last screen.
  completed('completed'),

  /// The close `X` confirmation was accepted.
  skipped('skipped'),

  /// The route went away any other way (system back, programmatic pop).
  abandoned('abandoned');

  const TifoTutorialResult(this.wire);

  /// Value sent as the `result` property.
  final String wire;
}

/// A TIFO surface, as the attention funnel counts them.
///
/// `district` and `building` are the MAP TIERS (the polygon layers), not the
/// sheets that open on top of them — the funnel question is whether players
/// cross the zoom threshold at all.
enum TifoSurface {
  district('district'),
  building('building'),

  /// Leaderboard sheet, Table tab.
  leaderboard('leaderboard'),

  /// Leaderboard sheet, Profile tab.
  dashboard('dashboard');

  const TifoSurface(this.wire);

  /// Value sent as the `surface` property.
  final String wire;
}

/// Why the UI refused a user intent — the economy thermometer.
enum TifoBlockReason {
  noTokens('no_tokens'),
  cooldown('cooldown'),
  buildingLocked('building_locked'),
  notLoggedIn('not_logged_in'),
  noClub('no_club'),
  error('error');

  const TifoBlockReason(this.wire);

  /// Value sent as the `reason` property.
  final String wire;
}

/// How far a shootout had got when the client left it.
enum TifoPlayPhase {
  aiming('aiming'),
  resultPending('result_pending'),
  resultShown('result_shown');

  const TifoPlayPhase(this.wire);

  /// Value sent as the `phase` property.
  final String wire;
}

/// Why the client left an active game.
enum TifoPlayExitReason {
  completed('completed'),
  backgrounded('backgrounded'),
  connectionLost('connection_lost'),

  /// The AFK prompt timed the player out, or the server voided an expired
  /// session on submit.
  timeout('timeout'),

  userQuit('user_quit');

  const TifoPlayExitReason(this.wire);

  /// Value sent as the `reason` property.
  final String wire;
}

/// The server's verdict on a finished shootout, as `tifo_play_exit` reports it. Mirrors the
/// API's `outcome` one-for-one, except `unknown` (an unrecognized string) has no member —
/// it maps to null at the call site, so a parser gap never shows up as a real result.
enum TifoPlayOutcome {
  /// A neutral building was taken.
  claimed('claimed'),

  /// A building was taken off another club.
  taken('taken'),

  /// The score did not beat the holder's.
  failed('failed'),

  /// The server voided the run (expired session, rejected event log).
  voided('voided');

  const TifoPlayOutcome(this.wire);

  /// Value sent as the `outcome` property.
  final String wire;
}

/// How the stories-style entry popup was dismissed.
enum TifoEntryAction {
  /// The popup's CTA — the player asked to go on into the game.
  cta('cta'),

  /// Close (X), a swipe-down, or system back.
  close('close');

  const TifoEntryAction(this.wire);

  /// Value sent as the `action` property.
  final String wire;
}

/// Cross-launch storage the two persisted caps need. Kept as an interface so
/// the caps are unit-testable without Hive.
abstract class TifoEventsStore {
  Future<bool> isActivatedRecorded();

  Future<void> recordActivated();

  /// `yyyy-mm-dd` of the last `tifo_surface_viewed`, or null when none was ever sent.
  Future<String?> lastSurfaceDay();

  Future<void> recordSurfaceDay(String day);
}

/// Default [TifoEventsStore]: the `tifo` Hive box the rest of the feature
/// already persists its one-off flags in (`tifo_flow_provider.dart`, the ⚽
/// layer toggle), so analytics adds keys rather than a box.
class HiveTifoEventsStore implements TifoEventsStore {
  /// Const so the default can live in a field initializer.
  const HiveTifoEventsStore();

  static const String _boxName = 'tifo';
  static const String _activatedKey = 'analyticsActivatedSent';
  static const String _surfaceDayKey = 'analyticsSurfaceDay';

  Future<Box<dynamic>> get _box async =>
      Hive.isBoxOpen(_boxName) ? Hive.box<dynamic>(_boxName) : await Hive.openBox<dynamic>(_boxName);

  @override
  Future<bool> isActivatedRecorded() async => (await _box).get(_activatedKey) == true;

  @override
  Future<void> recordActivated() async => (await _box).put(_activatedKey, true);

  @override
  Future<String?> lastSurfaceDay() async => (await _box).get(_surfaceDayKey) as String?;

  @override
  Future<void> recordSurfaceDay(String day) async => (await _box).put(_surfaceDayKey, day);
}
