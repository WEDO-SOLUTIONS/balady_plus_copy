class ActivityDetailsInfo {
  final int? activityId;
  final String? activityName;
  final int? isicNumber;
  final String? isicName;
  final int? masterActivityId;
  final String? masterActivityName;
  final bool? isAtm;
  final bool? isHotel;
  final bool? isTobacco;
  final bool? isPetroleum;
  final double? minimumArea;
  final double? maximumArea;
  final double? minYears;
  final double? maxYears;
  final int? facilityId;
  final String? facilityName;

  ActivityDetailsInfo({
    this.activityId,
    this.activityName,
    this.isicNumber,
    this.isicName,
    this.masterActivityId,
    this.masterActivityName,
    this.isAtm,
    this.isHotel,
    this.isTobacco,
    this.isPetroleum,
    this.minimumArea,
    this.maximumArea,
    this.minYears,
    this.maxYears,
    this.facilityId,
    this.facilityName,
  });

  factory ActivityDetailsInfo.fromJson(Map<String, dynamic> json) =>
      ActivityDetailsInfo(
        activityId: json["activityId"],
        activityName: json["activityName"],
        isicNumber: json["isicNumber"],
        isicName: json["isicName"],
        masterActivityId: json["masterActivityId"],
        masterActivityName: json["masterActivityName"],
        isAtm: json["isAtm"],
        isHotel: json["isHotel"],
        isTobacco: json["isTobacco"],
        isPetroleum: json["isPetroleum"],
        minimumArea: json["minimumArea"]?.toDouble(),
        maximumArea: json["maximumArea"]?.toDouble(),
        minYears: json["minYears"]?.toDouble(),
        maxYears: json["maxYears"]?.toDouble(),
        facilityId: json["facilityId"],
        facilityName: json["facilityName"],
      );

  Map<String, dynamic> toJson() => {
        "activityId": activityId,
        "activityName": activityName,
        "isicNumber": isicNumber,
        "isicName": isicName,
        "masterActivityId": masterActivityId,
        "masterActivityName": masterActivityName,
        "isAtm": isAtm,
        "isHotel": isHotel,
        "isTobacco": isTobacco,
        "isPetroleum": isPetroleum,
        "minimumArea": minimumArea,
        "maximumArea": maximumArea,
        "minYears": minYears,
        "maxYears": maxYears,
        "facilityId": facilityId,
        "facilityName": facilityName,
      };
}
