class NotificationRequest {
  NotificationRequest({this.device, this.appId, this.appVersion, this.fcmToken, this.fCMTokenSource});

  Device? device;
  String? appId;
  String? appVersion;
  String? fcmToken;
  String? fCMTokenSource;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (device != null) {
      map['device'] = device?.toJson();
    }
    map['appId'] = appId;
    map['appVersion'] = appVersion;
    map['fcmToken'] = fcmToken;
    map['appNotificationsChannel'] = fCMTokenSource;
    return map;
  }
}

class Device {
  Device({this.id, this.typeId, this.osTypeId, this.isRooted, this.ip, this.location, this.metaData});

  Device.fromJson(dynamic json) {
    id = json['id'];
    typeId = json['typeId'];
    osTypeId = json['osTypeId'];
    isRooted = json['isRooted'];
    ip = json['ip'];
    location = json['location'] != null ? Location.fromJson(json['location']) : null;
    metaData = json['metaData'] != null ? MetaData.fromJson(json['metaData']) : null;
  }
  String? id;
  String? typeId;
  String? osTypeId;
  bool? isRooted;
  String? ip;
  Location? location;
  MetaData? metaData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['typeId'] = typeId;
    map['osTypeId'] = osTypeId;
    map['isRooted'] = isRooted;
    map['ip'] = ip;
    if (location != null) {
      map['location'] = location?.toJson();
    }
    if (metaData != null) {
      map['metaData'] = metaData?.toJson();
    }
    return map;
  }
}

class MetaData {
  MetaData({this.additionalProp1, this.additionalProp2, this.additionalProp3});

  MetaData.fromJson(dynamic json) {
    additionalProp1 = json['additionalProp1'];
    additionalProp2 = json['additionalProp2'];
    additionalProp3 = json['additionalProp3'];
  }
  String? additionalProp1;
  String? additionalProp2;
  String? additionalProp3;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['additionalProp1'] = additionalProp1;
    map['additionalProp2'] = additionalProp2;
    map['additionalProp3'] = additionalProp3;
    return map;
  }
}

class Location {
  Location({this.latitude, this.longitude});

  Location.fromJson(dynamic json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }
  int? latitude;
  int? longitude;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    return map;
  }
}
