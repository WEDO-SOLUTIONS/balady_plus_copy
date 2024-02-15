

class CommercialLicenseData {
  int? licenseNumber;
  Info? licenseStatus;
  String? entityType;
  String? workerType;
  String? shopNameAr;
  dynamic shopNameEn;
  Info? city;
  Info? district;
  String? x;
  String? y;
  LicenseActivity? mainActivity;
  List<LicenseActivity>? additionalActivities;
  String? customerServicePhoneNumber;
  String? email;
  String? phone;
  String? website;
  String? facebook;
  String? twitter;
  String? instagram;
  String? snapchat;
  String? whatsApp;
  WorkTimes? workTimes;

  CommercialLicenseData({
    this.licenseNumber,
    this.licenseStatus,
    this.entityType,
    this.workerType,
    this.shopNameAr,
    this.shopNameEn,
    this.city,
    this.district,
    this.x,
    this.y,
    this.mainActivity,
    this.additionalActivities,
    this.customerServicePhoneNumber,
    this.email,
    this.phone,
    this.website,
    this.facebook,
    this.twitter,
    this.instagram,
    this.snapchat,
    this.whatsApp,
    this.workTimes,
  });

}

class LicenseActivity {
  int? isicNumber;
  String? isicName;
  int? detailedActivityId;
  String? detailedActivityName;

  LicenseActivity({
    this.isicNumber,
    this.isicName,
    this.detailedActivityId,
    this.detailedActivityName,
  });

}

class Info {
  int? id;
  String? name;

  Info({
    this.id,
    this.name,
  });

}

class WorkTimes {
  List<WorkingTime>? workingTimes;

  WorkTimes({
    this.workingTimes,
  });

}

class WorkingTime {
  int? dayId;
  String? dayName;
  String? openShiftOption;
  String? firstFromTime;
  String? firstToTime;
  String? secondFromTime;
  String? secondToTime;

  WorkingTime({
    this.dayId,
    this.dayName,
    this.openShiftOption,
    this.firstFromTime,
    this.firstToTime,
    this.secondFromTime,
    this.secondToTime,
  });

}


