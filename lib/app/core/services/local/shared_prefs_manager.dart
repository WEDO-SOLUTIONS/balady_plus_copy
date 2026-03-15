import 'dart:convert';

// ignore: depend_on_referenced_packages
import 'package:balady_plus/app/features/location/domain/entities/gis/gis_params.dart';
import 'package:balady_plus/app/features/location/gis_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/utils_exports.dart' show LocalStorageKey;
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class SharedPrefs {
  static SharedPreferences? _sharedPreferences;

  Future<void> init() async {
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
    await _sharedPreferences?.setString("firstDateTime", DateTime.now().toIso8601String());
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

  Future<void> setDeviceHeight(double? height) async {
    await _sharedPreferences?.setDouble('device_height', height ?? 0);
  }

  double? getDeviceHeight() {
    if (_sharedPreferences?.getDouble('device_height') != null) {
      return _sharedPreferences?.getDouble('device_height');
    } else {
      return 0;
    }
  }

  Future<void> setIsFirstLaunchForGame(bool? firstLaunch) async {
    await _sharedPreferences?.setBool('first_launch_game', firstLaunch ?? true);
  }

  void clearAll() {
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

  Future<bool?>? setPrayerSettings(List<String> settings) async =>
      await _sharedPreferences?.setStringList('prayer_settings', settings);

  List<String> getPrayerSettings() =>
      _sharedPreferences?.getStringList('prayer_settings') ??
      // "0" to set all prayer times setting to false
      ["0", "0", "0", "0", "0"];

  /////////////////////////////////////////////////////////////

  Future<void> setIsEkramDriver(bool? isEkramDriver) async {
    if (isEkramDriver != null) {
      await _sharedPreferences?.setBool('isEkramDriver', isEkramDriver);
    } else {
      _sharedPreferences?.remove("isEkramDriver");
    }
  }

  bool? isEkramDriver() {
    return _sharedPreferences?.getBool('isEkramDriver');
  }

  Future<void> setLocationConsent(bool? value) async {
    if (value != null) {
      await _sharedPreferences?.setBool('locationConsent', value);
    } else {
      _sharedPreferences?.remove("locationConsent");
    }
  }

  bool? getLocationConsent() {
    return _sharedPreferences?.getBool('locationConsent');
  }

  Future<void> setChatbotSessionId(String? sessionId) async {
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

  Future<void> setUserLocation(GISParams? item) async {
    if (item != null) {
      await _sharedPreferences?.setString('gis_user_location', json.encode(item.toMap()));
    } else {
      _sharedPreferences?.remove("gis_user_location");
    }
  }

  Future<GISParams?> getUserLocation() async {
    String? bookMarks = _sharedPreferences?.getString('gis_user_location');
    GISParams? model = bookMarks != null
        ? GISParams.fromMap(json.decode(_sharedPreferences?.getString('gis_user_location') ?? ""))
        : null;

    return model;
  }

  Future<void> setUserGISLoaction(GISResponseModel? item) async {
    if (item != null) {
      await _sharedPreferences?.setString('gis_user_data', json.encode(item.toMap()));
    } else {
      _sharedPreferences?.remove("gis_user_data");
    }
  }

  Future<GISResponseModel?> getUserGISData() async {
    String? bookMarks = _sharedPreferences?.getString('gis_user_data');
    GISResponseModel? model = bookMarks != null
        ? GISResponseModel.fromMap(json.decode(_sharedPreferences?.getString('gis_user_data') ?? ""))
        : null;

    return model;
  }

  // Account Selection Methods
  Future<void> saveSelectedDelegator(String? delegatorId) async {
    const key = 'selected_delegator_id';
    if (delegatorId != null) {
      await _sharedPreferences?.setString(key, delegatorId);
    } else {
      await _sharedPreferences?.remove(key);
    }
  }

  Future<void> saveSelectedAgent(String? agentId) async {
    const key = 'selected_agent_id';
    if (agentId != null) {
      await _sharedPreferences?.setString(key, agentId);
    } else {
      await _sharedPreferences?.remove(key);
    }
  }

  String? getSelectedDelegatorId() {
    const key = 'selected_delegator_id';
    return _sharedPreferences?.getString(key);
  }

  String? getSelectedAgentId() {
    const key = 'selected_agent_id';
    return _sharedPreferences?.getString(key);
  }

  Future<void> clearSelectedAccounts() async {
    await _sharedPreferences?.remove('selected_delegator_id');
    await _sharedPreferences?.remove('selected_agent_id');
  }
}

final sharedPrefs = SharedPrefs();
