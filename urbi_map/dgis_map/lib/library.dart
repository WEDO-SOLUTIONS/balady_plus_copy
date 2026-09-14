library;

import 'package:dgis_map_platform_interface/library.dart';

export 'package:dgis_map_platform_interface/library.dart';

export 'dgis_map.dart';

export 'dgis_map_controller.dart';

export 'navi/free_roam_controller.dart';

export 'navi/compass_controller.dart';

export 'navi/maneuver_controller.dart';

export 'navi/speed_controller.dart';

export 'navi/message_controller.dart';

export 'navi/traffic_parking_controller.dart';

export 'navi/zoom_controller.dart';

/// Initialize DGis plugin with options
Future<void> initialiseDGis({
  LogOptionsMessage? logOptions,
  VendorConfigMessage? config,
  VendorConfigContentMessage? configContent,
}) => PluginApi().initialize(logOptions, config, configContent);
