import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPrefs extends Mock implements SharedPreferences {
  Map<String, dynamic> values = {};

  @override
  Future<bool> setBool(String key, bool value) {
    values[key] = value;

    return Future<bool>.value(true);
  }

  @override
  bool? getBool(String key) => values[key];
}
