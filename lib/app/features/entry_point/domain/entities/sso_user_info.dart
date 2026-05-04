import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:equatable/equatable.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mapness/shared/providers/app_language.dart';

enum SsoLoginType { nationalId, otp }

class SsoUserInfo extends Equatable {
  const SsoUserInfo({
    this.name,
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
    this.tnm,
    this.loginType = SsoLoginType.nationalId,
    this.isEmailVerified = false,
    this.isEmailEditable = true,
    this.isSSOLocked = false,
    this.completeProfile = true,
  });

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
  final SsoLoginType loginType;

  // ✅ NEW FLAGS from Backend
  final bool isEmailVerified;
  final bool isEmailEditable;
  final bool isSSOLocked;

  /// Returned by the OTP login API (`MobileLoginVerifyOtp`).
  /// - `true`  → the user completed their profile via OTP login → can edit profile.
  /// - `false` → the user originally signed up through SSO/Nafath → profile is owned
  ///   by SSO and must NOT be editable from the OTP flow.
  /// Defaults to `true` so flows that don't carry this flag (e.g. SSO login)
  /// don't unintentionally lock the UI; SSO editing is already gated by `loginType`.
  final bool completeProfile;

  String getFormattedBirthDate({bool withDash = false}) {
    if (dob != null && dob!.isNotEmpty) {
      String formattedBirthDate = dob!;
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
    if (arName != null && arName!.isNotEmpty) {
      List<String> names = arName!.split(' ');
      return names.isNotEmpty ? names.first : '';
    }
    return '';
  }

  String getLastName() {
    if (arName != null && arName!.isNotEmpty) {
      List<String> names = arName!.split(' ');
      return names.length > 1 ? names.last : '';
    }
    return '';
  }

  String getFirstNameEn() {
    if (enName != null && enName!.isNotEmpty) {
      List<String> names = enName!.split(' ');
      return names.isNotEmpty ? names.first : '';
    }
    return '';
  }

  String getLastNameEn() {
    if (enName != null && enName!.isNotEmpty) {
      List<String> names = enName!.split(' ');
      return names.length > 1 ? names.last : '';
    }
    return '';
  }

  String getLocalizedFirstName(Language language) {
    if (language == Language.arabic) {
      return getFirstName();
    }
    return getFirstNameEn();
  }

  String getLocalizedLastName(Language language) {
    if (language == Language.arabic) {
      return getLastName();
    }
    return getLastNameEn();
  }

  String getMiddleName() {
    try {
      if (sname != null && sname!.isNotEmpty) {
        List<String> names = sname!.split(',');
        if (names.length > 1) {
          return names.elementAt(1);
        }
      }
      return " ";
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
      if (sname != null && sname!.isNotEmpty) {
        List<String> names = sname!.split(',');
        if (names.length >= 4) {
          return names.elementAt(2);
        }
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
      return "${getFirstName()} ${getLastName()}";
    } else {
      return "${getFirstNameEn()} ${getLastNameEn()}";
    }
  }

  String getAbbreviatedName() {
    var firstName = CommonFunctions.isAppAR ? getFirstName() : getFirstNameEn();
    var lastName = CommonFunctions.isAppAR ? getLastName() : getLastNameEn();
    if (firstName.isEmpty && lastName.isEmpty) return '';
    return '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}';
  }

  String getIdType() {
    if (idNo != null && idNo!.isNotEmpty) {
      if (idNo!.startsWith("1")) {
        return "1";
      } else {
        return "3";
      }
    }
    return "";
  }

  String getIdTypeName() {
    if (idType != null && idType!.isNotEmpty) {
      if (idType == "1") {
        return "National_ID".tr();
      } else {
        return "Iqama_ID".tr();
      }
    }
    return "";
  }

  String getHijriBirthDate() {
    String applicantDob = dob ?? "";
    if (applicantDob.isEmpty) return "";

    try {
      HijriCalendar hijriCalendar = HijriCalendar();

      List<String> date = applicantDob.split("/");
      if (date.length != 3) return applicantDob;

      List<int> dateDivided = [];

      for (var element in date) {
        dateDivided.add(int.tryParse(element) ?? 0);
      }

      hijriCalendar.gregorianToHijri(
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
    String email = mail?.replaceAll("\u200e", '').replaceAll("\u200f", '').trim() ?? "";
    return email;
  }

  String getPhone() {
    return phone != null && phone!.isNotEmpty
        ? (!phone!.startsWith("0") ? "0${phone!}" : phone!)
        : "";
  }

  String getGender() {
    return sex == "1" ? "male".tr() : "female".tr();
  }

  String? getFullName() {
    return CommonFunctions.isAppAR ? arName : enName;
  }

  // ✅ Helper methods
  bool get canEditEmail => isEmailEditable && !isSSOLocked && completeProfile;
  bool get canEditProfile => !isSSOLocked && completeProfile;

  factory SsoUserInfo.fromJson(Map<String, dynamic> json) {
    // Helper to get value from multiple possible keys
    String? getValue(String key, {String? alternativeKey, String? alternativeKey2}) {
      if (json.containsKey(key) && json[key] != null && json[key].toString().isNotEmpty) {
        return json[key].toString();
      }
      if (alternativeKey != null && json.containsKey(alternativeKey) && json[alternativeKey] != null && json[alternativeKey].toString().isNotEmpty) {
        return json[alternativeKey].toString();
      }
      if (alternativeKey2 != null && json.containsKey(alternativeKey2) && json[alternativeKey2] != null && json[alternativeKey2].toString().isNotEmpty) {
        return json[alternativeKey2].toString();
      }
      return null;
    }

    SsoLoginType loginType = SsoLoginType.otp;
    if (json.containsKey('tenants') && json['tenants'] != null && json['tenants'] is List && (json['tenants'] as List).isNotEmpty) {
      loginType = SsoLoginType.nationalId;
    }

    // Get email from mail or email field
    String? emailValue = getValue('mail', alternativeKey: 'email');

    // Get Arabic name
    String? firstNameValue = getValue('first_name_arabic', alternativeKey: 'given_name');
    String? lastNameValue = getValue('last_name_arabic', alternativeKey: 'family_name');
    String? arNameValue = getValue('ar_name');
    if (arNameValue == null && firstNameValue != null && lastNameValue != null) {
      arNameValue = '$firstNameValue $lastNameValue';
    }

    // Get English name
    String? enNameValue = getValue('en_name');
    if (enNameValue == null) {
      String? givenName = getValue('given_name');
      String? familyName = getValue('family_name');
      if (givenName != null && familyName != null) {
        enNameValue = '$givenName $familyName';
      }
    }

    return SsoUserInfo(
      sub: getValue('sub'),
      name: getValue('name'),
      phone: getValue('phone', alternativeKey: 'phone_number'),
      mail: emailValue,
      arName: arNameValue,
      enName: enNameValue,
      idNo: getValue('id_no'),
      nid: getValue('nid'),
      idType: getValue('id_type'),
      sex: getValue('sex'),
      dob: getValue('dob'),
      sname: getValue('sname'),
      nationality: getValue('nationality'),
      tnm: getValue('tnm'),
      loginType: loginType,
      isEmailVerified: json['isEmailVerified'] == true,
      isEmailEditable: json['isEmailEditable'] ?? true,
      isSSOLocked: json['isSSOLocked'] ?? false,
      // NOTE: `complete_profile` is ONLY returned by `MobileLoginVerifyOtp`
      // (captured via `LoginDataModel.completeProfile` in the OTP login flow).
      // The `/api/user/userinfo` endpoint does NOT return it, so we default to
      // `true` here. Callers that refresh the profile from `userinfo` MUST
      // preserve the original value via `copyWith(completeProfile: ...)`.
      completeProfile: true,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = mail;
    data['name'] = name;
    data['phone'] = phone;
    data['nameAr'] = arName;
    data['token'] = CommonProperties.token;
    data['isEmailVerified'] = isEmailVerified;
    data['isEmailEditable'] = isEmailEditable;
    data['isSSOLocked'] = isSSOLocked;
    data['complete_profile'] = completeProfile;
    return data;
  }

  @override
  List<Object?> get props => [
    idNo,
    name,
    mail,
    phone,
    nationality,
    isEmailVerified,
    isEmailEditable,
    isSSOLocked,
    completeProfile,
  ];

  SsoUserInfo copyWith({
    String? name,
    String? phone,
    String? mail,
    String? arName,
    String? enName,
    String? idNo,
    String? nid,
    String? idType,
    String? sex,
    String? dob,
    String? sname,
    String? sub,
    String? nationality,
    String? tnm,
    SsoLoginType? loginType,
    bool? isEmailVerified,
    bool? isEmailEditable,
    bool? isSSOLocked,
    bool? completeProfile,
  }) {
    return SsoUserInfo(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      mail: mail ?? this.mail,
      arName: arName ?? this.arName,
      enName: enName ?? this.enName,
      idNo: idNo ?? this.idNo,
      nid: nid ?? this.nid,
      idType: idType ?? this.idType,
      sex: sex ?? this.sex,
      dob: dob ?? this.dob,
      sname: sname ?? this.sname,
      sub: sub ?? this.sub,
      nationality: nationality ?? this.nationality,
      tnm: tnm ?? this.tnm,
      loginType: loginType ?? this.loginType,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isEmailEditable: isEmailEditable ?? this.isEmailEditable,
      isSSOLocked: isSSOLocked ?? this.isSSOLocked,
      completeProfile: completeProfile ?? this.completeProfile,
    );
  }
}