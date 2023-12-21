import 'package:dgis_map/library.dart';

// todo: move to entities
class LayersState {
  final bool layersVisible;
  final LayerType? selectedType;
  final bool isLoading;

  LayersState({
    required this.isLoading,
    required this.layersVisible,
    required this.selectedType,
  });

  LayersState copyWith({
    bool? layersVisible,
    LayerType? selectedType,
    bool? isLoading,
  }) {
    return LayersState(
      isLoading: isLoading ?? this.isLoading,
      layersVisible: layersVisible ?? this.layersVisible,
      selectedType: selectedType ?? this.selectedType,
    );
  }
}

enum LayerType {
  // favourites,
  invest,
  buildings,
  fencing,
  joy,
}
