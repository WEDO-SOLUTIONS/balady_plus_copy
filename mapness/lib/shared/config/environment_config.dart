import 'package:mapness/entities/city_event/city_event.dart';

enum DgisEnv { urbiDev, momrahStaging, momrahProd, urbiPreprod }

extension DgisEnvExt on DgisEnv {
  EnvironmentConfig getConfig() => switch (this) {
    DgisEnv.urbiDev => EnvironmentConfig.urbiDev(),
    DgisEnv.momrahProd => EnvironmentConfig.momrahProd(),
    DgisEnv.momrahStaging => EnvironmentConfig.momrahStaging(),
    DgisEnv.urbiPreprod => EnvironmentConfig.urbiPreProd(),
  };
}

class EnvironmentConfig {
  final String url;
  final String meteoblue;
  final String weatherApi;
  final String jobsApi;
  final String twinsApi;
  final String? proxy;
  final String baseApiDomain;
  final String shareEtaApi;
  final String? shortLinkUrl;
  final String? shortLinkApiKey;

  // TODO(Demezy): very probably will be changed in the future
  final String feedbackApi;
  final bool appFeedbackEnable;
  final String appFeedbackApi;
  final String baladyBusinessUrl;
  final String bssApi;
  final String saudiPassApi;

  // TODO: replace with real per-env URLs once the backend is deployed to dev/preprod/prod
  final String favoriteListsApi;
  final CityEventDateRange cityscapeDateTimeRange;
  final CityEventDateRange saudiNationalDayDateRange;
  final CityEventDateRange foundingDayDateRange;
  final CityEventDateRange leapDateRange;
  final CityEventDateRange wrcEventDateRange;
  // TIFO isn't a city event itself — it just reuses the same remote-config
  // shape (see CityEventDateRange.tifoDefault for the placeholder window).
  final CityEventDateRange tifoDateRange;

  EnvironmentConfig({
    required this.url,
    required this.meteoblue,
    required this.weatherApi,
    required this.jobsApi,
    required this.twinsApi,
    required this.baseApiDomain,
    required this.shareEtaApi,
    required this.shortLinkUrl,
    required this.shortLinkApiKey,
    required this.feedbackApi,
    required this.proxy,
    required this.appFeedbackEnable,
    required this.appFeedbackApi,
    required this.baladyBusinessUrl,
    required this.bssApi,
    required this.saudiPassApi,
    required this.favoriteListsApi,
    required this.cityscapeDateTimeRange,
    required this.saudiNationalDayDateRange,
    required this.foundingDayDateRange,
    required this.leapDateRange,
    required this.wrcEventDateRange,
    required this.tifoDateRange,
  });

  factory EnvironmentConfig.fromEnvType(String envType) => switch (envType) {
    'urbiDev' => EnvironmentConfig.urbiDev(),
    'momrahStaging' => EnvironmentConfig.momrahStaging(),
    'momrahProd' => EnvironmentConfig.momrahProd(),
    'urbiPreprod' => EnvironmentConfig.urbiPreProd(),
    _ => EnvironmentConfig.momrahProd(),
  };

  factory EnvironmentConfig.fromJson(Map<String, dynamic> json) => EnvironmentConfig(
    proxy: json['proxy'] as String?,
    url: json['url'] as String,
    meteoblue: json['meteoblue'] as String,
    weatherApi: json['weatherApi'] as String,
    jobsApi: json['jobsApi'] as String,
    twinsApi: json['twinsApi'] as String,
    baseApiDomain: json['baseApiDomain'] as String,
    shareEtaApi: json['shareEtaApi'] as String,
    shortLinkUrl: json['shortLinkUrl'] as String? ?? 'https://urbi-lifestyle.momah.gov.sa/1.0/short/link',
    shortLinkApiKey: json['shortLinkApiKey'] as String? ?? 'b32b12d2-4edb-4774-abbb-00b6b4a02c8e',
    feedbackApi: json['feedbackApi'] as String,
    appFeedbackEnable: json['appFeedbackEnable'] as bool,
    appFeedbackApi: json['appFeedbackApi'] as String,
    baladyBusinessUrl: json['baladyBusinessUrl'] as String,
    bssApi: json['bssApi'] as String,
    saudiPassApi: json['saudiPassApi'] as String,
    favoriteListsApi:
        json['favoriteListsApi'] as String? ?? 'https://urbi-lifestyle-stg.momah.gov.sa/1.0/api/v1/favorite',
    cityscapeDateTimeRange: CityEventDateRange.fromJson(
      json['cityscapeDateTimeRange'] as Map<String, dynamic>?,
      CityEventDateRange.cityscapeDefault(),
    ),
    foundingDayDateRange: CityEventDateRange.fromJson(
      json['foundingDayDateRange'] as Map<String, dynamic>?,
      CityEventDateRange.foundingDayDefault(),
    ),
    saudiNationalDayDateRange: CityEventDateRange.fromJson(
      json['saudiNationalDayDateRange'] as Map<String, dynamic>?,
      CityEventDateRange.saudiNationalDayDefault(),
    ),
    leapDateRange: CityEventDateRange.fromJson(
      json['leapDateRange'] as Map<String, dynamic>?,
      CityEventDateRange.leapDefault(),
    ),
    wrcEventDateRange: CityEventDateRange.fromJson(
      json['wrcEventDateRange'] as Map<String, dynamic>?,
      CityEventDateRange.wrcDefault(),
    ),
    tifoDateRange: CityEventDateRange.fromJson(
      json['tifoDateRange'] as Map<String, dynamic>?,
      CityEventDateRange.tifoDefault(),
    ),
  );

  Map<String, dynamic> toJson() => {
    'proxy': proxy,
    'url': url,
    'meteoblue': meteoblue,
    'weatherApi': weatherApi,
    'jobsApi': jobsApi,
    'twinsApi': twinsApi,
    'baseApiDomain': baseApiDomain,
    'shareEtaApi': shareEtaApi,
    'shortLinkApiKey': shortLinkApiKey,
    'feedbackApi': feedbackApi,
    'appFeedbackEnable': appFeedbackEnable,
    'appFeedbackApi': appFeedbackApi,
    'baladyBusinessUrl': baladyBusinessUrl,
    'saudiPassApi': saudiPassApi,
    'favoriteListsApi': favoriteListsApi,
  };

  factory EnvironmentConfig.urbiDev() => EnvironmentConfig(
    proxy: 'https://sa1.ops.2gis.dev',
    url: 'https://momrah-balady-dev.iaas.urbi-sa.com/api/1.0/',
    meteoblue: 'https://maps-api.meteoblue.com/v1/map/raster/',
    weatherApi: 'https://sa1.ops.2gis.dev/',
    jobsApi: 'https://sa1.ops.2gis.dev/v1/recruitment-services',
    twinsApi: 'https://momrah-twins-api.public-poc.urbi.ae/v1',
    baseApiDomain: 'urbi.ae',
    shareEtaApi: 'https://momrah-balady-dev-geo.public-poc.urbi.ae',
    shortLinkUrl: 'https://urbi-lifestyle.momah.gov.sa/1.0/short/link',
    shortLinkApiKey: 'b32b12d2-4edb-4774-abbb-00b6b4a02c8e',

    /// swagger: https://momrah-balady-dev-discrepancy.public-poc.urbi.ae/docs/
    feedbackApi: 'https://momrah-balady-dev-discrepancy.public-poc.urbi.ae/api/2.0/',
    appFeedbackApi: 'https://momrah-balady-dev.public-poc.urbi.ae/api',
    appFeedbackEnable: true,
    bssApi: 'https://casino-bss-receiver-api-qa.k8s.2gis.dev',
    baladyBusinessUrl: 'https://business-stg.balady.gov.sa',
    saudiPassApi: 'https://apiservicesstg.balady.gov.sa/',
    favoriteListsApi: 'https://urbi-lifestyle-stg.momah.gov.sa/1.0/api/v1/favorite',
    cityscapeDateTimeRange: CityEventDateRange.cityscapeDefault(),
    saudiNationalDayDateRange: CityEventDateRange.saudiNationalDayDefault(),
    foundingDayDateRange: CityEventDateRange.foundingDayDefault(),
    leapDateRange: CityEventDateRange.leapDefault(),
    wrcEventDateRange: CityEventDateRange.wrcDefault(),
    tifoDateRange: CityEventDateRange.tifoDefault(),
  );

  factory EnvironmentConfig.momrahStaging() => EnvironmentConfig(
    url: 'https://urbi-lifestyle-stg.momah.gov.sa/api/1.0/',
    meteoblue: 'https://maps-api.meteoblue.com/v1/map/raster/',
    weatherApi: 'https://apiservicesstg.balady.gov.sa/',
    jobsApi: 'https://urbi-lifestyle-stg.momah.gov.sa/v1/recruitment-services',
    twinsApi: 'https://urbi-lifestyle-stg.momah.gov.sa/v1',
    baseApiDomain: 'urbi.ae',
    shareEtaApi: 'https://geostream-urbi-lifestyle-stg.momah.gov.sa',
    shortLinkUrl: 'https://urbi-lifestyle.momah.gov.sa/1.0/short/link',
    shortLinkApiKey: 'b32b12d2-4edb-4774-abbb-00b6b4a02c8e',
    feedbackApi: 'https://urbi-lifestyle-stg.momah.gov.sa/api/2.0/',
    appFeedbackApi: 'https://urbi-lifestyle-stg.momah.gov.sa/api',
    appFeedbackEnable: true,
    proxy: null,
    bssApi: 'https://casino-bss-receiver-api-qa.k8s.2gis.dev',
    baladyBusinessUrl: 'https://business-stg.balady.gov.sa',
    saudiPassApi: 'https://apiservicesstg.balady.gov.sa/',
    favoriteListsApi: 'https://urbi-lifestyle-stg.momah.gov.sa/1.0/api/v1/favorite',
    cityscapeDateTimeRange: CityEventDateRange.cityscapeDefault(),
    saudiNationalDayDateRange: CityEventDateRange.saudiNationalDayDefault(),
    foundingDayDateRange: CityEventDateRange.foundingDayDefault(),
    leapDateRange: CityEventDateRange.leapDefault(),
    wrcEventDateRange: CityEventDateRange.wrcDefault(),
    tifoDateRange: CityEventDateRange.tifoDefault(),
  );

  factory EnvironmentConfig.momrahProd() => EnvironmentConfig(
    url: 'https://urbi-lifestyle.momah.gov.sa/api/1.0/',
    meteoblue: 'https://maps-api.meteoblue.com/v1/map/raster/',
    weatherApi: 'https://apiservices.balady.gov.sa/',
    jobsApi: 'https://urbi-lifestyle.momah.gov.sa/v1/recruitment-services',
    twinsApi: 'https://urbi-lifestyle.momah.gov.sa/v1',
    baseApiDomain: 'urbi.ae',
    shareEtaApi: 'https://geostream-urbi-lifestyle.momah.gov.sa',
    shortLinkUrl: 'https://urbi-lifestyle.momah.gov.sa/1.0/short/link',
    shortLinkApiKey: 'b32b12d2-4edb-4774-abbb-00b6b4a02c8e',
    feedbackApi: 'https://urbi-lifestyle.momah.gov.sa/api/2.0/',
    appFeedbackApi: 'https://urbi-lifestyle.momah.gov.sa/api',
    appFeedbackEnable: true,
    proxy: null,
    bssApi: 'https://s1.bss.2gis.com',
    baladyBusinessUrl: 'https://business.balady.gov.sa',
    saudiPassApi: 'https://apiservices.balady.gov.sa/',
    favoriteListsApi: 'https://urbi-lifestyle-stg.momah.gov.sa/1.0/api/v1/favorite',
    cityscapeDateTimeRange: CityEventDateRange.cityscapeDefault(),
    saudiNationalDayDateRange: CityEventDateRange.saudiNationalDayDefault(),
    foundingDayDateRange: CityEventDateRange.foundingDayDefault(),
    leapDateRange: CityEventDateRange.leapDefault(),
    wrcEventDateRange: CityEventDateRange.wrcDefault(),
    tifoDateRange: CityEventDateRange.tifoDefault(),
  );

  factory EnvironmentConfig.urbiPreProd() => EnvironmentConfig(
    proxy: 'https://sa1.ops.2gis.dev',
    url: 'https://momrah-balady.iaas.urbi-sa.com/api/1.0/',
    meteoblue: 'https://maps-api.meteoblue.com/v1/map/raster/',
    weatherApi: 'https://sa1.ops.2gis.dev/',
    jobsApi: 'https://sa1.ops.2gis.dev/v1/recruitment-services',
    twinsApi: 'https://momrah-twins-api.iaas.urbi-sa.com/v1',
    baseApiDomain: 'urbi.ae',
    shareEtaApi: 'https://momrah-balady-dev-geo.iaas.urbi-sa.com',
    shortLinkUrl: 'https://urbi-lifestyle.momah.gov.sa/1.0/short/link',
    shortLinkApiKey: 'b32b12d2-4edb-4774-abbb-00b6b4a02c8e',

    /// swagger: https://momrah-balady-discrepancy.public-poc.urbi.ae/docs/
    feedbackApi: 'https://momrah-balady-discrepancy.iaas.urbi-sa.com/api/2.0/',
    appFeedbackApi: 'https://momrah-balady-dev.iaas.urbi-sa.com/api',
    appFeedbackEnable: true,
    bssApi: 'https://casino-bss-receiver-api-qa.k8s.2gis.dev',
    baladyBusinessUrl: 'https://business-stg.balady.gov.sa',
    saudiPassApi: 'https://apiservicesstg.balady.gov.sa/',
    favoriteListsApi: 'https://urbi-lifestyle-stg.momah.gov.sa/1.0/api/v1/favorite',
    cityscapeDateTimeRange: CityEventDateRange.cityscapeDefault(),
    saudiNationalDayDateRange: CityEventDateRange.saudiNationalDayDefault(),
    foundingDayDateRange: CityEventDateRange.foundingDayDefault(),
    leapDateRange: CityEventDateRange.leapDefault(),
    wrcEventDateRange: CityEventDateRange.wrcDefault(),
    tifoDateRange: CityEventDateRange.tifoDefault(),
  );
}
