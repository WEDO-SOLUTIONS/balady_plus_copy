part of 'bss_payload.dart';

/// Information about the search results element of the Places tab (cards of branches, geographic objects and hybrids).
class BssPlaceItem {
  const BssPlaceItem({
    required this.entity,
    this.org,
    this.position,
    this.geoPosition,
    this.resultClass,
    this.contextRubric,
    this.adsSearch,
  });

  /// Description of the main card object
  final BssEntity entity;

  /// Organization (= company) identifier.
  final String? org;

  /// The ordinal number of the element in the list
  final int? position;

  /// Passed if geo coordinates are available for the object. In case of a hybrid object, the geo coordinates of the main object are passed.
  final BssGeoPosition? geoPosition;

  /// The class to which the object found via search is assigned. For objects not obtained via search, is not sent.
  final ResultClassEnum? resultClass;

  /// If the branch is found as discovery. Contains discovery- heading.
  final BssStringId? contextRubric;

  /// An advertising indicator determined by the search service by search parameters (how the branch was found) and the presence of advertising weight.
  /// — advertising -> true
  /// — NOT advertising -> false
  /// — absent -> the place was not found through a search
  final bool? adsSearch;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'entity': entity.toJson(),
    };
    if (org != null) {
      data['org'] = org;
    }
    if (position != null) {
      data['position'] = position;
    }
    if (geoPosition != null) {
      data['geoPosition'] = geoPosition!.toJson();
    }
    if (resultClass != null) {
      data['resultClass'] = resultClass!.name;
    }
    if (contextRubric != null) {
      data['contextRubric'] = contextRubric;
    }
    if (adsSearch != null) {
      data['adsSearch'] = adsSearch;
    }
    return data;
  }
}

class BssGeoPosition {
  const BssGeoPosition({
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
      };
}
