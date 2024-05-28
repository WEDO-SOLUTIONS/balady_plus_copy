import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Config file for settings of the POI sheet sizes
/// Sheet have several sizes and controlled by [Expansion] enum
@immutable
class PoiSheetSizes {
  final double hiddenHeight;
  final double collapsedHeight;
  final double middleHeight;

  const PoiSheetSizes._({
    required this.middleHeight,
    required this.collapsedHeight,
    required this.hiddenHeight,
  });

  /// Factory constructor for the POI card
  factory PoiSheetSizes.poiCard({
    required Size sizeOfScreen,
  }) {
    // The collapsed height for POI card. Have been calculated
    const collapsedHeight = 210.0;

    /// The middle height should be higher than the collapsed height
    final middleHeight = math.max(sizeOfScreen.height / 3.2, collapsedHeight + 1);

    return PoiSheetSizes._(
      middleHeight: middleHeight,
      collapsedHeight: collapsedHeight,
      hiddenHeight: 130.0,
    );
  }

  /// Factory constructor for the My location card
  factory PoiSheetSizes.myLocation({
    required double bottomPadding,
  }) {
    /// The hidden height for My location card
    const hiddenHeight = 90.0;

    /// The collapsed height for My location card. Have been calculated for small sheet size
    const collapsedHeight = 100.0;

    /// Default middle height for My location card. Have been calculated and added safe area padding
    final middleHeight = 179 + bottomPadding;

    return PoiSheetSizes._(
      middleHeight: middleHeight,
      collapsedHeight: collapsedHeight,
      hiddenHeight: hiddenHeight,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! PoiSheetSizes) {
      return false;
    }
    final PoiSheetSizes _other = other;
    return middleHeight == _other.middleHeight &&
        collapsedHeight == _other.collapsedHeight &&
        hiddenHeight == _other.hiddenHeight;
  }

  @override
  int get hashCode => middleHeight.hashCode ^ collapsedHeight.hashCode ^ hiddenHeight.hashCode;
}
