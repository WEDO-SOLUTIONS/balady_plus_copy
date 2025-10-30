import 'package:localize_and_translate/localize_and_translate.dart';

import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/features/facility_qr/data/qr_details_response.dart';

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

  String getTodayWorkingHours() {
    WorkTimes? workTimes = this.workTimes;
    bool isOpenNow = checkIsOpenNow();

    if (workTimes == null) return "";

    if (workTimes.getToday() != null) {
      if (workTimes.getToday()?.openShiftOption == "OPEN_24HOUR") {
        return "";
      }
      //DateTime todayDate = DateTime.now();
      String? firstFromTime = workTimes.getToday()?.firstFromTime;
      String? firstToTime = workTimes.getToday()?.firstToTime;

      int? firstFromHour;
      int? firstFromMinute;
      int? firstToHour;
      int? firstToMinute;

      String? secondFromTime = workTimes.getToday()?.secondFromTime;
      String? secondToTime = workTimes.getToday()?.secondToTime;

      int? secondFromHour;
      int? secondFromMinute;
      int? secondToHour;
      int? secondToMinute;
      if (firstFromTime != null) {
        firstFromHour = int.tryParse(firstFromTime.split(":")[0]);

        firstFromMinute = int.tryParse(firstFromTime.split(":")[1]);
      }
      if (firstToTime != null) {
        firstToHour = int.tryParse(firstToTime.split(":")[0]);
        firstToMinute = int.tryParse(firstToTime.split(":")[1]);
      }

      if (secondFromTime != null) {
        secondFromHour = int.tryParse(secondFromTime.split(":")[0]);

        secondFromMinute = int.tryParse(secondFromTime.split(":")[1]);
      }
      if (secondToTime != null) {
        secondToHour = int.tryParse(secondToTime.split(":")[0]);
        secondToMinute = int.tryParse(secondToTime.split(":")[1]);
      }

      if (isOpenNow && workTimes.getToday()?.openShiftOption == "SHIFTED") {
        if (firstFromHour != null &&
            firstFromMinute != null &&
            firstToHour != null &&
            firstToMinute != null) {
          DateTime date = DateTime.now();
          final startTime = DateTime(
              date.year, date.month, date.day, firstFromHour, firstFromMinute);

          // To handle 12 AM to Case
          var firstToHourTmp = firstToHour;
          var firstToMinuteTmp = firstToMinute;
          if (firstToHour == 0 && firstToMinute == 0) {
            firstToHourTmp = 23;
            firstToMinuteTmp = 59;
          }

          final endTime = DateTime(date.year, date.month, date.day,
              firstToHourTmp, firstToMinuteTmp);
          final currentTime = DateTime.now();
          if (currentTime.isAfter(startTime) && currentTime.isBefore(endTime)) {
            return "close_at".tr() +
                CommonFunctions.convert24TimeTo12WithPeriod(
                    workTimes.getToday()?.firstToTime);
          }
        }
        if (secondFromHour != null &&
            secondFromMinute != null &&
            secondToHour != null &&
            secondToMinute != null) {
          DateTime date = DateTime.now();

          final startTime = DateTime(date.year, date.month, date.day,
              secondFromHour, secondFromMinute);
          // To handle 12 AM to Case
          var secondToHourTmp = secondToHour;
          var secondToMinuteTmp = secondToMinute;
          if (secondToHour == 0 && secondToMinute == 0) {
            secondToHourTmp = 23;
            secondToMinuteTmp = 59;
          }
          final endTime = DateTime(date.year, date.month, date.day,
              secondToHourTmp, secondToMinuteTmp);
          final currentTime = DateTime.now();
          if (currentTime.isAfter(startTime) && currentTime.isBefore(endTime)) {
            return "close_at".tr() +
                CommonFunctions.convert24TimeTo12WithPeriod(
                    workTimes.getToday()?.secondToTime);
          }
        }
      } else if (!isOpenNow &&
          workTimes.getToday()?.openShiftOption == "SHIFTED") {
        if (firstFromHour != null && firstFromMinute != null) {
          DateTime date = DateTime.now();
          final startTime = DateTime(
              date.year, date.month, date.day, firstFromHour, firstFromMinute);
          final currentTime = DateTime.now();
          if (currentTime.isBefore(startTime)) {
            return "open_at".tr() +
                CommonFunctions.convert24TimeTo12WithPeriod(
                    workTimes.getToday()?.firstFromTime);
          }
        }

        if (secondFromHour != null && secondFromMinute != null) {
          DateTime date = DateTime.now();
          final startTime = DateTime(date.year, date.month, date.day,
              secondFromHour, secondFromMinute);
          final currentTime = DateTime.now();
          if (currentTime.isBefore(startTime)) {
            return "open_at".tr() +
                CommonFunctions.convert24TimeTo12WithPeriod(
                    workTimes.getToday()?.secondFromTime);
          }
        }
      }
      if (!isOpenNow) {
        String strWhenClosed = "";
        int nextDayWeekDay = workTimes.getToday()?.weekDay == DateTime.sunday
            ? DateTime.monday
            : workTimes.getToday()!.weekDay! + 1;

        for (int i = 0; i < workTimes.workingTimes!.length; i++) {
          int nextDay = workTimes.workingTimes!
              .indexWhere((element) => element.weekDay == nextDayWeekDay);

          if (nextDay != -1) {
            WorkingTime day = workTimes.workingTimes![nextDay];
            if (day.openShiftOption == "OPEN_24HOUR") {
              if (i == 0) {
                strWhenClosed = "opentomrrow".tr();
              } else {
                strWhenClosed = "${"open_at".tr()}${day.dayName}";
              }
              return strWhenClosed;
            } else if (day.openShiftOption == "SHIFTED") {
              strWhenClosed =
                  "${"open_at".tr()}${day.dayName} ${CommonFunctions.convert24TimeTo12WithPeriod(day.firstFromTime!)}";
              return strWhenClosed;
            } else if (day.openShiftOption == "CLOSED") {
              nextDayWeekDay = nextDayWeekDay == DateTime.sunday
                  ? DateTime.monday
                  : nextDay + 1;
            }
          }
        }

        return strWhenClosed;
      }

      return " . " +
          CommonFunctions.getFormattedTimeforQR(
              workTimes.getToday()?.firstFromTime,
              workTimes.getToday()?.firstToTime);
    }
    return "";
  }

  bool checkIsOpenNow() {
    bool isOpenedNow = false;
    DateTime date = DateTime.now();
    WorkTimes? workTimes = this.workTimes;
    WorkingTime? today = workTimes?.getToday();

    if (today == null) return isOpenedNow;
    if (today.openShiftOption == "OPEN_24HOUR") {
      isOpenedNow = true;
    } else if (today.openShiftOption == "SHIFTED" &&
        today.firstFromTime != null &&
        today.firstToTime != null) {
      int? firstFromHour;
      int? firstFromMinute;
      int? firstToHour;
      int? firstToMinute;

      if (today.firstFromTime != null) {
        firstFromHour = int.tryParse(today.firstFromTime!.split(":")[0]);

        firstFromMinute = int.tryParse(today.firstFromTime!.split(":")[1]);
      }
      if (today.firstToTime != null) {
        firstToHour = int.tryParse(today.firstToTime!.split(":")[0]);
        firstToMinute = int.tryParse(today.firstToTime!.split(":")[1]);
      }

      if (firstFromHour != null &&
          firstFromMinute != null &&
          firstToHour != null &&
          firstToMinute != null) {
        final startTime = DateTime(
            date.year, date.month, date.day, firstFromHour, firstFromMinute);
        // To handle 12 AM to Case
        var firstToHourTmp = firstToHour;
        var firstToMinuteTmp = firstToMinute;
        if (firstToHour == 0 && firstToMinute == 0) {
          firstToHourTmp = 23;
          firstToMinuteTmp = 59;
        }
        final endTime = DateTime(
            date.year, date.month, date.day, firstToHourTmp, firstToMinuteTmp);
        final currentTime = DateTime.now();
        if (currentTime.isAfter(startTime) && currentTime.isBefore(endTime)) {
          isOpenedNow = true;
        }
      }
    }
    if (!isOpenedNow &&
        today.openShiftOption == "SHIFTED" &&
        today.secondFromTime != null &&
        today.secondToTime != null) {
      int? secondFromHour;
      int? secondFromMinute;
      int? secondToHour;
      int? secondToMinute;

      if (today.secondFromTime != null) {
        secondFromHour = int.tryParse(today.secondFromTime!.split(":")[0]);

        secondFromMinute = int.tryParse(today.secondFromTime!.split(":")[1]);
      }
      if (today.secondToTime != null) {
        secondToHour = int.tryParse(today.secondToTime!.split(":")[0]);
        secondToMinute = int.tryParse(today.secondToTime!.split(":")[1]);
      }

      if (secondFromHour != null &&
          secondFromMinute != null &&
          secondToHour != null &&
          secondToMinute != null) {
        final startTime = DateTime(
            date.year, date.month, date.day, secondFromHour, secondFromMinute);

        // To handle 12 AM to Case
        var secondToHourTmp = secondToHour;
        var secondToMinuteTmp = secondToMinute;
        if (secondToHour == 0 && secondToMinute == 0) {
          secondToHourTmp = 23;
          secondToMinuteTmp = 59;
        }

        final endTime = DateTime(date.year, date.month, date.day,
            secondToHourTmp, secondToMinuteTmp);
        final currentTime = DateTime.now();
        if (currentTime.isAfter(startTime) && currentTime.isBefore(endTime)) {
          isOpenedNow = true;
        }
      }
    }
    return isOpenedNow;
  }
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

// class WorkTimes {
//   List<WorkingTime>? workingTimes;
//
//   WorkTimes({
//     this.workingTimes,
//   });
//
//   WorkingTime? getToday() {
//     WorkingTime? today;
//     if (workingTimes != null) {
//       today = workingTimes!.firstWhere((element) => element.isToday ?? false);
//     }
//     return today;
//   }
// }
//
// class WorkingTime {
//   int? dayId;
//   String? dayName;
//   String? openShiftOption;
//   String? firstFromTime;
//   String? firstToTime;
//   String? secondFromTime;
//   String? secondToTime;
//   int? weekDay;
//   bool? isToday;
//
//   WorkingTime({
//     this.dayId,
//     this.dayName,
//     this.openShiftOption,
//     this.firstFromTime,
//     this.firstToTime,
//     this.secondFromTime,
//     this.secondToTime,
//     this.weekDay,
//     this.isToday
//   });
//
//
//   bool dayHasTwoShifts() {
//     if (openShiftOption == "SHIFTED") {
//       if (firstFromTime != null &&
//           firstToTime != null &&
//           secondFromTime != null &&
//           secondToTime != null) {
//         return true;
//       }
//       return false;
//     }
//     return false;
//   }
//
//
//
// }
