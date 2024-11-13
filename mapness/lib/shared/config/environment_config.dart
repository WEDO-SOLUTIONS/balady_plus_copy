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
  });

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
      );

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
        appFeedbackApi: '',
        appFeedbackEnable: true,
      );

  factory EnvironmentConfig.momrahStaging() => EnvironmentConfig(
        url: 'https://apiservicesstg.balady.gov.sa/v1/urbi-services/',
        meteoblue: 'https://maps-api.meteoblue.com/v1/map/raster/',
        weatherApi: 'https://apiservicesstg.balady.gov.sa/',
        jobsApi: 'https://apiservicesstg.balady.gov.sa/v1/recruitment-services',
        twinsApi: 'https://apiservicesstg.balady.gov.sa/v1/urbi-services/twins-api/v1',
        baseApiDomain: 'urbi.ae',
        shareEtaApi: 'https://geostream-urbi-lifestyle-stg.momrah.gov.sa',
        feedbackApi: 'https://urbi-lifestyle-stg.momrah.gov.sa/api/2.0/',
        appFeedbackApi: '',
        appFeedbackEnable: true,
        proxy: null,
      );

  factory EnvironmentConfig.momrahProd() => EnvironmentConfig(
        url: 'https://apiservices.balady.gov.sa/v1/urbi-services/',
        meteoblue: 'https://maps-api.meteoblue.com/v1/map/raster/',
        weatherApi: 'https://apiservices.balady.gov.sa/',
        jobsApi: 'https://apiservices.balady.gov.sa/v1/recruitment-services',
        twinsApi: 'https://apiservices.balady.gov.sa/v1/urbi-services/twins-api/v1',
        baseApiDomain: 'urbi.ae',
        shareEtaApi: 'https://geostream-urbi-lifestyle.momrah.gov.sa',
        feedbackApi: 'https://urbi-lifestyle.momrah.gov.sa/api/2.0/',
        appFeedbackApi: '',
        appFeedbackEnable: true,
        proxy: null,
      );

  factory EnvironmentConfig.urbiPreProd() => EnvironmentConfig(
        proxy: 'https://sa1.ops.2gis.dev',
        url: 'https://momrah-balady.public-poc.urbi.ae/api/1.0/',
        meteoblue: 'https://maps-api.meteoblue.com/v1/map/raster/',
        weatherApi: 'https://sa1.ops.2gis.dev/',
        jobsApi: 'https://sa1.ops.2gis.dev/v1/recruitment-services',
        twinsApi: 'https://momrah-twins-api.public-poc.urbi.ae/v1',
        baseApiDomain: 'urbi.ae',
        shareEtaApi: 'https://momrah-balady-dev-geo.public-poc.urbi.ae',

        /// swagger: https://momrah-balady-discrepancy.public-poc.urbi.ae/docs/
        feedbackApi: 'https://momrah-balady-discrepancy.public-poc.urbi.ae/api/2.0/',
        appFeedbackApi: '',
        appFeedbackEnable: true,
      );
}
