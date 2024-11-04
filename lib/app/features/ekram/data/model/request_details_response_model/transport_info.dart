class TransportInfo {
  bool? needSpecialTransport;
  int? transportCaseId;
  String? transportCaseName;
  String? transportCaseKey;
  int? charityId;
  String? charityName;
  int? mosqueId;
  String? mosqueName;
  int? ghuslPlaceId;
  String? ghuslPlaceName;

  TransportInfo({
    this.needSpecialTransport,
    this.transportCaseId,
    this.transportCaseName,
    this.transportCaseKey,
    this.charityId,
    this.charityName,
    this.mosqueId,
    this.mosqueName,
    this.ghuslPlaceId,
    this.ghuslPlaceName,
  });

  factory TransportInfo.fromJson(Map<String, dynamic> json) => TransportInfo(
        needSpecialTransport: json['needSpecialTransport'] as bool?,
        transportCaseId: json['transportCaseId'] as int?,
        transportCaseName: json['transportCaseName'] as String?,
        transportCaseKey: json['transportCaseKey'] as String?,
        charityId: json['charityId'] as int?,
        charityName: json['charityName'] as String?,
        mosqueId: json['mosqueId'] as int?,
        mosqueName: json['mosqueName'] as String?,
        ghuslPlaceId: json['ghuslPlaceId'] as int?,
        ghuslPlaceName: json['ghuslPlaceName'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'needSpecialTransport': needSpecialTransport,
        'transportCaseId': transportCaseId,
        'transportCaseName': transportCaseName,
        'transportCaseKey': transportCaseKey,
        'charityId': charityId,
        'charityName': charityName,
        'mosqueId': mosqueId,
        'mosqueName': mosqueName,
        'ghuslPlaceId': ghuslPlaceId,
        'ghuslPlaceName': ghuslPlaceName,
      };
}
