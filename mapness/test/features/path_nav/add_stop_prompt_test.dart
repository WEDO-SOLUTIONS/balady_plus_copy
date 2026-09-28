import 'package:dgis_map/library.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/entities/routing/route_search_point_mapper.dart';
import 'package:mapness/features/path_nav/add_stop_prompt.dart';
import 'package:mapness/features/routing/providers/current_route.dart';

RouteParamsPointWithLabel _point(int objectId) => RouteParamsPointWithLabel(
  value: RouteParamsPoint(latitude: 24.7 + objectId / 1000, longitude: 46.6, objectId: objectId),
  label: 'point $objectId',
);

const _myLocation = RouteParamsPointWithLabel(value: null, label: 'My location');
const _finishId = 900;

CurrentRouteState _route({int stops = 0, NavigationTripSource source = NavigationTripSource.phone}) =>
    CurrentRouteState(
      points: [_myLocation, for (var i = 1; i <= stops; i++) _point(i), _point(_finishId)],
      navType: RouteSearchOptionsMessage.car,
      route: null,
      tripSource: source,
    );

AddStopPrompt _prompt(CurrentRouteState? route, int objectId) =>
    AddStopPrompt.forPoi(objectId: objectId, navType: RouteSearchOptionsMessage.car, route: route);

void main() {
  group('AddStopPrompt', () {
    test('offers "Add stop" for a new place on a known route', () {
      final prompt = _prompt(_route(stops: 2), 500);

      expect(prompt.showAddStop, isTrue);
      expect(prompt.canAddStop, isTrue);
      expect(prompt.stopsCount, 2);
      expect(prompt.limitReached, isFalse);
      expect(prompt.poiInRoute, isFalse);
    });

    test('hides "Add stop" for the finish and for a stop already on the route', () {
      for (final objectId in [_finishId, 1]) {
        final prompt = _prompt(_route(stops: 1), objectId);

        expect(prompt.poiInRoute, isTrue, reason: 'object $objectId');
        expect(prompt.showAddStop, isFalse, reason: 'object $objectId');
        expect(prompt.canAddStop, isFalse, reason: 'object $objectId');
      }
    });

    test('shows a disabled "Add stop" once the route holds the stop limit', () {
      final prompt = _prompt(_route(stops: maxIntermediateStops), 500);

      expect(prompt.limitReached, isTrue);
      expect(prompt.showAddStop, isTrue);
      expect(prompt.canAddStop, isFalse);
    });

    test('allows the last stop below the limit', () {
      expect(_prompt(_route(stops: maxIntermediateStops - 1), 500).canAddStop, isTrue);
    });

    test('offers nothing when the trip route is unknown', () {
      final prompt = _prompt(null, 500);

      expect(prompt.showAddStop, isFalse);
      expect(prompt.canAddStop, isFalse);
      expect(prompt.tripSource, NavigationTripSource.phone);
    });

    test('keeps who started the trip', () {
      final prompt = _prompt(_route(source: NavigationTripSource.carplay), 500);

      expect(prompt.tripSource, NavigationTripSource.carplay);
    });
  });

  group('CurrentRouteState', () {
    test('withoutPassedStops keeps only the stops still ahead', () {
      final route = _route(stops: 3);

      expect(route.withoutPassedStops(1).points, [_myLocation, _point(3), _point(_finishId)]);
      expect(route.withoutPassedStops(0).points, [_myLocation, _point(_finishId)]);
      expect(route.withoutPassedStops(3), route);
      expect(route.withoutPassedStops(null), route);
    });

    test('withNextStop puts the new stop right after the start', () {
      final route = _route(stops: 2).withNextStop(_point(500));

      expect(route.points, [_myLocation, _point(500), _point(1), _point(2), _point(_finishId)]);
      expect(route.stopsCount, 3);
    });

    test('seedFromNativeTrip fills an empty route and keeps a known one', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(currentRouteProvider.notifier);
      final seeded = _route(stops: 1, source: NavigationTripSource.androidAuto);

      notifier.seedFromNativeTrip(seeded);
      expect(container.read(currentRouteProvider), seeded);

      notifier.seedFromNativeTrip(_route(stops: 3));
      expect(container.read(currentRouteProvider), seeded);
    });
  });

  group('RouteSearchPointMessage.toRouteParamsPoint', () {
    test('treats object id 0 as a bare coordinate', () {
      final point = RouteSearchPointMessage(
        coordinates: GeoPointMessage(latitude: 24.71, longitude: 46.67),
        objectId: DgisObjectIdMessage(objectId: 0, entranceId: 0),
      ).toRouteParamsPoint();

      expect(point, const RouteParamsPoint(latitude: 24.71, longitude: 46.67));
    });

    test('keeps object, entrance and level of a directory object', () {
      final point = RouteSearchPointMessage(
        coordinates: GeoPointMessage(latitude: 24.71, longitude: 46.67),
        objectId: DgisObjectIdMessage(objectId: 70000001, entranceId: 5),
        levelId: LevelIdMessage(value: 3),
      ).toRouteParamsPoint();

      expect(
        point,
        const RouteParamsPoint(latitude: 24.71, longitude: 46.67, objectId: 70000001, entranceId: 5, levelId: 3),
      );
    });
  });
}
