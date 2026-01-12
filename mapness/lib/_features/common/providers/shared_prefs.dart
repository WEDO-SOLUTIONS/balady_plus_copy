import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shared_prefs.g.dart';

@riverpod
SharedPreferences sharedPrefs(Ref ref) => ref.watch($asyncPrefsLoaderProvider).requireValue;

/// user by [EagerInit]
@riverpod
Future<SharedPreferences> $asyncPrefsLoader(Ref ref) async => SharedPreferences.getInstance();
