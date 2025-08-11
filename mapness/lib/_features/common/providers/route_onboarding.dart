import 'package:hive_flutter/hive_flutter.dart';
import 'package:mapness/shared/providers/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'route_onboarding.g.dart';

@riverpod
class RouteOnboarding extends _$RouteOnboarding {
  Box<dynamic>? _box;

  @override
  Future<bool> build() async {
    _box = await ref.watch(hiveProvider('onboarding').future);
    return _box?.get('route', defaultValue: false) as bool;
  }

  Future<void> setShown({required bool value}) async {
    _box = await ref.read(hiveProvider('onboarding').future);
    await _box?.put('route', value);
    state = AsyncData(value);
  }
}
