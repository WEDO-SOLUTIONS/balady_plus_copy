enum LayerType {
  favourites,
  invest,
  buildings,
  parkingLots,
  metro,
  makkahBuses,
  fencing;

  static List<LayerType> get lifestyle => [
        LayerType.favourites,
        LayerType.parkingLots,
        LayerType.metro,
        LayerType.makkahBuses,
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
        'makkahBuses' => LayerType.makkahBuses,
        _ => null,
      };
}
