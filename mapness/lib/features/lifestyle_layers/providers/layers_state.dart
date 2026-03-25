enum LayerType {
  favourites,
  invest,
  buildings,
  parkingLots,
  metro,
  fencing,
  traffic,
  three3D,
  roadEvents;

  static List<LayerType> get lifestyle => [
    LayerType.favourites,
    LayerType.parkingLots,
    LayerType.metro,
  ];

  static List<LayerType> get business => [
    LayerType.invest,
    LayerType.buildings,
    LayerType.fencing,
  ];

  static List<LayerType> get v1 => [
    LayerType.traffic,
    LayerType.metro,
    LayerType.three3D,
    LayerType.parkingLots,
    LayerType.roadEvents,
    LayerType.favourites,
  ];
}

extension LayerTypeEx on LayerType {
  static LayerType? stringToType(String? str) => switch (str) {
    'favourites' => LayerType.favourites,
    'invest' => LayerType.invest,
    'buildings' => LayerType.buildings,
    'parkingLots' => LayerType.parkingLots,
    'fencing' => LayerType.fencing,
    'metro' => LayerType.metro,
    'traffic' => LayerType.traffic,
    'three3D' => LayerType.three3D,
    _ => null,
  };
}
