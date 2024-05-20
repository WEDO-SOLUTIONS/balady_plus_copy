import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

@immutable
class PoiPaddingConfig {
  /// Padding for camera if we want to control where the point will be
  final EdgeInsets? paddingOfCamera;

  final Size? sizeOfScreen;

  /// Constructor
  const PoiPaddingConfig({
    this.paddingOfCamera,
    this.sizeOfScreen,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is PoiPaddingConfig && other.paddingOfCamera == paddingOfCamera && other.sizeOfScreen == sizeOfScreen;
  }

  @override
  int get hashCode => paddingOfCamera.hashCode ^ sizeOfScreen.hashCode;
}
