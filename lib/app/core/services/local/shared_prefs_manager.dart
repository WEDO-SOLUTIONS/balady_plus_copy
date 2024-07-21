import 'dart:convert';

// ignore: depend_on_referenced_packages
import 'package:balady_plus/app/features/map_page/data/model/suggest_history.dart';
import 'package:balady_plus/app/features/quran/data/models/quran_book_mark_item_model.dart';
import 'package:balady_plus/app/features/quran/data/models/quran_book_mark_model.dart';
import 'package:balady_plus/app/features/vd/vd_exports.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../etmam_app/features/_shared_feature_/shared/data/entities/city/city_item.dart';
import '../../../../etmam_app/features/_shared_feature_/shared/data/models/city/city_item_model.dart';
import '../../../../etmam_app/features/etmam_entry_point/data/models/profile_model.dart';
import '../../../features/_shared_feature_/shared_feature_exports.dart'
    show AuthDataModel;
import '../../../features/entry_point/data/models/sso_token_model.dart';
import '../../../features/entry_point/data/models/sso_user_info_model.dart';
import '../../../features/vd/domain/entities/gis/gis_params.dart';
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

  void setFirstDateTime() async {
    await _sharedPreferences?.setString(
        "firstDateTime", DateTime.now().toIso8601String());
  }

  String? getFirstDateTime() {
    return _sharedPreferences?.getString("firstDateTime");
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
    print(_sharedPreferences?.getString('sso_token'));
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

  Future<bool> saveQuranBookMark(QuranBookMarkItemModel item) async {
    String? bookMarks = _sharedPreferences?.getString('quran_book_marks');
    QuranBookMarkModel model = bookMarks != null
        ? QuranBookMarkModel.fromJson(
            _sharedPreferences?.getString('quran_book_marks') ?? "")
        : QuranBookMarkModel(items: []);

    bool isAdded = false;
    if (model.items?.contains(item) ?? false) {
      model.items?.remove(item);
      isAdded = false;
    } else {
      model.items?.add(item);
      isAdded = true;
    }
    await _sharedPreferences?.setString("quran_book_marks", model.toJson());
    return Future.value(isAdded);
  }

  Future<bool> checkBookMark(QuranBookMarkItemModel item) async {
    String? bookMarks = _sharedPreferences?.getString('quran_book_marks');
    QuranBookMarkModel model = bookMarks != null
        ? QuranBookMarkModel.fromJson(
            _sharedPreferences?.getString('quran_book_marks') ?? "")
        : QuranBookMarkModel(items: []);

    if (model.items?.contains(item) ?? false) {
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }

  Future<QuranBookMarkModel> getQuranBookMark() async {
    print(_sharedPreferences?.getString('quran_book_marks'));
    QuranBookMarkModel model = QuranBookMarkModel.fromJson(
        _sharedPreferences?.getString('quran_book_marks') ?? "");

    return Future.value(model);
  }

  setPrayerSettings(List<String> settings) async =>
      await _sharedPreferences?.setStringList('prayer_settings', settings);

  List<String> getPrayerSettings() =>
      _sharedPreferences?.getStringList('prayer_settings') ??
      // "0" to set all prayer times setting to false
      [
        "0",
        "0",
        "0",
        "0",
        "0",
      ];

  /** Etmam   */
  setUserProfile(ProfileModel? profile) async {
    if (profile != null) {
      await _sharedPreferences?.setString(
          'user_profile', json.encode(profile.toJson()));
    } else {
      _sharedPreferences?.remove("user_profile");
    }
  }

  ProfileModel? getUserProfile() {
    if (_sharedPreferences?.getString('user_profile') != null) {
      ProfileModel token = ProfileModel.fromMap(
          json.decode(_sharedPreferences?.getString('user_profile') ?? ""));
      return token;
    }
    return null;
  }

  setCitiesList(List<CityItemModel>? items) async {
    if (items != null) {
      await _sharedPreferences?.setString('cities_list',
          json.encode(List<dynamic>.from(items.map((x) => x.toJson()))));
    } else {
      _sharedPreferences?.remove("cities_list");
    }
  }

  List<CityItem>? getCitiesList() {
    var text = _sharedPreferences?.getString('cities_list');
    var data;
    if (text != null) data = json.decode(text);

    if (data != null) {
      List<CityItem>? cities =
          data.map<CityItemModel>((x) => CityItemModel.fromMap(x)).toList();
      return cities;
    }
    return null;
  }

  setCurrentCity(CityItemModel? item) async {
    if (item != null) {
      await _sharedPreferences?.setString(
          'current_city', json.encode(item.toJson()));
    } else {
      _sharedPreferences?.remove("current_city");
    }
  }

  CityItemModel? getCity() {
    if (_sharedPreferences?.getString('current_city') != null) {
      CityItemModel token = CityItemModel.fromMap(
          json.decode(_sharedPreferences?.getString('current_city') ?? ""));
      return token;
    }
    return null;
  }

  setUserLocation(GISParams? item) async {
    if (item != null) {
      await _sharedPreferences?.setString(
          'gis_user_location', json.encode(item.toMap()));
    } else {
      _sharedPreferences?.remove("gis_user_location");
    }
  }

  Future<GISParams?> getUserLocation() async {
    String? bookMarks = _sharedPreferences?.getString('gis_user_location');
    GISParams? model = bookMarks != null
        ? GISParams.fromMap(json
            .decode(_sharedPreferences?.getString('gis_user_location') ?? ""))
        : null;

    return model;
  }

  setUserGISLoaction(GISResponseModel? item) async {
    if (item != null) {
      await _sharedPreferences?.setString(
          'gis_user_data', json.encode(item.toMap()));
    } else {
      _sharedPreferences?.remove("gis_user_data");
    }
  }

  Future<GISResponseModel?> getUserGISData() async {
    String? bookMarks = _sharedPreferences?.getString('gis_user_data');
    GISResponseModel? model = bookMarks != null
        ? GISResponseModel.fromMap(
            json.decode(_sharedPreferences?.getString('gis_user_data') ?? ""))
        : null;

    return model;
  }

  /////////////////////////////////////////////////////////////
  setSuggestResultHistory(Map<int, SuggestHistory> data) async {
    Map<String, Map<String, dynamic>> dataMap = {};
    for (var element in data.keys) {
      dataMap[element.toString()] = data[element]!.toJson();
    }
    await _sharedPreferences?.setString(
      'SuggestHistory',
      json.encode(dataMap),
    );
  }

  Future<Map<int, SuggestHistory>> getSuggestResultHistory() async {
    String? data = _sharedPreferences?.getString('SuggestHistory');

    Map<int, SuggestHistory> dataS = {};
    if (data != null) {
      Map<String, dynamic> dataMap = json.decode(data);
      for (var element in dataMap.keys) {
        dataS[int.parse(element)] = SuggestHistory.fromJson(dataMap[element]!);
      }
    }

    return dataS;
  }

  setIsEkramDriver(bool? isEkramDriver) async {
    if (isEkramDriver != null) {
      await _sharedPreferences?.setBool('isEkramDriver', isEkramDriver);
    } else {
      _sharedPreferences?.remove("isEkramDriver");
    }
  }

  bool? isEkramDriver() {
    return _sharedPreferences?.getBool('isEkramDriver');
  }

  setLocationConsent(bool? value) async {
    if (value != null) {
      await _sharedPreferences?.setBool('locationConsent', value);
    } else {
      _sharedPreferences?.remove("locationConsent");
    }
  }

  bool? getLocationConsent() {
    return _sharedPreferences?.getBool('locationConsent');
  }

  setChatbotSessionId(String? sessionId) async {
    if (sessionId != null) {
      _sharedPreferences?.setString('chatbot_session_id', sessionId);
    } else {
      _sharedPreferences?.remove("chatbot_session_id");
    }
  }

  String? getChatbotSessionId() {
    return _sharedPreferences?.getString('chatbot_session_id');
  }
}

final sharedPrefs = SharedPrefs();
