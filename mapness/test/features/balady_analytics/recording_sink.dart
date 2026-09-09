import 'package:mapness/features/balady_analytics/balady_analytics_sink.dart';
import 'package:mapness/features/balady_analytics/events/tifo_events.dart';

/// One recorded call to [BaladyAnalyticsSink.identify].
class RecordedIdentifyCall {
  const RecordedIdentifyCall(this.userId, this.traits);

  final String? userId;
  final Map<String, dynamic> traits;
}

/// In-memory [BaladyAnalyticsSink] that records every call instead of
/// sending it anywhere, so a test can assert on the exact events (and
/// identity calls) a code path produced.
class RecordingBaladyAnalyticsSink implements BaladyAnalyticsSink {
  final List<BaladyAnalyticsEvent> events = [];
  final List<RecordedIdentifyCall> identifyCalls = [];
  final Map<String, Object?> sessionProperties = {};

  @override
  void track(BaladyAnalyticsEvent event) => events.add(event);

  @override
  void identify(String? userId, Map<String, dynamic> traits) {
    identifyCalls.add(RecordedIdentifyCall(userId, traits));
  }

  // No @override: the member exists on core's sink interface but not on development's.
  void setSessionProperty(String key, Object? value) {
    sessionProperties[key] = value;
  }
}

/// In-memory [TifoEventsStore] for tests, with an optional [throwOnCall]
/// switch that makes every method throw — simulating a broken Hive box so
/// the "send anyway" / "report false" fallbacks in `tifo_events.dart` can be
/// exercised without touching Hive.
class FakeTifoEventsStore implements TifoEventsStore {
  bool activatedRecorded = false;
  String? surfaceDay;
  bool throwOnCall = false;

  void _maybeThrow() {
    if (throwOnCall) {
      throw StateError('FakeTifoEventsStore: simulated broken store');
    }
  }

  @override
  Future<bool> isActivatedRecorded() async {
    _maybeThrow();
    return activatedRecorded;
  }

  @override
  Future<void> recordActivated() async {
    _maybeThrow();
    activatedRecorded = true;
  }

  @override
  Future<String?> lastSurfaceDay() async {
    _maybeThrow();
    return surfaceDay;
  }

  @override
  Future<void> recordSurfaceDay(String day) async {
    _maybeThrow();
    surfaceDay = day;
  }
}
