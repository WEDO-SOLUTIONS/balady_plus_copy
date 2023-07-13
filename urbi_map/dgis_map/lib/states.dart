import 'dgis_map_controller.dart';

class LayerState {
  LayerState({
    required this.layer,
    required this.isSearchActive,
  });

  factory LayerState.initial() => LayerState(
    layer: BusinessLayers.tourism,
    isSearchActive: true,
  );

  final bool isSearchActive;
  final BusinessLayers layer;
}
