import 'package:balady_plus/app/features/entry_point/domain/entities/sso_user_info.dart';
import 'package:mapness/shared/providers/app_language.dart';

class UserProfileData {

  const UserProfileData({
    this.imageBase64 = '',
  });
  final String imageBase64;
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

  String getLocalizedFirstAndLastName(Language lang) {
    return '${getLocalizedFirstName(lang)} ${getLocalizedLastName(lang)}';
  }
}
