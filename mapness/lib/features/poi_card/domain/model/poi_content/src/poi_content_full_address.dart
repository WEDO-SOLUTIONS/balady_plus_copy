/// Model for full address content. It is used in the address card
class PoiContentFullAddressModel {
  /// Title of the card
  final String title;

  /// Address of the object
  final String fullAddress;

  /// Floors of the object
  final PoiContentFloorModel? floors;

  /// Entrances of the object
  final PoiContentEntrancesModel? entrances;

  /// Network logo url. Now we do not use it, but we keep it for future use
  /// We are not sure that it will be used in the future, so if we do not use it for a long time, feel free to remove it
  final String? networkLogoUrl;

  const PoiContentFullAddressModel({
    required this.title,
    required this.fullAddress,
    this.floors,
    this.entrances,
    this.networkLogoUrl,
  });
}

/// Model for floor content. It is used in the address card
class PoiContentFloorModel {
  /// Title for the floor button
  final String title;

  /// Count of floors
  final int floors;

  const PoiContentFloorModel({
    required this.title,
    required this.floors,
  });
}

/// Model for entrances content. It is used in the address card
class PoiContentEntrancesModel {
  /// Title for the entrances button
  final String title;

  /// Count of entrances
  final int count;

  /// Callback for the entrances button
  final void Function() onTap;

  const PoiContentEntrancesModel({
    required this.title,
    required this.count,
    required this.onTap,
  });
}
