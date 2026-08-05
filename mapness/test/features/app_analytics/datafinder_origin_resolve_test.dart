import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/features/app_analytics/models/datafinder_models.dart';

/// Locks the 8 BRD `event_source` values produced by [DataFinderOrigin.resolve]
/// from (origin × inNavigation × pathChanging). This is the heart of the
/// DataFinder feature — a regression here silently mis-attributes analytics.
void main() {
  group('DataFinderOrigin.resolve', () {
    test('map origin → Map-Main Page (stays Map-Main through navigation)', () {
      // BRD Map-Main flows 1–5: Map → POI → (Go → Search) → … all stay Map-Main.
      expect(
        DataFinderOrigin.map.resolve(inNavigation: false, pathChanging: false),
        DataFinderSourcePage.mapMainPage,
      );
      expect(
        DataFinderOrigin.map.resolve(inNavigation: true, pathChanging: false),
        DataFinderSourcePage.mapMainPage,
      );
    });

    test('map origin + path changing → Map-Direction-Path Changing', () {
      expect(
        DataFinderOrigin.map.resolve(inNavigation: false, pathChanging: true),
        DataFinderSourcePage.mapDirectionPathChanging,
      );
    });

    test('explore origin → Explore-Main Page', () {
      expect(
        DataFinderOrigin.explore.resolve(inNavigation: false, pathChanging: false),
        DataFinderSourcePage.exploreMainPage,
      );
    });

    test('explore origin + navigation → Explore-Direction', () {
      expect(
        DataFinderOrigin.explore.resolve(inNavigation: true, pathChanging: false),
        DataFinderSourcePage.exploreDirection,
      );
    });

    test('explore origin + path changing → Explore-Direction-Path Changing', () {
      expect(
        DataFinderOrigin.explore.resolve(inNavigation: false, pathChanging: true),
        DataFinderSourcePage.exploreDirectionPathChanging,
      );
      // path changing wins over plain navigation.
      expect(
        DataFinderOrigin.explore.resolve(inNavigation: true, pathChanging: true),
        DataFinderSourcePage.exploreDirectionPathChanging,
      );
    });

    test('routes origin → Routes-Main Page', () {
      expect(
        DataFinderOrigin.routes.resolve(inNavigation: false, pathChanging: false),
        DataFinderSourcePage.routesMainPage,
      );
    });

    test('routes origin + path changing → Routes-Path Changing', () {
      expect(
        DataFinderOrigin.routes.resolve(inNavigation: false, pathChanging: true),
        DataFinderSourcePage.routesPathChanging,
      );
    });

    test('freeRoam origin → Explore-Free Roam (regardless of nav state)', () {
      expect(
        DataFinderOrigin.freeRoam.resolve(inNavigation: false, pathChanging: false),
        DataFinderSourcePage.exploreFreeRoam,
      );
      expect(
        DataFinderOrigin.freeRoam.resolve(inNavigation: true, pathChanging: true),
        DataFinderSourcePage.exploreFreeRoam,
      );
    });

    test('every enumerated event_source value carries the exact BRD string', () {
      expect(DataFinderSourcePage.mapMainPage.value, 'Map-Main Page');
      expect(DataFinderSourcePage.mapDirectionPathChanging.value, 'Map-Direction-Path Changing');
      expect(DataFinderSourcePage.exploreMainPage.value, 'Explore-Main Page');
      expect(DataFinderSourcePage.exploreFreeRoam.value, 'Explore-Free Roam');
      expect(DataFinderSourcePage.exploreDirection.value, 'Explore-Direction');
      expect(DataFinderSourcePage.exploreDirectionPathChanging.value, 'Explore-Direction-Path Changing');
      expect(DataFinderSourcePage.routesMainPage.value, 'Routes-Main Page');
      expect(DataFinderSourcePage.routesPathChanging.value, 'Routes-Path Changing');
    });
  });
}
