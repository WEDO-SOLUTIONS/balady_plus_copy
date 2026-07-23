enum LayerType {
  favourites,
  invest,
  buildings,
  parkingLots,
  metro,
  busSubMenu,
  makkahBus,
  shuttleBus,
  jeddahBus,
  fencing,
  traffic,
  three3D,
  friends;
  // roadEvents;

  static List<LayerType> get lifestyle => [
    LayerType.favourites,
    LayerType.parkingLots,
    LayerType.metro,
    LayerType.makkahBus,
    LayerType.shuttleBus,
    LayerType.jeddahBus,
  ];

  static List<LayerType> get business => [
    LayerType.invest,
    LayerType.buildings,
    LayerType.fencing,
  ];

  static List<LayerType> get v1 => [
    LayerType.traffic,
    LayerType.metro,
    LayerType.parkingLots,
    LayerType.busSubMenu,
    // LayerType.roadEvents,
    LayerType.favourites,
    LayerType.friends,
  ];

  static List<LayerType> get bus => [
    LayerType.makkahBus,
    LayerType.shuttleBus,
    LayerType.jeddahBus,
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
    'jeddahBus' => LayerType.jeddahBus,
    'traffic' => LayerType.traffic,
    'three3D' => LayerType.three3D,
    'friends' => LayerType.friends,
    _ => null,
  };
}
