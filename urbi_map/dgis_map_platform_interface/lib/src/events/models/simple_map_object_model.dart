class SimpleMapObjectModel {
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

  const SimpleMapObjectModel({
    this.id,
    required this.isVisible,
    required this.zIndex,
    this.levelId,
    required this.bounds,
  });

  /// Если приходит Object? из платформ-канала
  factory SimpleMapObjectModel.fromAny(Object? any) => SimpleMapObjectModel.fromJson(_asMap(any));
  final String? id;
  final bool isVisible;
  final int zIndex;
  final LevelIdModel? levelId;
  final GeoRectModel bounds;

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

class LevelIdModel {
  const LevelIdModel({required this.value});

  factory LevelIdModel.fromJson(Map<String, dynamic> json) =>
      LevelIdModel(value: (json['value'] as num?)?.toInt() ?? 0);
  final int value;

  Map<String, dynamic> toJson() => {'value': value};
}

class GeoRectModel {
  const GeoRectModel({
    required this.southWest,
    required this.northEast,
    required this.isValid,
    required this.isDegenerate,
  });

  factory GeoRectModel.fromJson(Map<String, dynamic> json) => GeoRectModel(
        southWest: GeoPointModel.fromJson(_asMap(json['southWest'])),
        northEast: GeoPointModel.fromJson(_asMap(json['northEast'])),
        isValid: (json['isValid'] as bool?) ?? false,
        isDegenerate: (json['isDegenerate'] as bool?) ?? false,
      );
  final GeoPointModel southWest;
  final GeoPointModel northEast;
  final bool isValid;
  final bool isDegenerate;

  Map<String, dynamic> toJson() => {
        'southWest': southWest.toJson(),
        'northEast': northEast.toJson(),
        'isValid': isValid,
        'isDegenerate': isDegenerate,
      };
}

class GeoPointModel {
  const GeoPointModel({
    required this.latitude,
    required this.longitude,
    required this.isValid,
  });

  factory GeoPointModel.fromJson(Map<String, dynamic> json) => GeoPointModel(
        latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
        longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
        isValid: (json['isValid'] as bool?) ?? false,
      );
  final double latitude;
  final double longitude;
  final bool isValid;

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'isValid': isValid,
      };
}
