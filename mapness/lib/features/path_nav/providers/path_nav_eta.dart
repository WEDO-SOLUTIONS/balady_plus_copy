import 'dart:async';

import 'package:intl/intl.dart';
import 'package:mapness/entities/path_nav/models/path_nav_eta.dart';
import 'package:mapness/features/app_analytics/app_analytics.dart';
import 'package:mapness/features/city_by_location/city_by_location.dart';
import 'package:mapness/features/path_nav/lib/enums.dart';
import 'package:mapness/features/path_nav/lib/number_formatters.dart';
import 'package:mapness/features/share_eta/models/eta_route_info.dart';
import 'package:mapness/features/share_eta/providers/eta_route_info_provider.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/utils/detach.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'path_nav_eta.g.dart';

@riverpod
class _PathNavEta extends _$PathNavEta {
  @override
  PathNavEta? build() {
    detach(_subscribe(), tag: 'pathNavEta.subscribe');

    return null;
  }

  Future<void> _subscribe() async {
    final mapController = await ref.read(dgisControllerProvider.future);
    double? fullDistance;
    bool halfRouteEventSent = false;
    final stopwatch = Stopwatch()..start();

    final timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      final currentState = state;
      if (currentState == null) {
        return;
      }

      final duration = Duration(seconds: currentState.durationInSeconds);
      final newArrivalTime = DateFormat.Hm().format(DateTime.now().add(duration));

      if (newArrivalTime != currentState.arrivalTime) {
        state = currentState.copyWith(arrivalTime: newArrivalTime);
      }
    });

    final subscription = mapController.naviDashboardEvents.listen((event) async {
      final distance = event.distance.formatDistance();
      final duration = Duration(seconds: event.duration);
      fullDistance ??= event.distance;

      final distanceTraveledPart = (fullDistance! - event.distance) / fullDistance!;
      if (distanceTraveledPart > .5 && !halfRouteEventSent) {
        halfRouteEventSent = true;
        final route = ref.read(etaRouteInfoProvider);
        final currentLocation = ref.read(locationProvider);
        final location = ref.read(cityByLocationProvider.notifier);
        final originCity = await location.getCityByLatLng(lat: route.startPoint?.lat, lng: route.startPoint?.lon);
        final destinationCity = await location.getCityByLatLng(lat: route.endPoint?.lat, lng: route.endPoint?.lon);

        ref
            .read(appAnalyticsProvider)
            .navigationHalfWay(
              originCity: originCity.name,
              destinationCity: destinationCity.name,
              origin: switch (route.startPoint) {
                final EtaRoutePoint point => point.label ?? '${point.lat},${point.lon}',
                _ => '',
              },
              destination: switch (route.endPoint) {
                final EtaRoutePoint point => point.label ?? '${point.lat},${point.lon}',
                _ => '',
              },
              spentTime: stopwatch.elapsed,
              midPoint: currentLocation == null ? '' : '${currentLocation.latitude},${currentLocation.longitude}',
            );
      }

      state = PathNavEta(
        durationInSeconds: event.duration,
        timeEta: event.duration.formatDuration(),
        timeEtaUnits: duration >= const Duration(hours: 1) ? TimeUnits.hours : TimeUnits.min,
        distanceEta: distance.value,
        distanceEtaUnits: distance.unit,
        rawDistance: event.distance,
        arrivalTime: DateFormat.Hm().format(
          DateTime.now().add(duration),
        ),
        spentTime: stopwatch.elapsed,
      );
    });
    ref.onDispose(() {
      subscription.cancel();
      timer.cancel();
    });
  }
}

final pathNavEtaProvider = _pathNavEtaProvider;
