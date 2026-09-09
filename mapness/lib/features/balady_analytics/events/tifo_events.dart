import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:mapness/features/balady_analytics/balady_analytics.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

/// Phase-2 TIFO events — "Tifo Analytics — Event Spec v1", five events, no more
/// (docs/analytics-tracking-plan.md).
///
/// The game loop itself is already attributable server-side (every play goes
/// through the TIFO API under an authenticated bearer), so these events cover
/// only what the backend cannot see: **attention, friction, drop-off and
/// device-side timing**. Volume is bounded by construction, not by hope — each
/// event carries an explicit cap, implemented in this file:
///
///  * [activated] — once per install (persisted flag);
///  * [surfaceViewed] — once per surface per PostHog session, ≤4/session;
///  * [blocked] — same reason at most once per 30 s;
///  * [playExit] — once per shootout (guarded at the call site);
///  * [tutorialOutcome] — effectively once per user, replays included.
///
/// Rules this module exists to enforce:
///  * the five event-name literals live HERE and nowhere else — PostHog cannot
///    rename an event retroactively;
///  * every property value comes from an enum, serialized snake_case;
///  * raw millisecond timings never leave this file — they are bucketed
///    ([msBucket]) so property cardinality stays flat;
///  * no `identify()` from TIFO: anonymous events bill cheaper and logged-in
///    players are already identified by the host auth flow;
///  * no coordinates, no building/district ids, no bearer — the backend owns
///    that data.
abstract final class TifoEvents {
  // ─── Event names (immutable — see the tracking plan) ───────────────────────

  static const String _activated = 'tifo_activated';
  static const String _tutorialOutcome = 'tifo_tutorial_outcome';
  static const String _surfaceViewed = 'tifo_surface_viewed';
  static const String _blocked = 'tifo_blocked';
  static const String _playExit = 'tifo_play_exit';

  // ─── Injectable dependencies (production defaults; swapped in tests) ───────

  /// Wall clock, used for the debounce window and the Asia/Riyadh day stamp.
  @visibleForTesting
  static DateTime Function() now = DateTime.now;

  /// Current PostHog session id, or null when the SDK has no session (no key
  /// configured for this flavor, or the call failed). A null id degrades the
  /// per-session caps to per-app-run caps, which is the safe direction: at
  /// most four extra `tifo_surface_viewed` per run.
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

  /// The player became a player: `POST /clubs/select` succeeded.
  ///
  /// [source] is the surface the gate walk STARTED from, not the screen the
  /// confirm button lives on — that is the question this event answers ("which
  /// entry point converts"). Capped to one per install by a persisted flag;
  /// the server's one-time `/clubs/select` semantics remains the truth.
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

  /// First open of a TIFO surface in this PostHog session.
  ///
  /// [apiMs] is the backend round-trip that fed the surface and [renderMs] the
  /// parse-to-painted span on the client; both are bucketed, and either is
  /// omitted entirely when unknown (a tier painted from cache has no request
  /// to report — an `api_ms_bucket` of `lt100` would be a lie, and a 0 would
  /// poison the distribution).
  ///
  /// `first_of_day` marks the player's first TIFO surface of the calendar day
  /// in Asia/Riyadh — a DAU-of-TIFO marker that costs no extra event.
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

  /// The UI refused a user intent. [surface] is where it happened.
  ///
  /// Debounced: the same [reason] fires at most once per [blockedDebounce]
  /// within a session, so a player tapping a disabled CTA repeatedly costs one
  /// event, not ten.
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

  /// The client left an active game, however that happened — the client-side
  /// half of a play session the server only sees as "opened, then silence".
  ///
  /// Exactly one per shootout run; the guard lives at the call site because
  /// only it knows where a run begins and ends.
  static void playExit({required TifoPlayPhase phase, required TifoPlayExitReason reason}) {
    BaladyAnalytics.instance.track(
      _playExit,
      properties: {
        'phase': phase.wire,
        'reason': reason.wire,
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

/// Where the play-gate walk that ended in a club pick was started.
///
/// `building_sheet` and `leaderboard` are additions to the spec's list: both
/// entry points exist in the shipped UI (the building sheet's Challenge CTA and
/// the leaderboard's "Dominate with your team" footer) and folding them into
/// `banner` would hide the two highest-intent doors into the game.
/// `deeplink` is declared but unused — TIFO has no deep links yet.
enum TifoActivationSource {
  /// The guided tutorial routed the player onward into team select.
  tutorial('tutorial'),

  /// The ⚽ control's stories-style entry popup CTA.
  banner('banner'),

  /// The floating "Dominate with your team" pill over the map.
  mapPill('map_pill'),

  /// The district sheet's "Take over" CTA.
  districtSheet('district_sheet'),

  /// Reserved: no TIFO deep link exists yet.
  deeplink('deeplink'),

  /// The building sheet's Challenge / Claim CTA.
  buildingSheet('building_sheet'),

  /// The leaderboard sheet's footer CTA.
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
  /// District mosaic tier of the map layer.
  district('district'),

  /// Individual-buildings tier of the map layer.
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
  /// Balance below the play cost.
  noTokens('no_tokens'),

  /// The building is in its post-capture cooldown.
  cooldown('cooldown'),

  /// Someone else holds a live session on the building.
  buildingLocked('building_locked'),

  /// The gate walk stopped at the login step.
  notLoggedIn('not_logged_in'),

  /// The gate walk stopped at team select.
  noClub('no_club'),

  /// A backend/network failure was shown to the player.
  error('error');

  const TifoBlockReason(this.wire);

  /// Value sent as the `reason` property.
  final String wire;
}

/// How far a shootout had got when the client left it.
enum TifoPlayPhase {
  /// Armed and shooting, before the game reported an outcome.
  aiming('aiming'),

  /// The result submit is in flight.
  resultPending('result_pending'),

  /// The win/loss hero is on screen.
  resultShown('result_shown');

  const TifoPlayPhase(this.wire);

  /// Value sent as the `phase` property.
  final String wire;
}

/// Why the client left an active game.
enum TifoPlayExitReason {
  /// Normal end: the result screen was shown.
  completed('completed'),

  /// The app went to the background mid-game.
  backgrounded('backgrounded'),

  /// Connectivity dropped and the session was written off.
  connectionLost('connection_lost'),

  /// The AFK prompt timed the player out, or the server voided an expired
  /// session on submit.
  timeout('timeout'),

  /// The player confirmed "Leave" on the exit dialog.
  userQuit('user_quit');

  const TifoPlayExitReason(this.wire);

  /// Value sent as the `reason` property.
  final String wire;
}

/// Cross-launch storage the two persisted caps need. Kept as an interface so
/// the caps are unit-testable without Hive.
abstract class TifoEventsStore {
  /// Whether `tifo_activated` has already been sent on this install.
  Future<bool> isActivatedRecorded();

  /// Stamps the once-per-lifetime activation flag.
  Future<void> recordActivated();

  /// Asia/Riyadh day (`yyyy-mm-dd`) of the last `tifo_surface_viewed`, or null
  /// when none was ever sent.
  Future<String?> lastSurfaceDay();

  /// Remembers [day] as the day of the most recent `tifo_surface_viewed`.
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
