
class TransportInfo {
  TransportInfo({
    this.needSpecialTransport,
    this.transportCaseId,
    this.transportCaseName,
    this.transportCaseKey,
    this.charityId,
    this.charityName,
    this.vehicleId,
    this.vehicleName,
    this.driverIdentityNumber,
    this.driverName,
    this.driverMobile,
    this.mosqueId,
    this.mosqueName,
    this.ghuslPlaceId,
    this.ghuslPlaceName,
  this.assignDriverDate});

  TransportInfo.fromJson(dynamic json) {
    needSpecialTransport = json['needSpecialTransport'];
    transportCaseId = json['transportCaseId'];
    transportCaseName = json['transportCaseName'];
    transportCaseKey = json['transportCaseKey'];
    charityId = json['charityId'];
    charityName = json['charityName'];
    vehicleId = json['vehicleId'];
    vehicleName = json['vehicleName'];
    driverIdentityNumber = json['driverIdentityNumber'];
    driverName = json['driverName'];
    driverMobile = json['driverMobile'];
    mosqueId = json['mosqueId'];
    mosqueName = json['mosqueName'];
    ghuslPlaceId = json['ghuslPlaceId'];
    ghuslPlaceName = json['ghuslPlaceName'];
    assignDriverDate = json['assignDriverDate'];

  }
  bool? needSpecialTransport;
  int? transportCaseId;
  String? transportCaseName;
  String? transportCaseKey;
  int? charityId;
  String? charityName;
  int? vehicleId;
  String? vehicleName;
  String? driverIdentityNumber;
  String? driverName;
  String? driverMobile;
  int? mosqueId;
  String? mosqueName;
  int? ghuslPlaceId;
  String? ghuslPlaceName;
   String? assignDriverDate;
  TransportInfo copyWith({  bool? needSpecialTransport,
    int? transportCaseId,
    String? transportCaseName,
    String? transportCaseKey,
    int? charityId,
    String? charityName,
    int? vehicleId,
    String? vehicleName,
    String? driverIdentityNumber,
    String? driverName,
    String? driverMobile,
    int? mosqueId,
    String? mosqueName,
    int? ghuslPlaceId,
    String? ghuslPlaceName,
    String? assignDriverDate,
  }) => TransportInfo(  needSpecialTransport: needSpecialTransport ?? this.needSpecialTransport,
    transportCaseId: transportCaseId ?? this.transportCaseId,
    transportCaseName: transportCaseName ?? this.transportCaseName,
    transportCaseKey: transportCaseKey ?? this.transportCaseKey,
    charityId: charityId ?? this.charityId,
    charityName: charityName ?? this.charityName,
    vehicleId: vehicleId ?? this.vehicleId,
    vehicleName: vehicleName ?? this.vehicleName,
    driverIdentityNumber: driverIdentityNumber ?? this.driverIdentityNumber,
    driverName: driverName ?? this.driverName,
    assignDriverDate: assignDriverDate ?? this.assignDriverDate,
    driverMobile: driverMobile ?? this.driverMobile,
    mosqueId: mosqueId ?? this.mosqueId,
    mosqueName: mosqueName ?? this.mosqueName,
    ghuslPlaceId: ghuslPlaceId ?? this.ghuslPlaceId,
    ghuslPlaceName: ghuslPlaceName ?? this.ghuslPlaceName,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['needSpecialTransport'] = needSpecialTransport;
    map['transportCaseId'] = transportCaseId;
    map['transportCaseName'] = transportCaseName;
    map['transportCaseKey'] = transportCaseKey;
    map['charityId'] = charityId;
    map['charityName'] = charityName;
    map['vehicleId'] = vehicleId;
    map['vehicleName'] = vehicleName;
    map['driverIdentityNumber'] = driverIdentityNumber;
    map['driverName'] = driverName;
    map['driverMobile'] = driverMobile;
    map['mosqueId'] = mosqueId;
    map['mosqueName'] = mosqueName;
    map['ghuslPlaceId'] = ghuslPlaceId;
    map['ghuslPlaceName'] = ghuslPlaceName;
    return map;
  }

}