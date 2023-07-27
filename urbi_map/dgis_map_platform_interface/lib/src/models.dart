import 'package:dgis_map_platform_interface/library.dart';

/// Model corresponds render object on map
class Marker {
  /// Base class constructor
  const Marker({
    required this.id,
    required this.options,
    this.onTap,
  });

  /// Map render object's id
  final int id;

  /// Map render object's options (such as position, color, anchor and etc)
  final MarkerOptionsMessage options;

  /// Map render object's onTap handler
  final void Function()? onTap;
}

/// Model corresponds render object on map
class Polygon {
  /// Base class constructor
  const Polygon({
    required this.id,
    required this.options,
    this.onTap,
  });

  /// Map render object's id
  final int id;

  /// Map render object's options (such as position, color, anchor and etc)
  final PolygonOptionsMessage options;

  /// Map render object's onTap handler
  final void Function()? onTap;
}

/// Model corresponds render object on map
class Polyline {
  /// Base class constructor
  const Polyline({
    required this.id,
    required this.options,
    this.onTap,
  });

  /// Map render object's id
  final int id;

  /// Map render object's options (such as position, color, anchor and etc)
  final PolylineOptionsMessage options;

  /// Map render object's onTap handler
  final void Function()? onTap;
}
