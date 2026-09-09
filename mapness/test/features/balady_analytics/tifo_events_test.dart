import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/features/balady_analytics/balady_analytics.dart';
import 'package:mapness/features/balady_analytics/balady_analytics_mode.dart';
import 'package:mapness/features/balady_analytics/events/tifo_events.dart';

import 'recording_sink.dart';

/// Covers `tifo_events.dart` against "Tifo Analytics — Event Spec v1"
/// (data/jira/BE-327/spec.md): the five event shapes, their caps (once per
/// install, once per surface per session, 30 s debounce), and the ms/day
/// bucketing helpers. No Hive, no PostHog — `TifoEvents.now`, `.sessionId`
/// and `.store` are swapped for fakes, and events are captured by a
/// [RecordingBaladyAnalyticsSink] instead of leaving the process.
///
/// `BaladyAnalytics` is a process-wide singleton whose `configure` is
/// idempotent (first call wins) — one `setUpAll` wires the recording sink for
/// every test below, which is safe because `flutter test` runs each test
/// file in its own isolate.
void main() {
  final sink = RecordingBaladyAnalyticsSink();
  late FakeTifoEventsStore store;

  setUpAll(() {
    BaladyAnalytics.instance.configure(mode: BaladyAnalyticsMode.dual, sink: sink);
  });

  setUp(() {
    TifoEvents.resetForTesting();
    store = FakeTifoEventsStore();
    TifoEvents.store = store;
    TifoEvents.now = () => DateTime.utc(2026, 9, 9, 10);
    TifoEvents.sessionId = () async => 's1';
  });

  group('msBucket', () {
    test('boundaries', () {
      expect(TifoEvents.msBucket(0), 'lt100');
      expect(TifoEvents.msBucket(99), 'lt100');
      expect(TifoEvents.msBucket(100), '100_300');
      expect(TifoEvents.msBucket(299), '100_300');
      expect(TifoEvents.msBucket(300), '300_700');
      expect(TifoEvents.msBucket(699), '300_700');
      expect(TifoEvents.msBucket(700), '700_1500');
      expect(TifoEvents.msBucket(1499), '700_1500');
      expect(TifoEvents.msBucket(1500), '1500_3000');
      expect(TifoEvents.msBucket(2999), '1500_3000');
      expect(TifoEvents.msBucket(3000), 'gt3000');
      expect(TifoEvents.msBucket(3001), 'gt3000');
    });
  });

  group('riyadhDay', () {
    test('21:30 UTC rolls over to the next day in Riyadh (UTC+3)', () {
      expect(TifoEvents.riyadhDay(DateTime.utc(2026, 9, 9, 21, 30)), '2026-09-10');
    });

    test('20:59 UTC stays on the same day in Riyadh', () {
      expect(TifoEvents.riyadhDay(DateTime.utc(2026, 9, 9, 20, 59)), '2026-09-09');
    });

    test('formats as yyyy-mm-dd, zero-padded', () {
      expect(TifoEvents.riyadhDay(DateTime.utc(2026, 1, 4, 12)), '2026-01-04');
    });
  });

  group('activated', () {
    test('fires once with club_id and source wire values', () async {
      final before = sink.events.length;
      await TifoEvents.activated(clubId: 'club-1', source: TifoActivationSource.banner);
      final added = sink.events.sublist(before);
      expect(added, hasLength(1));
      expect(added.single.name, 'tifo_activated');
      expect(added.single.properties['club_id'], 'club-1');
      expect(added.single.properties['source'], 'banner');
    });

    test('a second call in the same run does not fire again', () async {
      final before = sink.events.length;
      await TifoEvents.activated(clubId: 'club-1', source: TifoActivationSource.banner);
      await TifoEvents.activated(clubId: 'club-1', source: TifoActivationSource.banner);
      expect(sink.events.length - before, 1);
    });

    test('a fresh run with the flag already recorded does not fire', () async {
      store.activatedRecorded = true;
      final before = sink.events.length;
      await TifoEvents.activated(clubId: 'club-1', source: TifoActivationSource.banner);
      expect(sink.events.length, before);
    });

    test('a throwing store still fires (send-anyway)', () async {
      store.throwOnCall = true;
      final before = sink.events.length;
      await TifoEvents.activated(clubId: 'club-1', source: TifoActivationSource.banner);
      expect(sink.events.length - before, 1);
    });
  });

  group('surfaceViewed', () {
    test('the same surface twice in one session fires once', () async {
      final before = sink.events.length;
      await TifoEvents.surfaceViewed(surface: TifoSurface.district);
      await TifoEvents.surfaceViewed(surface: TifoSurface.district);
      expect(sink.events.length - before, 1);
    });

    test('four different surfaces fire four events', () async {
      final before = sink.events.length;
      for (final surface in TifoSurface.values) {
        await TifoEvents.surfaceViewed(surface: surface);
      }
      expect(sink.events.length - before, 4);
    });

    test('a rotated session id lets the same surface fire again', () async {
      final before = sink.events.length;
      TifoEvents.sessionId = () async => 's1';
      await TifoEvents.surfaceViewed(surface: TifoSurface.district);
      TifoEvents.sessionId = () async => 's2';
      await TifoEvents.surfaceViewed(surface: TifoSurface.district);
      expect(sink.events.length - before, 2);
    });

    test('a null session id does not reset the set', () async {
      final before = sink.events.length;
      TifoEvents.sessionId = () async => 's1';
      await TifoEvents.surfaceViewed(surface: TifoSurface.district);
      TifoEvents.sessionId = () async => null;
      // Same surface, still within the "s1" session as far as the cap can
      // tell — a null session id must not be treated as a rotation.
      await TifoEvents.surfaceViewed(surface: TifoSurface.district);
      expect(sink.events.length - before, 1);
    });

    test('api_ms_bucket / render_ms_bucket are absent (not null) when the ms args are null', () async {
      final before = sink.events.length;
      await TifoEvents.surfaceViewed(surface: TifoSurface.district);
      final props = sink.events[before].properties;
      expect(props.containsKey('api_ms_bucket'), isFalse);
      expect(props.containsKey('render_ms_bucket'), isFalse);
    });

    test('api_ms_bucket / render_ms_bucket carry bucket strings when the ms args are given', () async {
      final before = sink.events.length;
      await TifoEvents.surfaceViewed(surface: TifoSurface.district, apiMs: 150, renderMs: 800);
      final props = sink.events[before].properties;
      expect(props['api_ms_bucket'], '100_300');
      expect(props['render_ms_bucket'], '700_1500');
    });

    test('first_of_day is true on the first event of a Riyadh day, false on the second', () async {
      final before = sink.events.length;
      TifoEvents.now = () => DateTime.utc(2026, 9, 9, 10);
      await TifoEvents.surfaceViewed(surface: TifoSurface.district);
      await TifoEvents.surfaceViewed(surface: TifoSurface.building);
      expect(sink.events[before].properties['first_of_day'], isTrue);
      expect(sink.events[before + 1].properties['first_of_day'], isFalse);
    });

    test('first_of_day is true again after crossing the Riyadh midnight (21:00 UTC)', () async {
      final before = sink.events.length;
      TifoEvents.now = () => DateTime.utc(2026, 9, 9, 10);
      await TifoEvents.surfaceViewed(surface: TifoSurface.district);
      TifoEvents.now = () => DateTime.utc(2026, 9, 9, 21, 30);
      await TifoEvents.surfaceViewed(surface: TifoSurface.building);
      expect(sink.events[before].properties['first_of_day'], isTrue);
      expect(sink.events[before + 1].properties['first_of_day'], isTrue);
    });

    test('a throwing store yields first_of_day: false', () async {
      store.throwOnCall = true;
      final before = sink.events.length;
      await TifoEvents.surfaceViewed(surface: TifoSurface.district);
      expect(sink.events[before].properties['first_of_day'], isFalse);
    });
  });

  group('blocked', () {
    test('the same reason twice within 30 s fires once', () async {
      final before = sink.events.length;
      TifoEvents.now = () => DateTime.utc(2026, 9, 9, 10);
      await TifoEvents.blocked(reason: TifoBlockReason.noTokens, surface: TifoSurface.building);
      await TifoEvents.blocked(reason: TifoBlockReason.noTokens, surface: TifoSurface.building);
      expect(sink.events.length - before, 1);
    });

    test('the same reason fires again once the debounce window has elapsed', () async {
      final before = sink.events.length;
      final t0 = DateTime.utc(2026, 9, 9, 10);
      TifoEvents.now = () => t0;
      await TifoEvents.blocked(reason: TifoBlockReason.cooldown, surface: TifoSurface.building);
      TifoEvents.now = () => t0.add(TifoEvents.blockedDebounce);
      await TifoEvents.blocked(reason: TifoBlockReason.cooldown, surface: TifoSurface.building);
      expect(sink.events.length - before, 2);
    });

    test('two different reasons back-to-back both fire', () async {
      final before = sink.events.length;
      TifoEvents.now = () => DateTime.utc(2026, 9, 9, 10);
      await TifoEvents.blocked(reason: TifoBlockReason.noTokens, surface: TifoSurface.building);
      await TifoEvents.blocked(reason: TifoBlockReason.buildingLocked, surface: TifoSurface.building);
      expect(sink.events.length - before, 2);
    });

    test('properties are reason and surface wire values', () async {
      final before = sink.events.length;
      TifoEvents.now = () => DateTime.utc(2026, 9, 9, 10);
      await TifoEvents.blocked(reason: TifoBlockReason.notLoggedIn, surface: TifoSurface.leaderboard);
      final props = sink.events[before].properties;
      expect(props['reason'], 'not_logged_in');
      expect(props['surface'], 'leaderboard');
    });
  });

  group('playExit', () {
    test('properties are phase and reason wire values', () {
      final before = sink.events.length;
      TifoEvents.playExit(phase: TifoPlayPhase.aiming, reason: TifoPlayExitReason.backgrounded);
      final props = sink.events[before].properties;
      expect(props['phase'], 'aiming');
      expect(props['reason'], 'backgrounded');
    });
  });

  group('tutorialOutcome', () {
    test('properties are result and last_step, last_step is an int', () {
      final before = sink.events.length;
      TifoEvents.tutorialOutcome(result: TifoTutorialResult.abandoned, lastStep: 3);
      final props = sink.events[before].properties;
      expect(props['result'], 'abandoned');
      expect(props['last_step'], 3);
      expect(props['last_step'], isA<int>());
    });
  });

  // Runs last on purpose: it inspects every event captured by `sink` over
  // the whole file, so it must not run before the groups above have added
  // theirs. `flutter test` runs a file's tests in declaration order.
  group('cross-cutting', () {
    const specEventNames = {
      'tifo_activated',
      'tifo_tutorial_outcome',
      'tifo_surface_viewed',
      'tifo_blocked',
      'tifo_play_exit',
    };
    // Added by the BaladyAnalytics facade itself (session properties /
    // screen context), not by TifoEvents — allowed alongside the snake_case
    // keys TifoEvents controls.
    const facadeDollarKeys = {r'$screen_name'};
    final snakeCase = RegExp(r'^[a-z][a-z0-9_]*$');

    test('every recorded event name is one of the five spec names', () {
      expect(sink.events, isNotEmpty);
      for (final event in sink.events) {
        expect(specEventNames.contains(event.name), isTrue, reason: 'unexpected event name "${event.name}"');
      }
    });

    test('every property key is snake_case without a \$ prefix, except facade-added keys', () {
      for (final event in sink.events) {
        for (final key in event.properties.keys) {
          if (key.startsWith(r'$')) {
            expect(
              facadeDollarKeys.contains(key),
              isTrue,
              reason: 'unexpected \$-prefixed key "$key" on ${event.name}',
            );
            continue;
          }
          expect(snakeCase.hasMatch(key), isTrue, reason: 'key "$key" on ${event.name} is not snake_case');
        }
      }
    });

    test('every property value is a String, bool or int', () {
      for (final event in sink.events) {
        for (final entry in event.properties.entries) {
          final value = entry.value;
          expect(
            value is String || value is bool || value is int,
            isTrue,
            reason: 'property "${entry.key}" on ${event.name} has type ${value.runtimeType}',
          );
        }
      }
    });

    test('identify was never invoked on the sink', () {
      expect(sink.identifyCalls, isEmpty);
    });
  });
}
