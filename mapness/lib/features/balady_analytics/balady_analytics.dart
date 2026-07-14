import 'package:mapness/features/balady_analytics/balady_analytics_mode.dart';
import 'package:mapness/features/balady_analytics/balady_analytics_sink.dart';

export 'package:mapness/features/balady_analytics/balady_analytics_mode.dart';
export 'package:mapness/features/balady_analytics/balady_analytics_navigator_observer.dart';
export 'package:mapness/features/balady_analytics/balady_analytics_sink.dart';

/// Single entry point for Balady's own analytics pipeline (product + tech
/// events into our self-hosted backend). See README.md next to this file.
///
/// Static singleton on purpose: it is called from both the host shell
/// (`lib/`, bloc-based) and the mapness module (Riverpod), including places
/// with no context/ref at hand — same access pattern as `BssService.instance`.
///
/// Lifecycle: events fired before [configure] are buffered (the host shell
/// starts logging before `setupMapness` runs) and flushed once the mode is
/// known. [configure] is idempotent — both the host `App` and mapness
/// `entry_point` call it, whichever comes first wins.
class BaladyAnalytics {
  BaladyAnalytics._();

  static final BaladyAnalytics instance = BaladyAnalytics._();

  static const _pendingLimit = 200;

  BaladyAnalyticsMode _mode = BaladyAnalyticsMode.legacy;
  bool _configured = false;
  BaladyAnalyticsSink _sink = LoggingBaladyAnalyticsSink();
  final List<BaladyAnalyticsEvent> _pending = [];
  final Map<String, dynamic> _sessionProperties = {};

  BaladyAnalyticsMode get mode => _mode;

  void configure({required BaladyAnalyticsMode mode, BaladyAnalyticsSink? sink}) {
    if (_configured) {
      return;
    }
    _configured = true;
    _mode = mode;
    if (sink != null) {
      _sink = sink;
    }

    final buffered = List<BaladyAnalyticsEvent>.of(_pending);
    _pending.clear();
    if (_mode.sendToOurs) {
      buffered.forEach(_sink.track);
    }
  }

  /// Product/tech event. [properties] must be JSON-serializable.
  void track(String name, {Map<String, dynamic>? properties}) {
    _dispatch(
      BaladyAnalyticsEvent(
        name: name,
        kind: BaladyAnalyticsEventKind.track,
        properties: {..._sessionProperties, ...?properties},
      ),
    );
  }

  /// Screen view — replaces UXCam `tagScreenName`.
  void screen(String path) {
    _dispatch(
      BaladyAnalyticsEvent(
        name: r'$screen',
        kind: BaladyAnalyticsEventKind.screen,
        properties: {..._sessionProperties, 'path': path},
      ),
    );
  }

  /// Caught exception worth counting. Crash reporting stays in Sentry; this
  /// only keeps the ex-UXCam "handled exception" counters alive.
  void error(Object? exception, [StackTrace? stack]) {
    _dispatch(
      BaladyAnalyticsEvent(
        name: r'$exception',
        kind: BaladyAnalyticsEventKind.error,
        properties: {
          ..._sessionProperties,
          'exception': exception.toString(),
          if (stack != null) 'stack': stack.toString(),
        },
      ),
    );
  }

  /// Login/logout. [userId] null resets identity (logout) — same contract as
  /// the legacy BytePlus `setUserUniqueId`.
  void identify({String? userId, Map<String, dynamic>? traits}) {
    if (!_configured || _mode.sendToOurs) {
      _sink.identify(userId, traits ?? const {});
    }
  }

  /// Logout — resets user identity in the sink.
  void resetIdentity() {
    if (!_configured || _mode.sendToOurs) {
      _sink.identify(null, const {});
    }
  }

  /// Sticky property attached to every subsequent event of this app run —
  /// replaces UXCam `setSessionProperty`.
  void setSessionProperty(String key, Object? value) {
    _sessionProperties[key] = value;
  }

  void _dispatch(BaladyAnalyticsEvent event) {
    if (!_configured) {
      if (_pending.length < _pendingLimit) {
        _pending.add(event);
      }
      return;
    }
    if (_mode.sendToOurs) {
      _sink.track(event);
    }
  }
}
