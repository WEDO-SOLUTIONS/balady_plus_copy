import 'package:balady_plus/app/features/commercial_license_inquery/domain/entity/commercial_license_data_entity.dart';

class CommercialLicenseDataModel extends CommercialLicenseData {
  CommercialLicenseDataModel({
    super.additionalActivities,
    super.allowedSideWalkPermit,
    super.allowedTwentyFourPermit,
    super.cityId,
    super.cityName,
    super.crNumber,
    super.districtName,
    super.email,
    super.entityType,
    super.expiryDate,
    super.facebook,
    super.instagram,
    super.licenseAutoCanceled,
    super.licenseNumber,
    super.licenseStatusId,
    super.licenseStatusName,
    super.licenseSuspended,
    super.mainActivity,
    super.mobile,
    super.phone,
    super.qrExist,
    super.regionId,
    super.regionName,
    super.shopName,
    super.shopNameAr,
    super.shopNameEn,
    super.snapchat,
    super.twitter,
    super.website,
    super.whatsApp,
    super.workTimes,
    super.workerType,
    super.x,
    super.y,
  });


  CommercialLicenseDataModel.fromJson(Map<String, dynamic> json){
    additionalActivities = List.from(json['additionalActivities']).map((e)=>AdditionalActivitiesModel.fromJson(e)).toList();
    allowedSideWalkPermit = json['allowedSideWalkPermit'];
    allowedTwentyFourPermit = json['allowedTwentyFourPermit'];
    cityId = json['cityId'];
    cityName = json['cityName'];
    crNumber = json['crNumber'];
    districtName = json['districtName'];
    email = json['email'];
    entityType = json['entityType'];
    expiryDate = json['expiryDate'];
    facebook = json['facebook'];
    instagram = json['instagram'];
    licenseAutoCanceled = json['licenseAutoCanceled'];
    licenseNumber = json['licenseNumber'];
    licenseStatusId = json['licenseStatusId'];
    licenseStatusName = json['licenseStatusName'];
    licenseSuspended = json['licenseSuspended'];
    mainActivity = MainActivityModel.fromJson(json['mainActivity']);
    mobile = json['mobile'];
    phone = json['phone'];
    qrExist = json['qrExist'];
    regionId = json['regionId'];
    regionName = json['regionName'];
    shopName = json['shopName'];
    shopNameAr = json['shopNameAr'];
    shopNameEn = json['shopNameEn'];
    snapchat = json['snapchat'];
    twitter = json['twitter'];
    website = json['website'];
    whatsApp = json['whatsApp'];
    workTimes = WorkTimesModel.fromJson(json['workTimes']);
    workerType = json['workerType'];
    x = json['x'];
    y = json['y'];
  }


}

class AdditionalActivitiesModel extends AdditionalActivity  {
  AdditionalActivitiesModel({
    super.additionalActivities,
    super.atmFeesPaid,
    super.foreignInvistor,
    super.inHomogenusActivities,
    super.mainActivity,
    super.workerTypeId,
  });


  AdditionalActivitiesModel.fromJson(Map<String, dynamic> json){
    additionalActivities = List.from(json['additionalActivities']).map((e)=>AdditionalActivitiesModel.fromJson(e)).toList();
    atmFeesPaid = json['atmFeesPaid'];
    foreignInvistor = json['foreignInvistor'];
    inHomogenusActivities = List.from(json['inHomogenusActivities']).map((e)=>InHomogenusActivitiesModel.fromJson(e)).toList();
    mainActivity = MainActivityModel.fromJson(json['mainActivity']);
    workerTypeId = json['workerTypeId'];
  }


}

class InHomogenusActivitiesModel  extends InHomogenusActivity{
  InHomogenusActivitiesModel({
    super.accommodationTypeId,
    super.accommodationTypeName,
    super.area,
    super.detailedActivityId,
    super.unitCount,
  });


  InHomogenusActivitiesModel.fromJson(Map<String, dynamic> json){
    accommodationTypeId = json['accommodationTypeId'];
    accommodationTypeName = json['accommodationTypeName'];
    area = json['area'];
    detailedActivityId = json['detailedActivityId'];
    unitCount = json['unitCount'];
  }


}

class MainActivityModel extends MainActivity{
  MainActivityModel({
    super.accommodationTypeId,
    super.accommodationTypeName,
    super.area,
    super.detailedActivityId,
    super.unitCount,
  });


  MainActivityModel.fromJson(Map<String, dynamic> json){
    accommodationTypeId = json['accommodationTypeId'];
    accommodationTypeName = json['accommodationTypeName'];
    area = json['area'];
    detailedActivityId = json['detailedActivityId'];
    unitCount = json['unitCount'];
  }


}

class WorkTimesModel  extends WorkTimes{
  WorkTimesModel({
    super.workingTimes,
  });


  WorkTimesModel.fromJson(Map<String, dynamic> json){
    workingTimes = List.from(json['workingTimes']).map((e)=>WorkingTimesModel.fromJson(e)).toList();
  }


}

class WorkingTimesModel extends WorkingTime {
  WorkingTimesModel({
    super.dayId,
    super.dayName,
    super.firstFromTime,
    super.firstToTime,
    super.openShiftOption,
    super.secondFromTime,
    super.secondToTime,
  });


  WorkingTimesModel.fromJson(Map<String, dynamic> json){
    dayId = json['dayId'];
    dayName = json['dayName'];
    firstFromTime = json['firstFromTime'];
    firstToTime = json['firstToTime'];
    openShiftOption = json['openShiftOption'];
    secondFromTime = json['secondFromTime'];
    secondToTime = json['secondToTime'];
  }


}