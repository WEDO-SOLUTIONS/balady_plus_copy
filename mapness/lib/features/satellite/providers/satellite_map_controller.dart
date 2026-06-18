import 'package:dgis_map/library.dart';
import 'package:mapness/features/satellite/models/satellite_config.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/utils/app_config_loader.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'satellite_map_controller.g.dart';

// keepAlive: native SatelliteHandler holds the raster source for the whole
// session. If the provider auto-disposed when the layers sheet closes, the
// Dart bool would reset to false while the native layer stays visible — and
// on reopen the UI would show Default as selected even though the satellite
// tiles are still rendering on the map.
@Riverpod(keepAlive: true)
class SatelliteMapController extends _$SatelliteMapController {
  @override
  bool build() => false;

  Future<void> toggle() async {
    await _setEnabled(!state);
  }

  Future<void> enable() async {
    if (state) {
      return;
    }
    await _setEnabled(true);
  }

  Future<void> disable() async {
    if (!state) {
      return;
    }
    await _setEnabled(false);
  }

  Future<void> _setEnabled(bool enable) async {
    if (enable) {
      final snapshot = await AppConfigLoader.getSatelliteConfigSnapshot();
      final raw = snapshot.raw.isEmpty ? kSatelliteConfigBundledDefault : snapshot.raw;
      final config = SatelliteConfig.tryParse(raw);
      if (config == null || !config.isUsable) {
        logger.log(
          'satellite: remote config missing or invalid — skipping enable',
          logLevel: MapnessLogLevel.warning,
        );
        return;
      }
      // TEMP debug — surface the raw FRC value and its source flag so we
      // can confirm Firebase Console is actually overriding the bundled
      // default. Remove once FRC integration is confirmed working in prod.
      logger.log(
        'satellite FRC raw: source=${snapshot.source.name} '
        'length=${snapshot.raw.length} payload=${snapshot.raw}',
        logLevel: MapnessLogLevel.info,
      );
      if (config.isExpired) {
        logger.log(
          'satellite: ESRI token expired at ${config.expiresAt?.toIso8601String()} — '
          'tiles will likely fail; rotate satellite_config in Firebase Remote Config',
          logLevel: MapnessLogLevel.warning,
        );
      }
      await _applyToNative(
        enabled: true,
        layerName: config.layerName,
        tileUri: config.resolvedTileUri,
      );
    } else {
      await _applyToNative(enabled: false);
    }
  }

  Future<void> _applyToNative({
    required bool enabled,
    String layerName = '',
    String tileUri = '',
  }) async {
    final controller = ref.read(dgisControllerProvider).value;
    final result = await controller?.toggleSatellite(
      message: SatelliteMapMessage(
        layerName: layerName,
        rasterTileUri: tileUri,
        enabled: enabled,
      ),
    );
    if (!ref.mounted) {
      return;
    }
    state = result ?? enabled;
  }
}
