import 'package:balady_plus/app/commercial_model/features/commercial_license_inquery/domain/entity/commercial_license_data_entity.dart';

import 'package:balady_plus/app/features/facility_qr/data/qr_details_response.dart';

class CommercialLicenseDataModel extends CommercialLicenseData {
  CommercialLicenseDataModel({
    super.licenseNumber,
    super.licenseStatus,
    super.entityType,
    super.workerType,
    super.shopNameAr,
    super.shopNameEn,
    super.city,
    super.district,
    super.x,
    super.y,
    super.mainActivity,
    super.additionalActivities,
    super.customerServicePhoneNumber,
    super.email,
    super.phone,
    super.website,
    super.facebook,
    super.twitter,
    super.instagram,
    super.snapchat,
    super.whatsApp,
    super.workTimes,
  });

  CommercialLicenseDataModel.fromJson(Map<String, dynamic> json) {
    licenseNumber = json['licenseNumber'];
    licenseStatus = InfoModel.fromJson(json['licenseStatus']);
    entityType = json['entityType'];
    workerType = json['workerType'];
    shopNameAr = json['shopNameAr'];
    shopNameEn = json['shopNameEn'];
    if (json['city'] != null) {
      city = InfoModel.fromJson(json['city']);
    }
    if (json['district'] != null) {
      district = InfoModel.fromJson(json['district']);
    }
    x = json['x'];
    y = json['y'];
    mainActivity = ActivityModel.fromJson(json['mainActivity']);
    additionalActivities = List.from(json['additionalActivities'])
        .map((e) => ActivityModel.fromJson(e))
        .toList();
    customerServicePhoneNumber = json['customerServicePhoneNumber'];
    email = json['email'];
    phone = json['phone'];
    website = json['website'];
    facebook = json['facebook'];
    instagram = json['instagram'];
    twitter = json['twitter'];
    snapchat = json['snapchat'];
    whatsApp = json['whatsApp'];

    workTimes = json["workTimes"] == null
        ? null
        : WorkTimes.fromJson(json["workTimes"]);
  }
}

class ActivityModel extends LicenseActivity {
  ActivityModel({
    super.isicNumber,
    super.isicName,
    super.detailedActivityId,
    super.detailedActivityName,
  });

  ActivityModel.fromJson(Map<String, dynamic> json) {
    isicNumber = json['isicNumber'];
    isicName = json['isicName'];
    detailedActivityId = json['detailedActivityId'];
    detailedActivityName = json['detailedActivityName'];
  }
}

class InfoModel extends Info {
  InfoModel({super.id, super.name});

  InfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}

// class WorkTimesModel  extends WorkTimes{
//   WorkTimesModel({
//     super.workingTimes,
//   });
//
//
//   WorkTimesModel.fromJson(Map<String, dynamic> json){
//     workingTimes = List.from(json['workingTimes']).map((e)=>WorkingTimesModel.fromJson(e)).toList();
//   }
//
//
//
//
// }
//
// class WorkingTimesModel extends WorkingTime {
//   WorkingTimesModel({
//     super.dayId,
//     super.dayName,
//     super.firstFromTime,
//     super.firstToTime,
//     super.openShiftOption,
//     super.secondFromTime,
//     super.secondToTime,
//     super.weekDay,
//     super.isToday,
//
//   });
//
//
//   WorkingTimesModel.fromJson(Map<String, dynamic> json){
//     DateTime date = DateTime.now();
//     dayId = json['dayId'];
//     dayName = json['dayName'];
//     firstFromTime = json['firstFromTime'];
//     firstToTime = json['firstToTime'];
//     openShiftOption = json['openShiftOption'];
//     secondFromTime = json['secondFromTime'];
//     secondToTime = json['secondToTime'];
//     weekDay: getWeekday(json["dayId"]);
//     isToday: (getWeekday(json["dayId"]) == date.weekday);
//   }
//   static int getWeekday(int dayId) {
//     if (dayId != null) {
//       switch (dayId) {
//         case 1:
//           return DateTime.sunday;
//           break;
//         case 2:
//           return DateTime.monday;
//           break;
//         case 3:
//           return DateTime.tuesday;
//           break;
//         case 4:
//           return DateTime.wednesday;
//           break;
//         case 5:
//           return DateTime.thursday;
//           break;
//         case 6:
//           return DateTime.friday;
//           break;
//         case 7:
//           return DateTime.saturday;
//         default:
//           return dayId;
//       }
//     }
//     return 0;
//   }
//
//
//
//
//
//
//
//
// }
