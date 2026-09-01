import 'dart:async';

import 'package:dgis_map_platform_interface/library.dart';

/// Model corresponds render object on map
class Marker {
  /// Base class constructor
  const Marker({required this.id, required this.options, this.onTap});

  /// Map render object's id
  final String id;

  /// Map render object's options (such as position, color, anchor and etc)
  final MarkerOptionsMessage options;

  /// Map render object's onTap handler
  final void Function()? onTap;
}

/// SVG marker icon
class SvgMarkerIcon extends MarkerIconMessage {
  /// SVG marker icon constructor
  SvgMarkerIcon({required super.svgPath, required super.width, super.iconOpacity, super.iconMapDirection});
}

/// PNG marker icon
class PngMarkerIcon extends MarkerIconMessage {
  /// PNG marker icon constructor
  PngMarkerIcon({required super.pngPath, required super.width, super.iconOpacity, super.iconMapDirection});
}

/// PNG marker icon from bytes
class PngBytesMarkerIcon extends MarkerIconMessage {
  /// PNG marker icon constructor
  PngBytesMarkerIcon({required super.pngData, required super.width, super.iconOpacity, super.iconMapDirection});
}

/// 3D model with fixed screen size in logical pixels.
class LogicalPixelModelSize extends ModelSizeMessage {
  /// Base constructor.
  LogicalPixelModelSize(double value) : super(value: value, type: ModelSizeTypeMessage.logicalPixel);
}

/// 3D model with size bound to map scale.
class ScaleModelSize extends ModelSizeMessage {
  /// Base constructor.
  ScaleModelSize(double value) : super(value: value, type: ModelSizeTypeMessage.scale);
}

/// Model corresponds 3D render object on map.
class ModelMapObject {
  /// Base class constructor.
  const ModelMapObject({required this.id, required this.options, this.onTap});

  /// Map render object's id.
  final String id;

  /// Map render object's options.
  final ModelMapObjectOptionsMessage options;

  /// Map render object's onTap handler.
  final void Function()? onTap;
}

/// Model corresponds render object on map
class SimpleClusterObject {
  /// Base class constructor
  SimpleClusterObject(
    this._api,
    this._id,
    this.position,
    this.objectCount,
    this.markers,
    this.anchor,
    this.iconOpacity,
    this.textStyle,
    this.iconWidth,
    this.iconMapDirection,
    this.text,
  );

  final String _id;
  final MapApi _api;

  /// Position of the object
  final GeoPointWithElevationMessage position;

  /// Number of objects in the cluster
  final int objectCount;

  /// List of markers in the cluster
  final List<SimpleMapObjectModel> markers;

  /// Anchor of the cluster
  final MarkerAnchorMessage anchor;

  /// Opacity of the cluster icon
  final double iconOpacity;

  /// Text of the cluster icon
  final String text;

  /// Text style of the cluster text
  final MarkerTextStyleMessage? textStyle;

  /// Width of the cluster icon
  final double iconWidth;

  /// Map direction of the cluster icon
  final MapDirectionMessage? iconMapDirection;

  /// Sets cluster icon. Should be called only inside onTap handler
  Future<void> setIcon(String icon) async {
    await _api.setClusterIcon(_id, icon);
  }
}

/// Model corresponds render object on map
class ClusteringMapObjectManager {
  /// Base class constructor
  const ClusteringMapObjectManager({required this.options, required this.renderCluster, this.onTap});

  /// Map render object's options (such as position, color, anchor and etc)
  final ClusteringMapObjectManagerOptionsMessage options;

  /// Map render object's onTap handler
  final SimpleClusterOptionsMessage Function(int objectCount) renderCluster;

  /// Map render object's onTap handler
  final Future<void> Function(SimpleClusterObject)? onTap;
}

/// Model corresponds render object on map
class Polygon {
  /// Base class constructor
  const Polygon({required this.id, required this.options, this.onTap});

  /// Map render object's id
  final String id;

  /// Map render object's options (such as position, color, anchor and etc)
  final PolygonOptionsMessage options;

  /// Map render object's onTap handler
  final void Function()? onTap;
}

/// Model corresponds render object on map
class Circle {
  /// Base class constructor
  const Circle({required this.id, required this.options, this.onTap});

  /// Map render object's id
  final String id;

  /// Map render object's options (such as position, color, anchor and etc)
  final CircleOptionsMessage options;

  /// Map render object's onTap handler
  final void Function()? onTap;
}

/// Model corresponds render object on map
class Polyline {
  /// Base class constructor
  const Polyline({required this.id, required this.options, this.onTap});

  /// Map render object's id
  final String id;

  /// Map render object's options (such as position, color, anchor and etc)
  final PolylineOptionsMessage options;

  /// Map render object's onTap handler
  final void Function()? onTap;
}
