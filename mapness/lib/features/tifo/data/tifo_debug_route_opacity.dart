import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// How opaque each tier of the TIFO capture layer is painted WHILE a route is
/// being driven, as a percentage (0 = invisible, 100 = the tier's normal
/// colour). The layer draws over the basemap, so at full colour it buries the
/// route line and the streets underneath — see `TifoBuildingsMapLayer`.
///
/// Exposed as raw percentages in the debug panel rather than hardcoded: the
/// numbers below are the product defaults, and QA dials them in per device
/// (the same alpha reads very differently on a dark vs light basemap) and
/// reports back which values keep the team colours legible without hiding the
/// route. Debug-only state: it isn't persisted, so a relaunch is back on the
/// defaults.
@immutable
class TifoRouteOpacity {
  const TifoRouteOpacity({
    this.buildings = defaultBuildings,
    this.districts = defaultDistricts,
    this.cluster = defaultCluster,
  });

  /// Product defaults: buildings keep most of their colour, while the two
  /// zoomed-out tiers — which cover far more of the screen per polygon — drop
  /// to a faint tint so the route stays readable through them.
  static const int defaultBuildings = 50;
  static const int defaultDistricts = 10;
  static const int defaultCluster = 20;

  /// Street-level capture polygons — the buildings tier, whose zoom threshold
  /// is itself a debug knob (`TifoLodZoomThresholds`), so it is not spelled
  /// out as a number here.
  final int buildings;

  /// The district mosaic (mid zooms).
  final int districts;

  /// The single region silhouette at the clustered far-out zoom.
  final int cluster;

  int get buildingsAlpha => alphaOf(buildings);

  int get districtsAlpha => alphaOf(districts);

  int get clusterAlpha => alphaOf(cluster);

  /// Percentage → the alpha byte in place, ready to be OR-ed onto an RGB
  /// value (`0x26000000` for 15%).
  static int alphaOf(int percent) => (percent.clamp(0, 100) * 255 ~/ 100) << 24;

  TifoRouteOpacity copyWith({int? buildings, int? districts, int? cluster}) => TifoRouteOpacity(
    buildings: buildings ?? this.buildings,
    districts: districts ?? this.districts,
    cluster: cluster ?? this.cluster,
  );
}

class TifoDebugRouteOpacityController extends Notifier<TifoRouteOpacity> {
  @override
  TifoRouteOpacity build() => const TifoRouteOpacity();

  void setBuildings(int percent) => state = state.copyWith(buildings: percent);

  void setDistricts(int percent) => state = state.copyWith(districts: percent);

  void setCluster(int percent) => state = state.copyWith(cluster: percent);

  void reset() => state = const TifoRouteOpacity();
}

final tifoDebugRouteOpacityProvider = NotifierProvider<TifoDebugRouteOpacityController, TifoRouteOpacity>(
  TifoDebugRouteOpacityController.new,
);
