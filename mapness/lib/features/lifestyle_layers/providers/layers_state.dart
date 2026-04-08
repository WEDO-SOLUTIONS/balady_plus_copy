enum LayerType {
  favourites,
  invest,
  buildings,
  parkingLots,
  metro,
  makkahBus,
  shuttleBus,
  fencing;

  static List<LayerType> get lifestyle => [
    LayerType.favourites,
    LayerType.parkingLots,
    LayerType.metro,
    LayerType.makkahBus,
    LayerType.shuttleBus,
  ];

  static List<LayerType> get business => [
        LayerType.invest,
        LayerType.buildings,
        LayerType.fencing,
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
    'makkahBus' => LayerType.makkahBus,
    'shuttleBus' => LayerType.shuttleBus,
    _ => null,
  };
}
