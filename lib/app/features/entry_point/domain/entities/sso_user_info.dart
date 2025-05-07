import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:equatable/equatable.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:mapness/shared/constants/names_ar.dart';

class SsoUserInfo extends Equatable {
  const SsoUserInfo(
      {this.name,
      this.phone,
      this.mail,
      this.arName,
      this.enName,
      this.idNo,
      this.nid,
      this.idType,
      this.sex,
      this.dob,
      this.sname,
      this.sub,
      this.nationality,
      this.tnm});

  final String? name;
  final String? phone;
  final String? mail;
  final String? arName;
  final String? enName;
  final String? idNo;
  final String? nid;
  final String? idType;
  final String? sex;
  final String? dob;
  final String? sname;
  final String? sub;
  final String? nationality;
  final String? tnm;

  String getFormattedBirthDate({bool withDash = false}) {
    if (dob != null) {
      String formattedBirthDate = dob!;
      //  formattedBirthDate = formattedBirthDate.replaceAll("-", "/");
      String birthDate = "";
      if (withDash) {
        birthDate = formattedBirthDate.split("/").reversed.join("-");
      } else {
        birthDate = formattedBirthDate.split("/").reversed.join("/");
      }

      return birthDate;
    }
    return "";
  }

  String getFirstName() {
    List<String> names = sname?.split(',') ?? [""];

    return names.first;
  }

  String getLastName() {
    List<String> names = sname?.split(',') ?? [""];

    return names.last;
  }

  String getFirstNameEn() {
    List<String> names = enName?.split(' ') ?? [""];

    return names.first;
  }

  String getLastNameEn() {
    List<String> names = enName?.split(' ') ?? [""];

    return names.last;
  }

  String getMiddleName() {
    try {
      List<String> names = sname?.split(',') ?? [""];

      return names.elementAt(1);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return " ";
    }
  }

  String getThirdName() {
    try {
      List<String> names = (sname ?? "").split(',');
      if (names.length >= 4) {
        return names.elementAt(2);
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return " ";
    }
    return " ";
  }

  String getFirstAndLastName() {
    if (CommonFunctions.isAppAR) {
      return getFirstName() + " " + getLastName();
    } else {
      return getFirstNameEn() + " " + getLastNameEn();
    }
  }

  String getIdType() {
    if (idNo != null) {
      if (idNo?.startsWith("1") ?? false) {
        return "1";
      } else {
        return "3";
      }

// هوية وطنيه ١
// هوية خليجيه ٤
// رقم حدود ٩
// هوية مقيم ٣
    }
    return "";
  }

  String getIdTypeName() {
    if (idType != null) {
      if (idType?.startsWith("1") ?? false) {
        return "National_ID".tr();
      } else {
        return "Iqama_ID".tr();
      }

// هوية وطنيه ١
// هوية خليجيه ٤
// رقم حدود ٩
// هوية مقيم ٣
    }
    return "";
  }

  String getHijriBirthDate() {
    String applicantDob = dob ?? "";
    try {
      HijriCalendar hijriCalendar = HijriCalendar();

      List<String> date = applicantDob.split("/");
      List<int> dateDivided = [];

      for (var element in date) {
        dateDivided.add(int.tryParse(element)!);
      }

      String hDate = hijriCalendar.gregorianToHijri(
          dateDivided[2], dateDivided[1], dateDivided[0]);

      String year = hijriCalendar.hYear.toString();
      String month = hijriCalendar.hMonth.toString().length == 1
          ? "0" + hijriCalendar.hMonth.toString()
          : hijriCalendar.hMonth.toString();
      String day = hijriCalendar.hDay.toString().length == 1
          ? "0" + hijriCalendar.hDay.toString()
          : hijriCalendar.hDay.toString();

      if (dateDivided[2] > 1800) {
        return year + "/" + month + "/" + day;
      } else {
        String year = dateDivided[2].toString();
        String month = dateDivided[1].toString().length == 1
            ? "0" + dateDivided[1].toString()
            : dateDivided[1].toString();
        String day = dateDivided[0].toString().length == 1
            ? "0" + dateDivided[0].toString()
            : dateDivided[0].toString();
        return year + "/" + month + "/" + day;
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return applicantDob;
    }
  }

  String getEmail() {
    String email =
        mail?.replaceAll("\u200e", '').replaceAll("\u200f", '').trim() ?? "";
    return email;
  }

  String getPhone() {
    return phone != null
        ? (!phone!.startsWith("0") ? "0" + phone! : phone!)
        : "";
  }

  String getGender() {
    return sex == "1" ? "male".tr() : "female".tr();
  }

  String? getFullName() {
    return CommonFunctions.isAppAR ? arName : enName;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = mail;
    data['name'] = name;
    data['phone'] = phone;
    data['name_ar'] = namesAr;
    return data;
  }

  @override
  List<Object?> get props => [idNo, name, mail, phone, nationality];
}
