import 'package:balady_plus/app/features/calculator/service_calculator_exports.dart'
    show BoardList, SideWalkList;

class CalculateCostV03 {
  String? subMunicipalityId;
  int? serviceTypeId;
  int? subActivityId;
  int? isicDetailedActivityId;
  double? area;
  int? accommodationTypeId;
  bool? isVisit;
  bool? isCitizenPledgedToClean;
  String? expiryDate;
  List<BoardList>? boardList;
  int? oldIsicDetailedActivityId;
  double? oldArea;
  int? oldAccommodationTypeId;
  List<BoardList>? oldBoardList;
  List<SideWalkList>? sideWalkList;
  int? calculateCityId;
  bool? isTobacco;
  bool? oldIsTobacco;
  bool? oldIsCitizenPledgedToClean;
  String? zone;
  int? activity24Type;
  int? paymentYearsCount;
  int? DailyRentCost;

  CalculateCostV03(
      {this.subMunicipalityId,
      this.serviceTypeId,
      this.subActivityId,
      this.isicDetailedActivityId,
      this.area,
      this.accommodationTypeId,
      this.isVisit,
      this.isCitizenPledgedToClean,
      this.expiryDate,
      this.boardList,
      this.oldIsicDetailedActivityId,
      this.oldArea,
      this.oldAccommodationTypeId,
      this.oldBoardList,
      this.sideWalkList,
      this.calculateCityId,
      this.isTobacco,
      this.oldIsTobacco,
      this.oldIsCitizenPledgedToClean,
      this.zone,
      this.activity24Type,
      this.paymentYearsCount,
      this.DailyRentCost});

  factory CalculateCostV03.fromJson(Map<String, dynamic> json) =>
      _$CalculateCostV03FromJson(json);

  Map<String, dynamic> toJson() => _$CalculateCostV03ToJson(this);
}

CalculateCostV03 _$CalculateCostV03FromJson(Map<String, dynamic> json) {
  return CalculateCostV03(
      subMunicipalityId: json["SubMunicipalityId"],
      serviceTypeId: json["ServiceTypeId"],
      isicDetailedActivityId: json["IsicDetailedActivityId"],
      subActivityId: json["SubActivityId"],
      area: json["Area"],
      accommodationTypeId: json["AccommodationTypeId"],
      isVisit: json["IsVisit"],
      isCitizenPledgedToClean: json["IsCitizenPledgedToClean"],
      expiryDate: json["ExpiryDate"],
      boardList: json["BoardList"],
      oldIsicDetailedActivityId: json["OldIsicDetailedActivityId"],
      oldArea: json["OldArea"],
      oldAccommodationTypeId: json["OldAccommodationTypeId"],
      oldBoardList: json["OldBoardList"],
      sideWalkList: json["SideWalkList"],
      calculateCityId: json["CalculateCityId"],
      isTobacco: json["IsTobacco"],
      oldIsTobacco: json["OldIsTobacco"],
      oldIsCitizenPledgedToClean: json["OldIsCitizenPledgedToClean"],
      zone: json["Zone"],
      activity24Type: json["Activity24Type"],
      paymentYearsCount: json["PaymentYearsCount"],
      DailyRentCost: json["DailyRentCost"]);
}

Map<String, dynamic> _$CalculateCostV03ToJson(CalculateCostV03 instance) =>
    <String, dynamic>{
      if (instance.subMunicipalityId != null)
        "SubMunicipalityId": instance.subMunicipalityId,
      if (instance.serviceTypeId != null)
        "ServiceTypeId": instance.serviceTypeId,
      if (instance.isicDetailedActivityId != null)
        "IsicDetailedActivityId": instance.isicDetailedActivityId,
      if (instance.subActivityId != null)
        "SubActivityId": instance.subActivityId,
      if (instance.area != null) "Area": instance.area,
      if (instance.accommodationTypeId != null)
        "AccommodationTypeId": instance.accommodationTypeId,
      if (instance.isVisit != null) "IsVisit": instance.isVisit,
      if (instance.isCitizenPledgedToClean != null)
        "IsCitizenPledgedToClean": instance.isCitizenPledgedToClean,
      if (instance.expiryDate != null)
        if (instance.expiryDate != null) "ExpiryDate": instance.expiryDate,
      if (instance.boardList != null)
        "BoardList":
            List<dynamic>.from(instance.boardList!.map((x) => x.toJson())),
      if (instance.oldIsicDetailedActivityId != null)
        "OldIsicDetailedActivityId": instance.oldIsicDetailedActivityId,
      if (instance.oldArea != null) "OldArea": instance.oldArea,
      if (instance.oldAccommodationTypeId != null)
        "OldAccommodationTypeId": instance.oldAccommodationTypeId,
      if (instance.oldBoardList != null)
        "OldBoardList":
            List<dynamic>.from(instance.oldBoardList!.map((x) => x.toJson())),
      if (instance.sideWalkList != null)
        "SideWalkList":
            List<dynamic>.from(instance.sideWalkList!.map((x) => x.toJson())),
      if (instance.calculateCityId != null)
        "CalculateCityId": instance.calculateCityId,
      if (instance.isTobacco != null) "IsTobacco": instance.isTobacco,
      if (instance.oldIsTobacco != null) "OldIsTobacco": instance.oldIsTobacco,
      if (instance.oldIsCitizenPledgedToClean != null)
        "OldIsCitizenPledgedToClean": instance.oldIsCitizenPledgedToClean,
      if (instance.zone != null) "Zone": instance.zone,
      if (instance.activity24Type != null)
        "Activity24Type": instance.activity24Type,
      if (instance.paymentYearsCount != null)
        "PaymentYearsCount": instance.paymentYearsCount,
      if (instance.DailyRentCost != null)
        "DailyRentCost": instance.DailyRentCost
    };
