class BaldayDeeplink {
  // General keys
  static const String momrahIdKey = 'momrah-id';
  static const String latitudeKey = 'lat';
  static const String longitudeKey = 'lon';
  static const String fieldsKey = 'fields';
  static const String keyKey = 'key';
  static const String qKey = 'q';
  static const String typeKey = 'type';
  static const String dgisObjectIdKey = 'dgis-object-id';
  static const String baseAuthority = 'plus.balady.gov.sa';
  static const String streamId = 'streamId';
  static const String tokenId = 'tokenId';

  /// S-19 (R-80/R-81): the anonymous recipient-facing secret for a
  /// temporary location/ETA share link — distinct from [tokenId]/[streamId]
  /// above, which are `share_eta`'s own, unrelated engine.
  static const String shareTokenKey = 'token';
  static const String homeWidget = 'homeWidget';
  static const String serviceKey = 'serviceKey';
  static const String miniAppPath = 'pt';
  static const String miniAppItemId = 'dt_Id';
  static const String cityEvent = 'cityEvent';

  /// Draw a route from the current location to the point in [qKey].
  /// Example: `baladyplus://?q=24.7009,46.6760&navigate=yes`
  static const String navigateKey = 'navigate';

  /// Free-text search query, used for addresses coming from other apps
  /// (e.g. a contact's address). Example: `baladyplus://?s=King%20Fahd%20Road`
  static const String searchTextKey = 's';

  /// Parsed permissively so partner integrations that send `1`/`true`, or the
  /// bare `?navigate` flag, behave the same as the documented `navigate=yes`.
  /// An explicit negative value (`no`/`false`/`0`) keeps navigation disabled.
  static bool isNavigateEnabled(String? value) {
    if (value == null) {
      return false;
    }
    final normalized = value.trim().toLowerCase();
    return normalized.isEmpty || normalized == 'yes' || normalized == 'true' || normalized == '1';
  }

  static String get baseAuthorityWithScheme => 'https://$baseAuthority';

  // By coordinates
  static const vendorConfigKey = 'dgis/native-sdk/keys/user_web_api_key_for_on_premise';
  static const catalogKey = 'Modules/directory/webapi_url';
  static String geocodeUrl(String catalogApi) => '$catalogApi/3.0/items/geocode';
  static String searchBoundRegion(String catalogApi) => '$catalogApi/2.0/region/search';

  static const String fieldsValuePoints = 'items.point';
  static const String fieldsValueBounds = 'items.bounds';
  static const String typeAdmDivCity = 'adm_div.city';

  // Momrah
  static String twinsUrl(String twinsApi) => '$twinsApi/twins/search/partners';
  static const String momrahTwinsKey = 'dfdd94df-49f9-45df-84ec-e8870ebdb9a0';
  static const String momrahPartnerCodeKey = 'partner_code';
  static const String momrahPartnerCodeValue = 'momrah';
  static const String momrahPartnerCodeId = 'partner_id';

  // POI
  static String get basePoiUri => '$baseAuthorityWithScheme/#/poi-map';
  static String get baseGeoSharingUri => '$baseAuthorityWithScheme/#/geo-sharing';

  /// S-19: deliberately a distinct path segment from [baseGeoSharingUri]
  /// (`share_eta`'s own, unrelated link shape) so `entry_point.dart`'s
  /// dispatch can tell the two apart unambiguously without sniffing query
  /// param shapes.
  static String get baseShareUri => '$baseAuthorityWithScheme/#/share';

  // Helper
  static String urlWithQuery(String baseUrl, Map<String, dynamic> map) {
    final pairs = <String>[];
    map.forEach((key, value) {
      pairs.add('$key=$value');
    });
    return '$baseUrl?${pairs.join('&')}';
  }
}
