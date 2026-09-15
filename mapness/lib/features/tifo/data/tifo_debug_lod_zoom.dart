import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Zoom thresholds the TIFO map layer picks its level of detail at
/// (`TifoBuildingsMapLayer._lodFor`), exposed as a debug knob so QA can move
/// the cluster/districts/buildings switch points live instead of needing a
/// build per experiment. The defaults reproduce the constants the layer used
/// to hardcode: cluster ≤ 11, districts 12–14, buildings ≥ 15.
///
/// The three tiers are ONE ordered axis, so there are only two free
/// boundaries: [buildingMinZoom] is always [districtMaxZoom] + [tierGap].
/// Every setter re-derives the whole triple through [_normalized], which is
/// what keeps the ranges disjoint and correctly ordered no matter which
/// slider is dragged — moving one boundary past a neighbour PUSHES that
/// neighbour instead of letting the two tiers overlap.
///
/// Units are `visibleRectEvent.zoom`, which reads ~1 lower than the camera's
/// own zoom on this map — see the layer's own note on that.
@immutable
class TifoLodZoomThresholds {
  const TifoLodZoomThresholds({this.clusterMaxZoom = 11, this.districtMaxZoom = 14});

  /// Cluster tier (one region silhouette) is drawn at `zoom <= this`.
  final double clusterMaxZoom;

  /// District mosaic is drawn at `clusterMaxZoom < zoom < buildingMinZoom`,
  /// i.e. this is the last zoom level that still shows districts.
  final double districtMaxZoom;

  /// Buildings are drawn at `zoom >= this`. Derived, never stored: the
  /// districts tier ends exactly where the buildings tier begins, so storing
  /// both would allow a zoom band that belongs to two tiers at once.
  double get buildingMinZoom => districtMaxZoom + tierGap;

  /// Lowest / highest zoom the sliders may hand out.
  static const double minZoom = 2;
  static const double maxZoom = 20;

  /// Minimum width of a tier, in zoom levels — also the gap kept between two
  /// neighbouring boundaries: a tier may never be squeezed to nothing by the
  /// tier next to it (buildings start at `districtMaxZoom + 1`, districts at
  /// `clusterMaxZoom + 1`).
  static const double tierGap = 1;

  /// Widest [clusterMaxZoom] that still leaves a districts tier and a
  /// buildings tier above it.
  static const double maxClusterMaxZoom = maxZoom - 2 * tierGap;

  /// Human-readable ranges for the debug UI.
  String get clusterRangeLabel => '≤ ${_fmt(clusterMaxZoom)}';

  String get districtRangeLabel => '${_fmt(clusterMaxZoom + tierGap)}–${_fmt(districtMaxZoom)}';

  String get buildingRangeLabel => '≥ ${_fmt(buildingMinZoom)}';

  static String _fmt(double zoom) => zoom == zoom.roundToDouble() ? zoom.toStringAsFixed(0) : zoom.toStringAsFixed(1);

  /// Clamps [cluster] and [district] into a valid, non-overlapping pair.
  /// [preferDistrict] decides who yields when the two collide: the slider the
  /// user is actually dragging keeps its value and the other one moves.
  static TifoLodZoomThresholds _normalized({
    required double cluster,
    required double district,
    required bool preferDistrict,
  }) {
    var newCluster = cluster.clamp(minZoom, maxClusterMaxZoom).toDouble();
    var newDistrict = district.clamp(minZoom + tierGap, maxZoom - tierGap).toDouble();
    if (newDistrict - newCluster < tierGap) {
      if (preferDistrict) {
        newCluster = math.max(minZoom, newDistrict - tierGap);
        // The district boundary itself may have been dragged below the floor
        // the cluster tier needs — push it back up in that case.
        newDistrict = math.max(newDistrict, newCluster + tierGap);
      } else {
        newDistrict = math.min(maxZoom - tierGap, newCluster + tierGap);
        newCluster = math.min(newCluster, newDistrict - tierGap);
      }
    }
    return TifoLodZoomThresholds(clusterMaxZoom: newCluster, districtMaxZoom: newDistrict);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TifoLodZoomThresholds &&
          other.clusterMaxZoom == clusterMaxZoom &&
          other.districtMaxZoom == districtMaxZoom;

  @override
  int get hashCode => Object.hash(clusterMaxZoom, districtMaxZoom);

  @override
  String toString() =>
      'TifoLodZoomThresholds(cluster $clusterRangeLabel, districts $districtRangeLabel, buildings $buildingRangeLabel)';
}

class TifoDebugLodZoomController extends Notifier<TifoLodZoomThresholds> {
  @override
  TifoLodZoomThresholds build() => const TifoLodZoomThresholds();

  /// Cluster slider: pushes the districts boundary UP when it would be
  /// swallowed, so districts keep at least [TifoLodZoomThresholds.tierGap].
  void setClusterMaxZoom(double value) {
    state = TifoLodZoomThresholds._normalized(
      cluster: value,
      district: state.districtMaxZoom,
      preferDistrict: false,
    );
  }

  /// Districts slider: pushes the cluster boundary DOWN when they collide.
  void setDistrictMaxZoom(double value) {
    state = TifoLodZoomThresholds._normalized(
      cluster: state.clusterMaxZoom,
      district: value,
      preferDistrict: true,
    );
  }

  /// Buildings slider. Buildings start exactly one level above the last
  /// district level, so this is the districts boundary seen from the other
  /// side — dragging it down walks the cluster boundary down with it.
  void setBuildingMinZoom(double value) => setDistrictMaxZoom(value - TifoLodZoomThresholds.tierGap);

  void reset() => state = const TifoLodZoomThresholds();
}

final tifoDebugLodZoomProvider = NotifierProvider<TifoDebugLodZoomController, TifoLodZoomThresholds>(
  TifoDebugLodZoomController.new,
);
