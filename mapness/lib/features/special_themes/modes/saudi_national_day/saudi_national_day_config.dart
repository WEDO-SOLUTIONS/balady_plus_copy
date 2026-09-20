/// Resolved settings for the Saudi National Day theme.
///
/// The activation window is remote-driven: it comes from
/// `saudiNationalDayDateRange` inside the `app_env_config` Firebase Remote
/// Config parameter, which Firebase re-fetches on every app open. See
/// [saudiNationalDayResolvedConfigProvider] for the wiring.
///
/// ```json
/// "saudiNationalDayDateRange": { "from": "22-09-26", "to": "24-09-26", "enabled": true }
/// ```
class SaudiNationalDayRemoteConfig {
  const SaudiNationalDayRemoteConfig({
    required this.enabled,
    required this.startDate,
    required this.endDate,
    required this.anniversary,
    required this.appIconEnabled,
  });

  /// Master switch — mirrors the optional `enabled` flag on the date range.
  final bool enabled;

  /// Inclusive start of the activation window, at 00:00:00 local time.
  final DateTime startDate;

  /// Inclusive end of the activation window, at 23:59:59 local time.
  final DateTime endDate;

  /// Number rendered in the dashboard banner ("96 Years of Glory").
  ///
  /// Not part of the remote date range — bump it here when the year rolls
  /// over. `CityEventDateRange` has no field for it.
  final int anniversary;

  /// Gates the launcher-icon swap independently of the in-app theme.
  final bool appIconEnabled;

  /// Fallback used before remote config has loaded, and the source of the
  /// values [CityEventDateRange] cannot express (anniversary, icon gate).
  ///
  /// Window matches the 2026 dates so a cold start behaves correctly even
  /// if Firebase is unreachable on first launch.
  static final SaudiNationalDayRemoteConfig bundledDefault = SaudiNationalDayRemoteConfig(
    enabled: true,
    startDate: DateTime(2026, 9, 22),
    endDate: DateTime(2026, 9, 24, 23, 59, 59),
    anniversary: 96,
    appIconEnabled: true,
  );

  /// Whether [now] falls inside the activation window.
  ///
  /// Returns `false` outright when [enabled] is off, so the theme can be
  /// killed from the Console without having to move the dates.
  bool isActiveAt(DateTime now) {
    if (!enabled) {
      return false;
    }
    return !now.isBefore(startDate) && !now.isAfter(endDate);
  }

  /// Whether the launcher icon should be swapped at [now].
  ///
  /// Requires both the theme window and the separate icon gate.
  bool isAppIconActiveAt(DateTime now) => appIconEnabled && isActiveAt(now);

  /// Last config resolved by `saudiNationalDayResolvedConfigProvider`.
  ///
  /// Mirrors the provider so the many `build()`-time colour and icon
  /// switches across the widget tree can stay synchronous without each
  /// taking a `WidgetRef`. Written only by that provider.
  static SaudiNationalDayRemoteConfig? _resolved;

  /// Publishes the resolved config for [isNowActive].
  static void publishResolved(SaudiNationalDayRemoteConfig config) {
    _resolved = config;
  }

  /// Whether the National Day theme is active right now.
  ///
  /// Falls back to [bundledDefault] until the provider first builds.
  static bool isNowActive() {
    final config = _resolved ?? bundledDefault;
    return config.isActiveAt(DateTime.now());
  }

  /// Whether the launcher icon should currently show the National Day
  /// variant. Used by the startup icon swap, which runs outside the
  /// provider graph.
  static bool isAppIconActiveNow() {
    final config = _resolved ?? bundledDefault;
    return config.isAppIconActiveAt(DateTime.now());
  }

  @override
  String toString() =>
      'SaudiNationalDayRemoteConfig(enabled: $enabled, start: $startDate, '
      'end: $endDate, anniversary: $anniversary, appIcon: $appIconEnabled)';
}
