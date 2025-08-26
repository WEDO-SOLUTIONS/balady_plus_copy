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

  // TODO(Demezy): very probably will be changed in the future
  final String feedbackApi;
  final bool appFeedbackEnable;
  final String appFeedbackApi;
  final String baladyBusinessUrl;
  final String bssApi;
  final String saudiPassApi;

  EnvironmentConfig({
    required this.url,
    required this.meteoblue,
    required this.weatherApi,
    required this.jobsApi,
    required this.twinsApi,
    required this.baseApiDomain,
    required this.shareEtaApi,
    required this.feedbackApi,
    required this.proxy,
    required this.appFeedbackEnable,
    required this.appFeedbackApi,
    required this.baladyBusinessUrl,
    required this.bssApi,
    required this.saudiPassApi,
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
        feedbackApi: json['feedbackApi'] as String,
        appFeedbackEnable: json['appFeedbackEnable'] as bool,
        appFeedbackApi: json['appFeedbackApi'] as String,
        baladyBusinessUrl: json['baladyBusinessUrl'] as String,
        bssApi: json['bssApi'] as String,
        saudiPassApi: json['saudiPassApi'] as String,
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
        'feedbackApi': feedbackApi,
        'appFeedbackEnable': appFeedbackEnable,
        'appFeedbackApi': appFeedbackApi,
        'baladyBusinessUrl': baladyBusinessUrl,
        'saudiPassApi': saudiPassApi,
      };

  factory EnvironmentConfig.urbiDev() => EnvironmentConfig(
        proxy: 'https://sa1.ops.2gis.dev',
        url: 'https://momrah-balady-dev.public-poc.urbi.ae/api/1.0/',
        meteoblue: 'https://maps-api.meteoblue.com/v1/map/raster/',
        weatherApi: 'https://sa1.ops.2gis.dev/',
        jobsApi: 'https://sa1.ops.2gis.dev/v1/recruitment-services',
        twinsApi: 'https://momrah-twins-api.public-poc.urbi.ae/v1',
        baseApiDomain: 'urbi.ae',
        shareEtaApi: 'https://momrah-balady-dev-geo.public-poc.urbi.ae',

        /// swagger: https://momrah-balady-dev-discrepancy.public-poc.urbi.ae/docs/
        feedbackApi: 'https://momrah-balady-dev-discrepancy.public-poc.urbi.ae/api/2.0/',
        appFeedbackApi: 'https://momrah-balady-dev.public-poc.urbi.ae/api',
        appFeedbackEnable: true,
        bssApi: 'https://s1.bss.2gis.com',
        baladyBusinessUrl: 'https://baladybusiness-stg.momra.gov.sa',
        saudiPassApi: 'https://apiservicesstg.balady.gov.sa/',
      );

  factory EnvironmentConfig.momrahStaging() => EnvironmentConfig(
      url: 'https://urbi-lifestyle-stg.momrah.gov.sa/api/1.0/',
      meteoblue: 'https://maps-api.meteoblue.com/v1/map/raster/',
      weatherApi: 'https://apiservicesstg.balady.gov.sa/',
      jobsApi: 'https://urbi-lifestyle-stg.momrah.gov.sa/v1/recruitment-services',
      twinsApi: 'https://urbi-lifestyle-stg.momrah.gov.sa/v1',
      baseApiDomain: 'urbi.ae',
      shareEtaApi: 'https://geostream-urbi-lifestyle-stg.momrah.gov.sa',
      feedbackApi: 'https://urbi-lifestyle-stg.momrah.gov.sa/api/2.0/',
      appFeedbackApi: 'https://urbi-lifestyle-stg.momrah.gov.sa/api',
      appFeedbackEnable: true,
      proxy: null,
      bssApi: 'https://s1.bss.2gis.com',
      baladyBusinessUrl: 'https://baladybusiness-stg.momra.gov.sa',
      saudiPassApi: 'https://apiservicesstg.balady.gov.sa/');

  factory EnvironmentConfig.momrahProd() => EnvironmentConfig(
      url: 'https://urbi-lifestyle.momrah.gov.sa/api/1.0/',
      meteoblue: 'https://maps-api.meteoblue.com/v1/map/raster/',
      weatherApi: 'https://apiservices.balady.gov.sa/',
      jobsApi: 'https://urbi-lifestyle.momrah.gov.sa/v1/recruitment-services',
      twinsApi: 'https://urbi-lifestyle.momrah.gov.sa/v1',
      baseApiDomain: 'urbi.ae',
      shareEtaApi: 'https://geostream-urbi-lifestyle.momrah.gov.sa',
      feedbackApi: 'https://urbi-lifestyle.momrah.gov.sa/api/2.0/',
      appFeedbackApi: 'https://urbi-lifestyle.momrah.gov.sa/api',
      appFeedbackEnable: true,
      proxy: null,
      bssApi: 'https://s1.bss.2gis.com',
      baladyBusinessUrl: 'https://business.balady.gov.sa',
      saudiPassApi: 'https://apiservices.balady.gov.sa/');

  factory EnvironmentConfig.urbiPreProd() => EnvironmentConfig(
        proxy: 'https://sa1.ops.2gis.dev',
        url: 'https://momrah-balady.iaas.urbi-sa.com/api/1.0/',
        meteoblue: 'https://maps-api.meteoblue.com/v1/map/raster/',
        weatherApi: 'https://sa1.ops.2gis.dev/',
        jobsApi: 'https://sa1.ops.2gis.dev/v1/recruitment-services',
        twinsApi: 'https://momrah-twins-api.iaas.urbi-sa.com/v1',
        baseApiDomain: 'urbi.ae',
        shareEtaApi: 'https://momrah-balady-dev-geo.iaas.urbi-sa.com',

        /// swagger: https://momrah-balady-discrepancy.public-poc.urbi.ae/docs/
        feedbackApi: 'https://momrah-balady-discrepancy.iaas.urbi-sa.com/api/2.0/',
        appFeedbackApi: 'https://momrah-balady-dev.iaas.urbi-sa.com/api',
        appFeedbackEnable: true,
        bssApi: 'https://s1.bss.2gis.com',
        baladyBusinessUrl: 'https://baladybusiness-stg.momra.gov.sa',
        saudiPassApi: 'https://apiservicesstg.balady.gov.sa/',
      );
}
