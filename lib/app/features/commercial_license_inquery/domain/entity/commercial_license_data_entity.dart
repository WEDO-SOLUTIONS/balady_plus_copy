
class AdditionalActivity {
  List<AdditionalActivity?>? additionalActivities;
  bool? atmFeesPaid;
  bool? foreignInvistor;
  List<InHomogenusActivity?>? inHomogenusActivities;
  MainActivity? mainActivity;
  int? workerTypeId;
  int? accommodationTypeId;
  String? accommodationTypeName;
  int? area;
  int? detailedActivityId;
  int? unitCount;

  AdditionalActivity({this.additionalActivities, this.atmFeesPaid, this.foreignInvistor, this.inHomogenusActivities, this.mainActivity, this.workerTypeId, this.accommodationTypeId, this.accommodationTypeName, this.area, this.detailedActivityId, this.unitCount});

}

class InHomogenusActivity {
  int? accommodationTypeId;
  String? accommodationTypeName;
  int? area;
  int? detailedActivityId;
  int? unitCount;

  InHomogenusActivity({this.accommodationTypeId, this.accommodationTypeName, this.area, this.detailedActivityId, this.unitCount});

}

class MainActivity {
  int? accommodationTypeId;
  String? accommodationTypeName;
  int? area;
  int? detailedActivityId;
  int? unitCount;
  List<AdditionalActivity?>? additionalActivities;
  bool? atmFeesPaid;
  bool? foreignInvistor;
  List<InHomogenusActivity?>? inHomogenusActivities;
  MainActivity? mainActivity;
  int? workerTypeId;

  MainActivity({this.accommodationTypeId, this.accommodationTypeName, this.area, this.detailedActivityId, this.unitCount, this.additionalActivities, this.atmFeesPaid, this.foreignInvistor, this.inHomogenusActivities, this.mainActivity, this.workerTypeId});

}

class CommercialLicenseData {
  List<AdditionalActivity?>? additionalActivities;
  bool? allowedSideWalkPermit;
  bool? allowedTwentyFourPermit;
  int? cityId;
  String? cityName;
  String? crNumber;
  String? districtName;
  String? email;
  String? entityType;
  String? expiryDate;
  String? facebook;
  String? instagram;
  bool? licenseAutoCanceled;
  int? licenseNumber;
  int? licenseStatusId;
  String? licenseStatusName;
  bool? licenseSuspended;
  MainActivity? mainActivity;
  String? mobile;
  String? phone;
  bool? qrExist;
  int? regionId;
  String? regionName;
  String? shopName;
  String? shopNameAr;
  String? shopNameEn;
  String? snapchat;
  String? twitter;
  String? website;
  String? whatsApp;
  WorkTimes? workTimes;
  String? workerType;
  String? x;
  String? y;

  CommercialLicenseData({this.additionalActivities, this.allowedSideWalkPermit, this.allowedTwentyFourPermit, this.cityId, this.cityName, this.crNumber, this.districtName, this.email, this.entityType, this.expiryDate, this.facebook, this.instagram, this.licenseAutoCanceled, this.licenseNumber, this.licenseStatusId, this.licenseStatusName, this.licenseSuspended, this.mainActivity, this.mobile, this.phone, this.qrExist, this.regionId, this.regionName, this.shopName, this.shopNameAr, this.shopNameEn, this.snapchat, this.twitter, this.website, this.whatsApp, this.workTimes, this.workerType, this.x, this.y});

}

class WorkingTime {
  int? dayId;
  String? dayName;
  String? firstFromTime;
  String? firstToTime;
  String? openShiftOption;
  String? secondFromTime;
  String? secondToTime;

  WorkingTime({this.dayId, this.dayName, this.firstFromTime, this.firstToTime, this.openShiftOption, this.secondFromTime, this.secondToTime});

}

class WorkTimes {
  List<WorkingTime?>? workingTimes;

  WorkTimes({this.workingTimes});

}

