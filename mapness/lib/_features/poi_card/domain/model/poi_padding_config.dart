import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// Config file for settings  of tappable zone on the screen
/// Here we have [paddingOfCamera] which is the padding from the edges of the screen
/// and [sizeOfScreen] which is the size of the screen
@immutable
class PoiPaddingConfig {
  /// Padding from the edges of the screen to the tappable zone
  final EdgeInsets? paddingOfCamera;

  /// Size of the screen. Could be taken as `MediaQuery.of(context).size`
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
