import 'dart:convert';

// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

import '../../../features/_shared_feature_/shared_feature_exports.dart'
    show AuthDataModel;
import '../../../features/entry_point/data/models/sso_token_model.dart';
import '../../../features/entry_point/data/models/sso_user_info_model.dart';
import '../../utils/utils_exports.dart' show LocalStorageKey;

class SharedPrefs {
  static SharedPreferences? _sharedPreferences;

  init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
  }

  void setIsFirstLaunch(bool? firstLaunch) async {
    const key = LocalStorageKey.firstLaunch;
    await _sharedPreferences?.setBool(key, firstLaunch ?? true);
  }

  bool? getIsFirstLaunch() {
    const key = LocalStorageKey.firstLaunch;
    if (_sharedPreferences?.getBool(key) != null) {
      return _sharedPreferences?.getBool(key);
    } else {
      return true;
    }
  }

  void setAuthData(AuthDataModel? authData) async {
    const key = LocalStorageKey.auth;
    if (authData != null) {
      await _sharedPreferences?.setString(key, authData.toJson());
    } else {
      _sharedPreferences?.remove(key);
    }
  }

  AuthDataModel? getAuthData() {
    const key = LocalStorageKey.auth;
    if (_sharedPreferences?.getString(key) != null) {
      AuthDataModel token = AuthDataModel.fromMap(
          json.decode(_sharedPreferences?.getString(key) ?? ""));

      return token;
    }
    return null;
  }

  setSSOToken(SSOTokenModel? ssoToken) async {
    if (ssoToken != null) {
      await _sharedPreferences?.setString(
          'sso_token', json.encode(ssoToken.toJson()));
    } else {
      _sharedPreferences?.remove("sso_token");
    }
  }

  SSOTokenModel? getSSOToken() {
    if (_sharedPreferences?.getString('sso_token') != null) {
      SSOTokenModel token = SSOTokenModel.fromMap(
          json.decode(_sharedPreferences?.getString('sso_token') ?? ""));

      return token;
    }
    return null;
  }

  setSSOUserProfile(SsoUserInfoModel? profile) async {
    if (profile != null) {
      await _sharedPreferences?.setString(
          'sso_user_profile', json.encode(profile.toJson()));
    } else {
      _sharedPreferences?.remove("sso_user_profile");
    }
  }

  SsoUserInfoModel? getSSOUserProfile() {
    if (_sharedPreferences?.getString('sso_user_profile') != null) {
      SsoUserInfoModel token = SsoUserInfoModel.fromJson(
          json.decode(_sharedPreferences?.getString('sso_user_profile') ?? ""));
      return token;
    }
    return null;
  }

  bool? getIsFirstLaunchForGame() {
    if (_sharedPreferences?.getBool('first_launch_game') != null) {
      return _sharedPreferences?.getBool('first_launch_game');
    } else {
      return true;
    }
  }

  setDeviceHeight(double? height) async {
    await _sharedPreferences?.setDouble('device_height', height ?? 0);
  }

  double? getDeviceHeight() {
    if (_sharedPreferences?.getDouble('device_height') != null) {
      return _sharedPreferences?.getDouble('device_height');
    } else {
      return 0;
    }
  }

  setIsFirstLaunchForGame(bool? firstLaunch) async {
    await _sharedPreferences?.setBool('first_launch_game', firstLaunch ?? true);
  }

  setAppCookie(String? cookie) {
    if (cookie != null) {
      _sharedPreferences?.setString("app_cookie", cookie);
    } else {
      _sharedPreferences?.remove("app_cookie");
    }
  }

  String getAppCookie() {
    return _sharedPreferences?.getString("app_cookie") ?? "";
  }

  setLicenseClientImage(String? img) async {
    if (img != null) {
      _sharedPreferences?.setString('license_client_image', img);
    } else {
      _sharedPreferences?.remove("license_client_image");
    }
  }

  String? getLicenseClientImage() {
    return _sharedPreferences?.getString('license_client_image');
  }

  setIsUserCOAuthorized(bool? isAuth) async {
    if (isAuth != null) {
      _sharedPreferences?.setBool('is_user_CO_authorized', isAuth);
    } else {
      _sharedPreferences?.remove("is_user_CO_authorized");
    }
  }

  bool? getIsUserCOAuthorized() {
    return _sharedPreferences?.getBool('is_user_CO_authorized');
  }

  clearAll() {
    _sharedPreferences?.clear();
  }

  void storeGuestInfo(String? firstName, String? lastName, String? mobile) {
    try {
      if (firstName != null) {
        _sharedPreferences?.setString('guestFirstName', firstName);
      } else {
        _sharedPreferences?.remove("guestFirstName");
      }
      if (lastName != null) {
        _sharedPreferences?.setString('guestLastName', lastName);
      } else {
        _sharedPreferences?.remove("guestLastName");
      }
      if (mobile != null) {
        _sharedPreferences?.setString('guestMobile', mobile);
      } else {
        _sharedPreferences?.remove("guestMobile");
      }
    } catch (_) {}
  }

  String? getGuestFirstName() {
    return _sharedPreferences?.getString('guestFirstName');
  }

  String? getGuestLastName() {
    return _sharedPreferences?.getString('guestLastName');
  }

  String? getGuestMobile() {
    return _sharedPreferences?.getString('guestMobile');
  }
}

final sharedPrefs = SharedPrefs();
