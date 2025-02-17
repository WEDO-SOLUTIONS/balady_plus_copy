
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
  this.assignDriverDate,
  this.specialTransportReasonId,
   this.showOther,
    this.specialTransportReasonOther


  });

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
    specialTransportReasonId = json['specialTransportReasonId'];
    specialTransportReasonOther = json['specialTransportReasonOther'];


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
  int?specialTransportReasonId;
  bool? showOther;
  String? specialTransportReasonOther;


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
    int?specialTransportReasonId,
    String? mosqueName,
    int? ghuslPlaceId,
    String? ghuslPlaceName,
    String? assignDriverDate,
    bool? showOther,
    String? specialTransportReasonOther,
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
    mosqueId: mosqueId == -1? null: mosqueId ?? this.mosqueId,
    mosqueName: mosqueName ?? this.mosqueName,
    ghuslPlaceId: ghuslPlaceId == -1 ? null:ghuslPlaceId ??  this.ghuslPlaceId,
    ghuslPlaceName: ghuslPlaceName ?? this.ghuslPlaceName,
    specialTransportReasonId: specialTransportReasonId ?? this.specialTransportReasonId,
      showOther: showOther ?? this.showOther,
    specialTransportReasonOther: specialTransportReasonOther ?? this.specialTransportReasonOther,

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
    map['specialTransportReasonId'] = specialTransportReasonId;
    map['specialTransportReasonOther'] = specialTransportReasonOther;

    return map;
  }

  bool isCharityChanged(int? newId) {
    if (newId != null) {
      if (charityId != newId) {
        return true;
      }
    }
    return false;
  }
}