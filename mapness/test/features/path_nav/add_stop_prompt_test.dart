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

// Far from every test point, so only the object id can match.
const _elsewhere = LatLng(latitude: 21.5, longitude: 39.2);

AddStopPrompt _prompt(CurrentRouteState? route, int objectId, {LatLng position = _elsewhere}) =>
    AddStopPrompt.forPoi(objectId: objectId, position: position, navType: RouteSearchOptionsMessage.car, route: route);

// A finish picked on a head unit by coordinates only: native object id 0.
CurrentRouteState _coordinateFinishRoute() => const CurrentRouteState(
  points: [
    _myLocation,
    RouteParamsPointWithLabel(value: RouteParamsPoint(latitude: 24.7, longitude: 46.6), label: 'Destination'),
  ],
  navType: RouteSearchOptionsMessage.car,
  route: null,
  tripSource: NavigationTripSource.carplay,
);

// ~0.00009 deg of latitude is ~10 m, ~0.0005 deg is ~55 m.
const _tenMetersFromFinish = LatLng(latitude: 24.70009, longitude: 46.6);
const _fiftyFiveMetersFromFinish = LatLng(latitude: 24.7005, longitude: 46.6);

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

    test('shows a disabled "Add stop" while the trip route is not rebuilt yet', () {
      final prompt = _prompt(null, 500);

      expect(prompt.showAddStop, isTrue);
      expect(prompt.canAddStop, isFalse);
      expect(prompt.tripSource, NavigationTripSource.phone);
    });

    test('a finish without an object matches a place tapped within 30 m', () {
      final near = _prompt(_coordinateFinishRoute(), 500, position: _tenMetersFromFinish);
      final far = _prompt(_coordinateFinishRoute(), 500, position: _fiftyFiveMetersFromFinish);

      expect(near.poiInRoute, isTrue);
      expect(near.showAddStop, isFalse);
      expect(far.poiInRoute, isFalse);
      expect(far.canAddStop, isTrue);
    });

    test('the POI position from the directory can reveal the coordinate-only finish', () {
      final prompt = _prompt(_coordinateFinishRoute(), 500, position: _fiftyFiveMetersFromFinish);

      final atFinish = prompt.withPoiPosition(
        GeoPointWithElevationMessage(latitude: 24.7, longitude: 46.6, elevation: 0),
      );
      expect(atFinish.showAddStop, isFalse);
      expect(prompt.withPoiPosition(null), same(prompt));
    });

    test('a finish with an object is matched by object id, not by distance', () {
      final route = _route();
      final finish = route.finishPoint!.value!;
      final prompt = _prompt(
        route,
        500,
        position: LatLng(latitude: finish.latitude, longitude: finish.longitude),
      );

      expect(prompt.poiInRoute, isFalse);
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

    test('withStopBeforeFinish adds the stop right before the finish', () {
      final route = _route(stops: 2).withStopBeforeFinish(_point(500));

      expect(route.points, [_myLocation, _point(1), _point(2), _point(500), _point(_finishId)]);
      expect(route.stopsCount, 3);
    });

    test('a stop added after passing others keeps only the stops ahead', () {
      final route = _route(stops: 3).withoutPassedStops(1).withStopBeforeFinish(_point(500));

      expect(route.points, [_myLocation, _point(3), _point(500), _point(_finishId)]);
    });

    test('renameFinish names the finish only while it is still the route finish', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(currentRouteProvider.notifier)..seedFromNativeTrip(_coordinateFinishRoute());
      final finish = _coordinateFinishRoute().finishPoint!.value!;

      notifier.renameFinish(const RouteParamsPoint(latitude: 1, longitude: 1), 'Elsewhere');
      expect(container.read(currentRouteProvider)!.finishPoint!.label, 'Destination');

      notifier.renameFinish(finish, 'Kingdom Centre');
      expect(
        container.read(currentRouteProvider)!.finishPoint,
        RouteParamsPointWithLabel(value: finish, label: 'Kingdom Centre'),
      );
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
