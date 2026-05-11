import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:mapness/features/saudi_pass/constants/saudi_pass_constants.dart';
import 'package:mapness/features/saudi_pass/providers/get_profile_preferences_provider.dart';
import 'package:mapness/features/saudi_pass/providers/location_services_enabled_provider.dart';
import 'package:mapness/features/saudi_pass/providers/saudi_pass_city_by_location_riverpod.dart';
import 'package:mapness/features/saudi_pass/providers/saudi_pass_repository_riverpod.dart';
import 'package:mapness/features/saudi_pass/repo/lookups_body.dart';
import 'package:mapness/features/saudi_pass/services/city_resolver/by_preference_city_resolver_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'all_offers_city_resolver_provider.g.dart';

/// Resolves the default city used for the **All Offers** request.
///
/// Priority chain (BRD US-02 / BR-01, Jira BE-188):
///   1. Current Location City — if location services are enabled and reverse
///      geocoding returns a city present in `lookups.cities`.
///   2. Preference City — if the user is logged in, has a city in
///      `/preferences`, and that city is present in `lookups.cities`.
///   3. Riyadh — fallback (`kRiyadhCityId`).
///
/// This is the **default** resolution computed once when the All Offers tab
/// is first opened. The user can subsequently override the city via the
/// All Offers filter (`tapCity()` in `OffersFiltersViewNotifier`); the manual
/// override persists until the filters are reset and is not the resolver's
/// concern.
///
/// `CityResolution` / `CityResolutionSource` are reused from
/// `byPreferenceCityResolverProvider` so that downstream call-sites can treat
/// both resolutions uniformly.
///
/// ASSUMPTION mirrors `byPreferenceCityResolverProvider`:
/// `saudiPassCityIdByLocationProvider` collapses "real Riyadh" and "no fix /
/// geocoder failure" into `kRiyadhCityId`, so a user physically in Riyadh
/// with no preference is attributed as `source: fallback` rather than
/// `source: location`. Tightening this is out of US-02 scope.
@riverpod
Future<CityResolution> allOffersCityResolver(Ref ref) async {
  // Capture all dependency Futures synchronously, before any await. Mirrors
  // the hardening pattern from `byPreferenceCityResolverProvider`: under
  // autoDispose, the resolver can be disposed mid-flight, after which any
  // `ref.read(...)` past an await would throw "Cannot use the Ref ... after
  // it has been disposed". The captured Futures are independent of our `ref`
  // mount state.
  final repositoryFuture = ref.read(saudiPassRepositoryProvider.future);
  final preferencesFuture = CommonProperties.isLoggedIn
      ? ref.read(getProfilePreferencesProvider.future)
      : null;
  final servicesEnabledFuture =
      ref.read(locationServicesEnabledProvider.future);
  final locationCityIdFuture =
      ref.read(saudiPassCityIdByLocationProvider.future);

  final repository = await repositoryFuture;
  final lookups = await repository.getAllLookups();

  // 1) Current Location City.
  final servicesEnabled = await servicesEnabledFuture;
  if (servicesEnabled) {
    try {
      final locationCityId = await locationCityIdFuture;
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

  // 2) Preference City.
  if (preferencesFuture != null) {
    try {
      final preferences = await preferencesFuture;
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

  // 3) Fallback to Riyadh.
  final riyadh =
      lookups.cities.where((city) => city.id == kRiyadhCityId).firstOrNull ??
          // Defensive: lookups should always contain Riyadh in production.
          lookups.cities.first;
  return (city: riyadh, source: CityResolutionSource.fallback);
}
