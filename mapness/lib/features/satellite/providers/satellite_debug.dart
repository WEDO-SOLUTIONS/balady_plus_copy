import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'satellite_debug.g.dart';

/// Dev-only stand-in JSON used by [SatelliteMapController] when
/// [SatelliteDebugOverride] is on. Points at the staging satellite proxy
/// (`urbi-lifestyle-stg`), which forwards to Saudi Geoportal from a
/// KSA-network endpoint — so QA/devs outside KSA see real tiles instead
/// of the WAF rejection HTML that crashes the DGis iOS render thread.
///
/// Token-less because the proxy injects the ESRI token server-side.
/// Staging URL — must NEVER ship to prod, accessible only via debug panel.
const String kSatelliteDebugOverrideConfig =
    '{"layer_name":"satellite",'
    '"url_template":"https://urbi-lifestyle-stg.momah.gov.sa/satproxy/tiles/{z}/{y}/{x}",'
    '"token":"",'
    '"expires":0}';

/// Debug-panel toggle: when enabled, the satellite controller ignores the
/// Firebase Remote Config snapshot for `satellite_config` and uses the
/// bundled staging-proxy URL. Resets to off on each app launch (no
/// persistence — keepAlive only survives the session).
@Riverpod(keepAlive: true)
class SatelliteDebugOverride extends _$SatelliteDebugOverride {
  @override
  bool build() => false;

  void toggle() => state = !state;

  void enable() => state = true;

  void disable() => state = false;
}
