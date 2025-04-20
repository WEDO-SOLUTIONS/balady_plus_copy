import 'package:balady_plus/app/features/entry_point/domain/entities/sso_user_info.dart';
import 'package:flutter/foundation.dart';
import 'package:mapness/shared/providers/app_language.dart';

@immutable
class UserProfileData {
  final String imageBase64;

  const UserProfileData({
    this.imageBase64 = '',
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is UserProfileData && other.imageBase64 == imageBase64;
  }

  @override
  int get hashCode => imageBase64.hashCode;
}

extension LocalizedName on SsoUserInfo {
  String getLocalizedFirstName(Language lang) {
    String? sname;
    if (lang == Language.arabic) {
      sname = arName;
    } else {
      sname = enName;
    }

    final names = sname?.split(' ') ?? [''];

    return names.first;
  }

  String getLocalizedLastName(Language lang) {
    String? sname;
    if (lang == Language.arabic) {
      sname = arName;
    } else {
      sname = enName;
    }

    final names = sname?.split(' ') ?? [''];

    return names.last;
  }

  String getLocalizedFirstAndLastName(Language lang) => '${getLocalizedFirstName(lang)} ${getLocalizedLastName(lang)}';

  String getLocalizedAbbreviatedName(Language lang) {
    final firstName = getLocalizedFirstName(lang);
    final lastName = getLocalizedLastName(lang);
    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      return '${firstName[0]}${lastName[0]}';
    } else if (firstName.isNotEmpty) {
      return firstName[0];
    } else if (lastName.isNotEmpty) {
      return lastName[0];
    }
    return '';
  }
}
