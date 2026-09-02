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
  static const String homeWidget = 'homeWidget';
  static const String serviceKey = 'serviceKey';
  static const String miniAppPath = 'pt';
  static const String miniAppItemId = 'dt_Id';
  static const String cityEvent = 'cityEvent';

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

  // Helper
  static String urlWithQuery(String baseUrl, Map<String, dynamic> map) {
    final pairs = <String>[];
    map.forEach((key, value) {
      pairs.add('$key=$value');
    });
    return '$baseUrl?${pairs.join('&')}';
  }
}
