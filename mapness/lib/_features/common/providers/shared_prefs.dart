import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shared_prefs.g.dart';

@riverpod
SharedPreferences sharedPrefs(SharedPrefsRef ref) => ref.watch($asyncPrefsLoaderProvider).requireValue;

/// user by [EagerInit]
@riverpod
Future<SharedPreferences> $asyncPrefsLoader($AsyncPrefsLoaderRef ref) async => SharedPreferences.getInstance();
