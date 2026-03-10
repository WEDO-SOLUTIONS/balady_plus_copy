import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'regular_poi_active.g.dart';

/// Tracks whether a regular (non-Makkah) POI card is currently open.
/// Used to hide Makkah place markers when viewing a regular POI to avoid overlap.
@Riverpod(keepAlive: true)
class RegularPoiActive extends _$RegularPoiActive {
  @override
  bool build() => false;

  void setActive(bool active) {
    // ignore: avoid_print
    print('[MakkahPinDebug] Provider: setActive($active) was: $state');
    state = active;
  }
}
