// todo: move to entities
class LayersState {

  LayersState({
    required this.isLoading,
    required this.layersVisible,
    required this.selectedType,
  });
  final bool layersVisible;
  final LayerType? selectedType;
  final bool isLoading;

  LayersState copyWith({
    bool? layersVisible,
    LayerType? selectedType,
    bool? isLoading,
  }) =>
      LayersState(
        isLoading: isLoading ?? this.isLoading,
        layersVisible: layersVisible ?? this.layersVisible,
        selectedType: selectedType ?? this.selectedType,
      );
}

enum LayerType {
  favourites,
  invest,
  buildings,
  fencing,
  joy,
}

extension LayerTypeEx on LayerType {
  static LayerType? stringToType(String? str) => switch (str) {
        'favourites' => LayerType.favourites,
        'invest' => LayerType.invest,
        'buildings' => LayerType.buildings,
        'fencing' => LayerType.fencing,
        'joy' => LayerType.joy,
        _ => null,
      };
}
