/// Operating mode of the Balady analytics facade — the "рубильник" between the
/// legacy third-party analytics stack and our own self-hosted pipeline.
///
/// Read per-flavor from `.env.<flavor>` (`BALADY_ANALYTICS_MODE`), resolved
/// once at startup via [BaladyAnalyticsMode.parse]. Compile-time by design:
/// changing the mode requires a new build, not a remote toggle.
enum BaladyAnalyticsMode {
  /// Only the legacy streams keep working; events routed to the facade are
  /// dropped. Safe default for production until our backend is battle-tested.
  legacy,

  /// Both branches run in parallel: legacy streams stay untouched AND every
  /// facade event goes to our own pipeline. The migration mode.
  dual,

  /// Our pipeline only. Once legacy streams are routed through the facade,
  /// this mode will silence them; today it behaves like [dual] because the
  /// legacy streams are still called directly from feature code.
  ours;

  static BaladyAnalyticsMode parse(
    String? raw, {
    BaladyAnalyticsMode fallback = BaladyAnalyticsMode.legacy,
  }) {
    switch (raw?.trim().toLowerCase()) {
      case 'legacy':
        return BaladyAnalyticsMode.legacy;
      case 'dual':
        return BaladyAnalyticsMode.dual;
      case 'ours':
        return BaladyAnalyticsMode.ours;
      default:
        return fallback;
    }
  }

  /// Whether events routed to the facade should reach our own sink.
  bool get sendToOurs => this != BaladyAnalyticsMode.legacy;
}
