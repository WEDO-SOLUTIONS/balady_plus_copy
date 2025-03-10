import 'dart:convert';

// ignore: depend_on_referenced_packages
import 'package:balady_plus/app/features/map_page/data/model/suggest_history.dart';
import 'package:balady_plus/app/features/quran/data/models/quran_book_mark_item_model.dart';
import 'package:balady_plus/app/features/quran/data/models/quran_book_mark_model.dart';
import 'package:balady_plus/app/features/vd/vd_exports.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../etmam_app/features/_shared_feature_/shared/data/entities/city/city_item.dart';
import '../../../../etmam_app/features/_shared_feature_/shared/data/models/city/city_item_model.dart';
import '../../utils/utils_exports.dart' show LocalStorageKey;
import 'package:balady_plus/app/events_logs/balady_logs.dart';

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
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
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

  Future<void> setIsNafathLogin(String? idToken) async {
    if (idToken != null) {
      await _sharedPreferences?.setString('IsNafathLogin', idToken);
    } else {
      await _sharedPreferences?.remove('IsNafathLogin');
    }
  }

  String? getIsNafathLogin() {
    return _sharedPreferences?.getString('IsNafathLogin');
  }

  Future<void> saveDataOfSplash(String dataOfSplash) async {
    _sharedPreferences?.setString('dataOfSplash', dataOfSplash);
  }

  Map<String, dynamic>? getDataOfSplash() {
    String? data = _sharedPreferences?.getString('dataOfSplash');
    if (data != null) {
      return json.decode(data);
    } else {
      return null;
    }
  }
}

final sharedPrefs = SharedPrefs();
