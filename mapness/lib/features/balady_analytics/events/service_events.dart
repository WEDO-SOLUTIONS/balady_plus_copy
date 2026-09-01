import 'package:mapness/features/balady_analytics/balady_analytics.dart';

/// Phase-1 "Services / mini-apps" events — docs/analytics-tracking-plan.md.
///
/// `service_opened` / `service_closed` are sent from the Flutter side at the
/// mini-app webview screen boundary (`MiniAppsMainScreen` in the host shell);
/// internal mini-app JS-bridge events are deliberately not forwarded.
abstract final class ServiceEvents {
  static const _serviceOpened = 'service_opened';
  static const _serviceClosed = 'service_closed';

  /// Canonical `source` values for [opened].
  static const sourceServicesTab = 'services_tab';
  static const sourceStory = 'story';
  static const sourceSearch = 'search';
  static const sourceQuickAction = 'quick_action';

  /// A source hint survives at most this long between the tap that triggers a
  /// mini-app open and the webview screen actually appearing (the open flow
  /// may detour through login sheets or a first-time bundle download); an
  /// expired or absent hint falls back to [sourceServicesTab].
  static const _pendingSourceTtl = Duration(seconds: 30);

  static String? _pendingSource;
  static DateTime? _pendingSourceSetAt;

  /// Call right before triggering a mini-app open from a non-default entry
  /// point (story CTA, services search, dashboard quick action). Consumed by
  /// the next [opened]; without a fresh hint the source defaults to
  /// [sourceServicesTab].
  static void setPendingOpenSource(String source) {
    _pendingSource = source;
    _pendingSourceSetAt = DateTime.now();
  }

  static String _consumePendingSource() {
    final source = _pendingSource;
    final setAt = _pendingSourceSetAt;
    _pendingSource = null;
    _pendingSourceSetAt = null;
    if (source == null || setAt == null || DateTime.now().difference(setAt) > _pendingSourceTtl) {
      return sourceServicesTab;
    }
    return source;
  }

  /// Mini-app webview opened. [serviceId] is the mini-app's stable
  /// `serviceKey`. [source] overrides the pending-source mechanism when the
  /// call site knows its own entry point.
  static void opened({required String serviceId, String? source}) {
    BaladyAnalytics.instance.track(
      _serviceOpened,
      properties: {'service_id': serviceId, 'source': source ?? _consumePendingSource()},
    );
  }

  /// Mini-app webview closed after being open for [duration] (wall-clock).
  static void closed({required String serviceId, required Duration duration}) {
    BaladyAnalytics.instance.track(
      _serviceClosed,
      properties: {'service_id': serviceId, 'duration_sec': duration.inSeconds},
    );
  }
}
