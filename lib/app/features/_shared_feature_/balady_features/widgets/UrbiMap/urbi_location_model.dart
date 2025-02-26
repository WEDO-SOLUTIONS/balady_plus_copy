class UrbiLocationModel {
  UrbiLocationModel({
    this.fullName,
    this.id,
    this.name,
    this.point,
    this.subtype,
    this.type,});

  UrbiLocationModel.fromJson(dynamic json) {
    fullName = json['full_name'];
    id = json['id'];
    name = json['name'];
    point = json['point'] != null ? Point.fromJson(json['point']) : null;
    subtype = json['subtype'];
    type = json['type'];
  }
  String? fullName;
  String? id;
  String? name;
  Point? point;
  String? subtype;
  String? type;
  UrbiLocationModel copyWith({  String? fullName,
    String? id,
    String? name,
    Point? point,
    String? subtype,
    String? type,
  }) => UrbiLocationModel(  fullName: fullName ?? this.fullName,
    id: id ?? this.id,
    name: name ?? this.name,
    point: point ?? this.point,
    subtype: subtype ?? this.subtype,
    type: type ?? this.type,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['full_name'] = fullName;
    map['id'] = id;
    map['name'] = name;
    if (point != null) {
      map['point'] = point?.toJson();
    }
    map['subtype'] = subtype;
    map['type'] = type;
    return map;
  }

}

class Point {
  Point({
    this.lat,
    this.lon,});

  Point.fromJson(dynamic json) {
    lat = json['lat'];
    lon = json['lon'];
  }
  double? lat;
  double? lon;
  Point copyWith({  double? lat,
    double? lon,
  }) => Point(  lat: lat ?? this.lat,
    lon: lon ?? this.lon,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['lat'] = lat;
    map['lon'] = lon;
    return map;
  }

}