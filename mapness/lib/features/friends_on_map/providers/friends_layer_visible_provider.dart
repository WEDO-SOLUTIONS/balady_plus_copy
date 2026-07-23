import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'friends_layer_visible_provider.g.dart';

// keepAlive: this is a pure Dart-side toggle (no native attribute backs it),
// so closing the layers sheet must not reset it — same rationale as
// SatelliteMapController/metroLayerVisibleProvider.
@Riverpod(keepAlive: true)
class FriendsLayerVisible extends _$FriendsLayerVisible {
  @override
  bool build() => false;

  void toggle() => state = !state;
}
