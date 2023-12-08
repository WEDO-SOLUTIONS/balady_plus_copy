class SubActivityDetails {
  int? id;
  String? name;
  String? ename;
  dynamic nameEn;
  double? maxArea;
  double? minArea;
  MainActivity? mainActivity;
  int? isicNumber;
  SubSubActivity? subActivity;
  bool? isLicenseOwnerFemaleOnly;
  bool? isWorkerTypeFemaleOnly;
  List<ActivityTerm>? activityTerms;
  String? unit;
  String? unitDesc;
  int? minYears;
  int? maxYears;
  int? isTabacco;
  bool? fawry;
  int? twentyFourHourStatus;
  bool? vehicleParkingPermit;
  int? entityType;
  dynamic vehicleType;
  dynamic pathType;
  bool? foodActivity;
  dynamic ownershipType;
  dynamic requestFlow;

  SubActivityDetails({
    this.id,
    this.name,
    this.ename,
    this.nameEn,
    this.maxArea,
    this.minArea,
    this.mainActivity,
    this.isicNumber,
    this.subActivity,
    this.isLicenseOwnerFemaleOnly,
    this.isWorkerTypeFemaleOnly,
    this.activityTerms,
    this.unit,
    this.unitDesc,
    this.minYears,
    this.maxYears,
    this.isTabacco,
    this.fawry,
    this.twentyFourHourStatus,
    this.vehicleParkingPermit,
    this.entityType,
    this.vehicleType,
    this.pathType,
    this.foodActivity,
    this.ownershipType,
    this.requestFlow,
  });
}

class ActivityTerm {
  String? sectionName;
  List<SectionContent>? sectionContent;

  ActivityTerm({
    this.sectionName,
    this.sectionContent,
  });
}

class SectionContent {
  String? label;
  List<String>? value;

  SectionContent({
    this.label,
    this.value,
  });
}

class MainActivity {
  int? id;
  String? nameAr;
  dynamic nameEn;
  int? activityTypeId;
  bool? craft;
  dynamic craftMessage;

  MainActivity({
    this.id,
    this.nameAr,
    this.nameEn,
    this.activityTypeId,
    this.craft,
    this.craftMessage,
  });
}

class SubSubActivity {
  int? id;
  String? nameAr;
  dynamic nameEn;

  SubSubActivity({
    this.id,
    this.nameAr,
    this.nameEn,
  });
}

class StatusDetails {
  int? code;
  String? message;

  StatusDetails({
    this.code,
    this.message,
  });
}
