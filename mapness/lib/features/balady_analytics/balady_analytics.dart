import 'package:mapness/features/balady_analytics/balady_analytics_mode.dart';
import 'package:mapness/features/balady_analytics/balady_analytics_sink.dart';

export 'package:mapness/features/balady_analytics/balady_analytics_mode.dart';
export 'package:mapness/features/balady_analytics/balady_analytics_navigator_observer.dart';
export 'package:mapness/features/balady_analytics/balady_analytics_sink.dart';
export 'package:mapness/features/balady_analytics/posthog_balady_analytics_sink.dart';
export 'package:mapness/features/balady_analytics/urbi_balady_analytics_sink.dart';

/// Named destinations an event can be routed to. [ours] is our own pipeline
/// (PostHog Cloud EU) and obeys [BaladyAnalyticsMode]; the rest are legacy
/// production streams that keep flowing regardless of mode until their
/// migration phase ends.
enum BaladyAnalyticsChannel { ours, urbi }

/// Single entry point for Balady's own analytics pipeline (product + tech
/// events into our PostHog Cloud EU project). See README.md next to this file.
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
  final Map<BaladyAnalyticsChannel, BaladyAnalyticsSink> _channelSinks = {};
  final List<(BaladyAnalyticsEvent, Set<BaladyAnalyticsChannel>)> _pending = [];
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

    final buffered = List<(BaladyAnalyticsEvent, Set<BaladyAnalyticsChannel>)>.of(_pending);
    _pending.clear();
    for (final (event, channels) in buffered) {
      _send(event, channels);
    }
  }

  /// Attach a legacy stream as a named channel, so call sites can fan an event
  /// out to it through the facade ([ours] is fixed and configured via
  /// [configure]). Events routed to a channel before registration are dropped.
  void registerChannel(BaladyAnalyticsChannel channel, BaladyAnalyticsSink sink) {
    assert(channel != BaladyAnalyticsChannel.ours, 'ours is the configure()d sink, not a registered channel');
    _channelSinks[channel] = sink;
  }

  /// Product/tech event. [properties] must be JSON-serializable. [channels]
  /// widens the fan-out to legacy streams during their migration under this
  /// facade; [BaladyAnalyticsChannel.ours] alone is the steady state.
  void track(
    String name, {
    Map<String, dynamic>? properties,
    Set<BaladyAnalyticsChannel> channels = const {BaladyAnalyticsChannel.ours},
  }) {
    _dispatch(
      BaladyAnalyticsEvent(
        name: name,
        kind: BaladyAnalyticsEventKind.track,
        properties: {..._sessionProperties, ...?properties},
      ),
      channels: channels,
    );
  }

  /// Screen view — replaces UXCam `tagScreenName`.
  ///
  /// Deferred to tracking-plan Phase 1.5: `$screen` dominates event quota (~80%
  /// of projected volume) while the dependent screen-time metric is not a
  /// priority. Call sites stay wired; flip [_screenCaptureEnabled] to re-enable
  /// (docs/analytics-tracking-plan.md).
  static const _screenCaptureEnabled = false;

  void screen(String path) {
    if (!_screenCaptureEnabled) {
      return;
    }
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

  void _dispatch(
    BaladyAnalyticsEvent event, {
    Set<BaladyAnalyticsChannel> channels = const {BaladyAnalyticsChannel.ours},
  }) {
    if (!_configured) {
      if (_pending.length < _pendingLimit) {
        _pending.add((event, channels));
      }
      return;
    }
    _send(event, channels);
  }

  void _send(BaladyAnalyticsEvent event, Set<BaladyAnalyticsChannel> channels) {
    for (final channel in channels) {
      if (channel == BaladyAnalyticsChannel.ours) {
        if (_mode.sendToOurs) {
          _sink.track(event);
        }
      } else {
        _channelSinks[channel]?.track(event);
      }
    }
  }
}
