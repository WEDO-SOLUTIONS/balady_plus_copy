import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'share_my_location_launch_intent.g.dart';

enum ShareMyLocationLaunchMode {
  none,
  liveLocationOptions,
}

@Riverpod(keepAlive: true)
class ShareMyLocationLaunchIntent extends _$ShareMyLocationLaunchIntent {
  @override
  ShareMyLocationLaunchMode build() => ShareMyLocationLaunchMode.none;

  void requestLiveLocationOptions() => state = ShareMyLocationLaunchMode.liveLocationOptions;

  ShareMyLocationLaunchMode consume() {
    final current = state;
    state = ShareMyLocationLaunchMode.none;
    return current;
  }
}
