

class TripStations {

  int? id;
  String? name;
  dynamic categoryId;
  dynamic categoryKey;
  dynamic categoryName;
  int? typeId;
  String? typeName;
  int? cityId;
  String? cityName;
  dynamic date;
  dynamic time;
  Location? location;
  dynamic dateTime;
  TripStations({
      this.id, 
      this.name, 
      this.categoryId, 
      this.categoryKey, 
      this.categoryName, 
      this.typeId, 
      this.typeName, 
      this.cityId, 
      this.cityName, 
      this.date, 
      this.time, 
      this.location, 
      this.dateTime,});

  TripStations.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    categoryId = json['categoryId'];
    categoryKey = json['categoryKey'];
    categoryName = json['categoryName'];
    typeId = json['typeId'];
    typeName = json['typeName'];
    cityId = json['cityId'];
    cityName = json['cityName'];
    date = json['date'];
    time = json['time'];
    location = json['location'] != null ? Location.fromJson(json['location']) : null;
    dateTime = json['dateTime'];
  }



  TripStations copyWith(
      {

        final int? id,
        final String? name,
        final dynamic categoryId,
        final dynamic categoryKey,
        final  dynamic categoryName,
        final int? typeId,
        final  String? typeName,
        final int? cityId,
        final  String? cityName,
        final dynamic date,
        final dynamic time,
        final Location? location,
        final dynamic dateTime,




}) {
    return TripStations(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      categoryKey: categoryKey ?? this.categoryKey,
      categoryName: categoryName ?? this.categoryName,
      typeId: typeId ?? this.typeId,
      typeName: typeName ?? this.typeName,
      cityId: cityId ?? this.cityId,
      cityName: cityName ?? this.cityName,
      date: date ?? this.date,
      time: time ?? this.time,
      location: location ?? this.location,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  @override
  List<Object?> get props => [
   id,
 name,
    categoryId,
    categoryKey,
    categoryName,
    typeId,
   typeName,
    cityId,
    cityName,
   date,
    time,
  location,
    dateTime

  ];

}

class Location {
  Location({
      this.x, 
      this.y,});

  Location.fromJson(dynamic json) {
    x = json['x'];
    y = json['y'];
  }
  String? x;
  String? y;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['x'] = x;
    map['y'] = y;
    return map;
  }

}