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
  defaultMap,
  satellite;
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

  /// Base-map options — shown as the first row of "All layers" tab.
  /// The grid renders them in a 3-column row, so the third cell stays empty.
  static List<LayerType> get baseMaps => [LayerType.defaultMap, LayerType.satellite];

  /// Overlay layers — shown after the base-maps row in the "All layers" tab.
  /// Order mirrors the Figma macet (Traffic, Parking, Metro, Bus, Favorites).
  static List<LayerType> get overlays => [
    LayerType.traffic,
    LayerType.parkingLots,
    LayerType.metro,
    LayerType.busSubMenu,
    LayerType.favourites,
  ];

  /// All layers, flat list. Kept for callers that still consume the original
  /// v1 layout. Internally composed from [baseMaps] + [overlays] so the two
  /// stay in sync.
  static List<LayerType> get v1 => [...baseMaps, ...overlays];

  /// Subset shown under the "Map details" filter tab.
  static List<LayerType> get mapDetails => [LayerType.traffic, LayerType.parkingLots, LayerType.favourites];

  /// Subset shown under the "Public transport" filter tab.
  static List<LayerType> get publicTransport => [LayerType.metro, LayerType.busSubMenu];

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
    'defaultMap' => LayerType.defaultMap,
    'satellite' => LayerType.satellite,
    _ => null,
  };
}
