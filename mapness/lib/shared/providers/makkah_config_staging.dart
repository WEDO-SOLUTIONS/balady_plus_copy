import 'package:mapness/shared/config/environment_config.dart';

/// URLs for Makkah configuration endpoints.
///
/// Uses staging URLs for non-production environments (urbiDev, momrahStaging).
/// Uses production URLs for production environments (momrahProd, urbiPreprod).
class MakkahConfigUrls {
  MakkahConfigUrls._();

  static const _baseUrl =
      'https://axownvq9lhmx.objectstorage.me-jeddah-1.oci.customer-oci.com/p/ykBWL3zo7MRNak-LnF9W-8rZF2d-_kKyONU0mgfTtCCyrOlf_Y8JJVmfFPXzthM6/n/axownvq9lhmx/b/prod-makkah-ptv/o';

  /// Production URL for places.json
  static const placesUrlProd = '$_baseUrl/places.json';

  /// Staging URL for places.json
  static const placesUrlStaging = '$_baseUrl/staging/places.json';

  /// Production URL for config.json
  static const configUrlProd = '$_baseUrl/config.json';

  /// Staging URL for config.json
  static const configUrlStaging = '$_baseUrl/staging/config.json';

  /// Check if environment should use staging URLs.
  /// Only momrahProd uses production URLs, all others use staging.
  static bool isStagingEnv(DgisEnv env) => env != DgisEnv.momrahProd;

  /// Get places URL based on environment
  static String getPlacesUrl(DgisEnv env) => isStagingEnv(env) ? placesUrlStaging : placesUrlProd;

  /// Get config URL based on environment
  static String getConfigUrl(DgisEnv env) => isStagingEnv(env) ? configUrlStaging : configUrlProd;
}
