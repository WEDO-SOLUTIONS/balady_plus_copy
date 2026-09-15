import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'regular_poi_active.g.dart';

/// Tracks whether a regular (non-Makkah) POI card is currently open.
/// Used to hide Makkah place markers when viewing a regular POI to avoid overlap.
@Riverpod(keepAlive: true)
class RegularPoiActive extends _$RegularPoiActive {
  @override
  bool build() => false;

  /// Whether a regular POI card is open right now.
  bool get isActive => state;

  set isActive(bool value) {
    // ignore: avoid_print
    print('[MakkahPinDebug] Provider: isActive set to $value, was: $state');
    state = value;
  }
}
