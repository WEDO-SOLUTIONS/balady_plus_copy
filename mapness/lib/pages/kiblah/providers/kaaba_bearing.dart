import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'kaaba_bearing.g.dart';

final GeoPointMessage kaabaLocation = GeoPointMessage(latitude: 21.422512, longitude: 39.82618);

@riverpod
class KaabaBearing extends _$KaabaBearing {
  Timer? _timer;

  void _updateKaabState() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 15), (timer) {
      if (state == null) {
        ref.invalidate(locationProvider);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  double? build() {
    final dgisController = ref.watch(dgisControllerProvider);

    ref
      ..invalidate(locationProvider)
      ..listen(
        locationProvider,
        (_, next) async {
          if (next != null) {
            state = await dgisController.value!
                .pointBearing(GeoPointMessage(latitude: next.latitude, longitude: next.longitude), kaabaLocation);
          } else {
            _updateKaabState();
          }
        },
      )
      ..onDispose(() {
        _timer?.cancel();
      });

    _updateKaabState();
    return null;
  }
}
