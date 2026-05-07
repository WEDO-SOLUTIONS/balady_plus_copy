import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:mapness/features/saudi_pass/constants/saudi_pass_constants.dart';
import 'package:mapness/features/saudi_pass/providers/get_profile_preferences_provider.dart';
import 'package:mapness/features/saudi_pass/providers/location_services_enabled_provider.dart';
import 'package:mapness/features/saudi_pass/providers/saudi_pass_city_by_location_riverpod.dart';
import 'package:mapness/features/saudi_pass/providers/saudi_pass_repository_riverpod.dart';
import 'package:mapness/features/saudi_pass/repo/lookups_body.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'by_preference_city_resolver_provider.g.dart';

/// Where the resolved city came from. Useful for tests and analytics.
enum CityResolutionSource { preference, location, fallback }

/// Result of city resolution: the city itself plus how it was determined.
typedef CityResolution = ({City city, CityResolutionSource source});

/// Resolves the city used for the By Preference offers request.
///
/// Priority chain (BRD US-01, Jira BALADY-188):
///   1. Preference City — if the user is logged in, has a city in
///      `/preferences`, and that city is present in `lookups.cities`.
///   2. Current Location City — if location services are enabled and reverse
///      geocoding returns a city present in `lookups.cities`.
///   3. Riyadh — fallback (`kRiyadhCityId`).
///
/// ASSUMPTION (option A): `saudiPassCityIdByLocationProvider` returns
/// `kRiyadhCityId` for both "real Riyadh" and "geocode failure". When a user
/// is physically in Riyadh and has no preference, the resolved city is still
/// Riyadh, but the reported source is `fallback` rather than `location`. This
/// can be tightened in a follow-up by introducing a "raw" provider that
/// returns `String?`. Out of US-01 scope.
@riverpod
Future<CityResolution> byPreferenceCityResolver(Ref ref) async {
  final repository = await ref.read(saudiPassRepositoryProvider.future);
  final lookups = await repository.getAllLookups();

  // 1) Preference City.
  if (CommonProperties.isLoggedIn) {
    try {
      final preferences = await ref.read(getProfilePreferencesProvider.future);
      final preferenceCityId = preferences.cities.firstOrNull?.id;
      if (preferenceCityId != null) {
        final preferenceCity = lookups.cities
            .where((city) => city.id == preferenceCityId)
            .firstOrNull;
        if (preferenceCity != null) {
          return (
            city: preferenceCity,
            source: CityResolutionSource.preference,
          );
        }
      }
    } on Object {
      // Preferences fetch failed — fall through to next priority.
    }
  }

  // 2) Current Location City.
  final servicesEnabled = await ref.read(locationServicesEnabledProvider.future);
  if (servicesEnabled) {
    try {
      final locationCityId = await ref.read(saudiPassCityIdByLocationProvider.future);
      // See class-level ASSUMPTION: Riyadh from this provider is always
      // attributed as fallback for the resolution source.
      if (locationCityId != kRiyadhCityId) {
        final locationCity = lookups.cities
            .where((city) => city.id == locationCityId)
            .firstOrNull;
        if (locationCity != null) {
          return (city: locationCity, source: CityResolutionSource.location);
        }
      }
    } on Object {
      // Geocode failed — fall through to next priority.
    }
  }

  // 3) Fallback to Riyadh.
  final riyadh = lookups.cities.where((city) => city.id == kRiyadhCityId).firstOrNull ??
      // Defensive: lookups should always contain Riyadh in production.
      lookups.cities.first;
  return (city: riyadh, source: CityResolutionSource.fallback);
}
