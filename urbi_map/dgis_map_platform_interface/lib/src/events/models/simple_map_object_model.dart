/// A map object as the native side describes it over the platform channel:
/// enough to identify it, place it and know whether it is drawn.
class SimpleMapObjectModel {
  /// Reads the object out of its channel payload, filling in defaults for
  /// anything the native side left out.
  factory SimpleMapObjectModel.fromJson(Map<String, dynamic> json) {
    final levelIdMap = _asMap(json['levelId']); // _Map<Object?, Object?> -> Map<String, dynamic>
    final boundsMap = _asMap(json['bounds']);

    return SimpleMapObjectModel(
      id: json['id'] as String?,
      isVisible: (json['isVisible'] is bool) ? json['isVisible'] as bool : true,
      zIndex: (json['zIndex'] is num) ? (json['zIndex'] as num).toInt() : 0,
      levelId: levelIdMap.isEmpty ? null : LevelIdModel.fromJson(levelIdMap),
      bounds: GeoRectModel.fromJson(boundsMap),
    );
  }

  /// Creates the model directly.
  const SimpleMapObjectModel({
    this.id,
    required this.isVisible,
    required this.zIndex,
    this.levelId,
    required this.bounds,
  });

  /// Если приходит Object? из платформ-канала
  /// Reads the object out of an untyped channel value.
  factory SimpleMapObjectModel.fromAny(Object? any) => SimpleMapObjectModel.fromJson(_asMap(any));

  /// Identifier the native side knows the object by, when it has one.
  final String? id;

  /// Whether the object is currently drawn on the map.
  final bool isVisible;

  /// Draw order against other objects; higher sits on top.
  final int zIndex;

  /// Indoor floor the object belongs to, or null when it is outdoors.
  final LevelIdModel? levelId;

  /// Rectangle the object occupies on the map.
  final GeoRectModel bounds;

  /// The payload shape this model is read back from.
  Map<String, dynamic> toJson() => {
    'id': id,
    'isVisible': isVisible,
    'zIndex': zIndex,
    'levelId': levelId?.toJson(),
    'bounds': bounds.toJson(),
  };
}

// ---------- helpers ----------

Map<String, dynamic> _asMap(Object? v) {
  if (v is Map) return v.cast<String, dynamic>();
  return <String, dynamic>{};
}

/// Identifies one floor of an indoor plan.
class LevelIdModel {
  /// Creates the floor identifier.
  const LevelIdModel({required this.value});

  /// Reads the floor identifier out of its channel payload.
  factory LevelIdModel.fromJson(Map<String, dynamic> json) =>
      LevelIdModel(value: (json['value'] as num?)?.toInt() ?? 0);

  /// The floor number as the map SDK numbers them.
  final int value;

  /// The payload shape this model is read back from.
  Map<String, dynamic> toJson() => {'value': value};
}

/// A geographic rectangle, given by two opposite corners.
class GeoRectModel {
  /// Creates the rectangle.
  const GeoRectModel({
    required this.southWest,
    required this.northEast,
    required this.isValid,
    required this.isDegenerate,
  });

  /// Reads the rectangle out of its channel payload.
  factory GeoRectModel.fromJson(Map<String, dynamic> json) => GeoRectModel(
    southWest: GeoPointModel.fromJson(_asMap(json['southWest'])),
    northEast: GeoPointModel.fromJson(_asMap(json['northEast'])),
    isValid: (json['isValid'] as bool?) ?? false,
    isDegenerate: (json['isDegenerate'] as bool?) ?? false,
  );

  /// South-west corner.
  final GeoPointModel southWest;

  /// North-east corner.
  final GeoPointModel northEast;

  /// Whether the SDK considers the rectangle usable.
  final bool isValid;

  /// Whether the rectangle collapsed to a point or a line.
  final bool isDegenerate;

  /// The payload shape this model is read back from.
  Map<String, dynamic> toJson() => {
    'southWest': southWest.toJson(),
    'northEast': northEast.toJson(),
    'isValid': isValid,
    'isDegenerate': isDegenerate,
  };
}

/// A single point on the map, as the channel reports it.
class GeoPointModel {
  /// Creates the point.
  const GeoPointModel({required this.latitude, required this.longitude, required this.isValid});

  /// Reads the point out of its channel payload.
  factory GeoPointModel.fromJson(Map<String, dynamic> json) => GeoPointModel(
    latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
    longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
    isValid: (json['isValid'] as bool?) ?? false,
  );

  /// Degrees north of the equator.
  final double latitude;

  /// Degrees east of the prime meridian.
  final double longitude;

  /// Whether the SDK considers the coordinates usable.
  final bool isValid;

  /// The payload shape this model is read back from.
  Map<String, dynamic> toJson() => {'latitude': latitude, 'longitude': longitude, 'isValid': isValid};
}
