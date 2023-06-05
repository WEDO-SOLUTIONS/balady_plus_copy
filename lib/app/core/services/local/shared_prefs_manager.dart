import 'dart:convert';

// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

import '../../../features/_shared_feature_/shared_feature_exports.dart'
    show AuthDataModel;
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
}

final sharedPrefs = SharedPrefs();
