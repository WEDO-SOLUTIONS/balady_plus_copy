import 'package:mapness/shared/utils/app_config_loader.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'base_map_switcher_enabled.g.dart';

/// BALADY-3754: gates the Default/Satellite base-map tiles in the layers
/// sheet. Reads the `base_map_switcher_enabled` Firebase Remote Config flag;
/// hidden by default until the satellite tile source is production-ready.
/// keepAlive — the flag is fetched once per session, no reason to re-read it
/// every time the sheet closes.
@Riverpod(keepAlive: true)
Future<bool> baseMapSwitcherEnabled(Ref ref) => AppConfigLoader.isBaseMapSwitcherEnabled();
