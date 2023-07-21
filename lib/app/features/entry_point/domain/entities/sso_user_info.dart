
import 'package:equatable/equatable.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class SsoUserInfo extends Equatable {
  const SsoUserInfo({
    this.name,
    this.phone,
    this.mail,
    this.arName,
    this.idNo,
    this.nid,
    this.idType,
    this.sex,
    this.dob,
    this.sname,
    this.sub,
    this.nationality,
  });

  final String? name;
  final String? phone;
  final String? mail;
  final String? arName;
  final String? idNo;
  final String? nid;
  final String? idType;
  final String? sex;
  final String? dob;
  final String? sname;
  final String? sub;
  final String? nationality;

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

  String getMiddleName() {
    try {
      List<String> names = sname?.split(',') ?? [""];

      return names.elementAt(1);
    } catch (ex) {
      return " ";
    }
  }

  String getThirdName() {
    try {
      List<String> names = (sname ?? "").split(',');
      if (names.length >= 4) {
        return names.elementAt(2);
      }
    } catch (ex) {
      return " ";
    }
    return " ";
  }

  String getFirstAndLastName() {
    return "${getFirstName()} ${getLastName()}";
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
        return "هوية وطنية";
      } else {
        return "هوية مقيم";
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
      //print(applicantDob);
      HijriCalendar hijriCalendar = HijriCalendar();

      List<String> date = applicantDob.split("/");
      List<int> dateDivided = [];

      for (var element in date) {
        dateDivided.add(int.tryParse(element)!);
      }
      // print(dateDivided);

      String hDate = hijriCalendar.gregorianToHijri(
          dateDivided[2], dateDivided[1], dateDivided[0]);

      String year = hijriCalendar.hYear.toString();
      String month = hijriCalendar.hMonth.toString().length == 1
          ? "0${hijriCalendar.hMonth}"
          : hijriCalendar.hMonth.toString();
      String day = hijriCalendar.hDay.toString().length == 1
          ? "0${hijriCalendar.hDay}"
          : hijriCalendar.hDay.toString();

      if (dateDivided[2] > 1800) {
        return "$year/$month/$day";
      } else {
        String year = dateDivided[2].toString();
        String month = dateDivided[1].toString().length == 1
            ? "0${dateDivided[1]}"
            : dateDivided[1].toString();
        String day = dateDivided[0].toString().length == 1
            ? "0${dateDivided[0]}"
            : dateDivided[0].toString();
        return "$year/$month/$day";
      }
    } catch (ex) {
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
        ? (!phone!.startsWith("0") ? "0${phone!}" : phone!)
        : "";
  }

  String getGender() {
    return sex == "1" ? "male".tr() : "female".tr();
  }

  @override
  List<Object?> get props => [idNo, name, mail, phone];
}
