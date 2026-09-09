import 'package:flutter/foundation.dart';

/// What kind of signal an event carries. Kept deliberately small: product
/// actions, screen views and caught errors cover everything the ex-UXCam
/// stream produced.
enum BaladyAnalyticsEventKind { track, screen, error }

/// A single analytics event as our pipeline sees it.
///
/// Shape mirrors what a PostHog `capture` call needs (event name + properties
/// + distinct id handled by the sink), so swapping the logging sink for a real
/// transport does not require touching call sites.
@immutable
class BaladyAnalyticsEvent {
  const BaladyAnalyticsEvent({
    required this.name,
    required this.kind,
    this.properties = const {},
    this.error,
    this.stackTrace,
  });

  final String name;
  final BaladyAnalyticsEventKind kind;
  final Map<String, dynamic> properties;

  /// Raw throwable behind a [BaladyAnalyticsEventKind.error] event, kept
  /// alongside its stringified form in [properties]. A transport that groups
  /// exceptions (PostHog Error Tracking) needs the object and the real
  /// [StackTrace] to build a frame list; a flat string only ever yields one
  /// unreadable, ungroupable issue.
  final Object? error;
  final StackTrace? stackTrace;

  @override
  String toString() => '[${kind.name}] $name ${properties.isEmpty ? '' : properties}';
}

/// Receiving end of the facade. Implementations: [LoggingBaladyAnalyticsSink]
/// today, a PostHog (self-hosted) transport next.
abstract class BaladyAnalyticsSink {
  void track(BaladyAnalyticsEvent event);

  /// [userId] is null on logout — the sink must reset identity, mirroring the
  /// BytePlus `setUserUniqueId(null)` contract.
  void identify(String? userId, Map<String, dynamic> traits);
}

/// Debug-only sink: prints every event so QA can verify the stream in logs.
/// In release builds it is a no-op — nothing leaves the device until a real
/// transport (PostHog self-hosted) replaces it.
class LoggingBaladyAnalyticsSink implements BaladyAnalyticsSink {
  @override
  void track(BaladyAnalyticsEvent event) {
    if (kDebugMode) {
      debugPrint('[BaladyAnalytics] $event');
    }
  }

  @override
  void identify(String? userId, Map<String, dynamic> traits) {
    if (kDebugMode) {
      debugPrint('[BaladyAnalytics] identify ${userId ?? '<reset>'} $traits');
    }
  }
}
