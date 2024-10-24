// ignore: depend_on_referenced_packages
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../features/select_activity/domain/entities/activites_page_params.dart';
import '../../../features/select_activity/domain/entities/activity_details_page_params.dart';
import '../../utils/utils_exports.dart' show LocalStorageKey;

class SharedPrefs {
  static SharedPreferences? _sharedPreferences;

  static init() async {
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

  bool saveRecentlyOpened(ActivityDetailsPageParams params) {
    String encode = json.encode(params.toJson());

    List<String> list =
        _sharedPreferences?.getStringList("SmartAdvisorRecentActivites") ?? [];

    print("LIIST ${list}");
    List<ActivityDetailsPageParams> l = list
        .map((e) => ActivityDetailsPageParams.fromJson(json.decode(e)))
        .toList();

    bool isExists = false;
    l.forEach((e) {
      if (e.activityId?.id == params.activityId?.id) {
        isExists = true;
      }
    });
    print("LIIST ${isExists}");

    if (isExists != true) {
      if (list.length < 5) {
        print(encode);
        list.add(encode);
      } else {
        list.removeLast();
        list.insert(0, encode);
      }
      print("LIIST ${list}");

      try {
        _sharedPreferences?.setStringList("SmartAdvisorRecentActivites", list);
      } catch (ex) {
        print(ex);
      }
    }
    return true;
  }

  List<ActivityDetailsPageParams> getRecentlyOpened() {
    try {
      List<String> list =
          _sharedPreferences?.getStringList("SmartAdvisorRecentActivites") ??
              [];

      return list
          .map((e) => ActivityDetailsPageParams.fromJson(json.decode(e)))
          .toList();
    } catch (ex) {
      print(ex);
      return [];
    }
  }
}

final sharedPrefs = SharedPrefs();
