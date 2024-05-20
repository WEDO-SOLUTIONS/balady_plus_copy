import 'dart:math' as math;
import 'package:flutter/material.dart';

const _collapsedHeight = 300.0;
const _hiddenHeight = 100.0;

@immutable
class PoiSheetSizes {
  final double collapsedHeight;
  final double hiddenHeight;
  final double middleHeight;
  final double expandedHeight;

  const PoiSheetSizes._({
    required this.middleHeight,
    required this.expandedHeight,
    required this.collapsedHeight,
    required this.hiddenHeight,
  });

  factory PoiSheetSizes.fromScreenSize({
    required Size sizeOfScreen,
  }) {
    /// The middle height should be higher than the collapsed height
    /// if [availableExpansions] contains [Expansion.middle] and [Expansion.collapsed]
    final middleHeight = math.max(sizeOfScreen.height / 3.2, _collapsedHeight + 1);

    /// This number was taken at random.
    final expandedHeight = sizeOfScreen.height / 2;

    return PoiSheetSizes._(
      middleHeight: middleHeight,
      expandedHeight: expandedHeight,
      collapsedHeight: _collapsedHeight,
      hiddenHeight: _hiddenHeight,
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
    return middleHeight == _other.middleHeight && expandedHeight == _other.expandedHeight;
  }

  @override
  int get hashCode => middleHeight.hashCode ^ expandedHeight.hashCode;
}
