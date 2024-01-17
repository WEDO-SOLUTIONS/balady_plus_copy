enum DgisEnv { urbiDev, momrahStaging, momrahProd, urbiPreprod }

extension DgisEnvExt on DgisEnv {
  EnvironmentConfig getConfig() {
    return switch (this) {
      DgisEnv.urbiDev => EnvironmentConfig.urbiDev(),
      DgisEnv.momrahProd => EnvironmentConfig.momrahProd(),
      DgisEnv.momrahStaging => EnvironmentConfig.momrahStaging(),
      DgisEnv.urbiPreprod => EnvironmentConfig.urbiPreProd(),
    };
  }
}

class EnvironmentConfig {
  final String url;
  final String meteoblue;
  final String weatherApi;
  final String? proxy;

  EnvironmentConfig({
    required this.url,
    required this.meteoblue,
    required this.weatherApi,
    this.proxy,
  });

  factory EnvironmentConfig.urbiDev() => EnvironmentConfig(
        proxy: 'https://sa1.ops.2gis.dev',
        url: 'https://momrah-balady-dev.public-poc.urbi.ae/api/1.0/',
        meteoblue: 'https://maps-api.meteoblue.com/v1/map/raster/',
        weatherApi: 'https://momrah-balady-dev.public-poc.urbi.ae/api/1.0/',
      );

  factory EnvironmentConfig.momrahStaging() => EnvironmentConfig(
        url: 'https://apiservicesstg.balady.gov.sa/v1/urbi-services/',
        meteoblue: 'https://maps-api.meteoblue.com/v1/map/raster/',
        weatherApi: 'https://apiservicesstg.balady.gov.sa/',
      );

  factory EnvironmentConfig.momrahProd() => EnvironmentConfig(
        url: 'https://apiservices.balady.gov.sa/v1/urbi-services/',///url for URBI backcend
        meteoblue: 'https://maps-api.meteoblue.com/v1/map/raster/',
        weatherApi: 'https://apiservices.balady.gov.sa/',
      );

  factory EnvironmentConfig.urbiPreProd() => EnvironmentConfig(
        proxy: 'https://sa1.ops.2gis.dev',
        url: 'https://momrah-balady.public-poc.urbi.ae/api/1.0/',
        meteoblue: 'https://maps-api.meteoblue.com/v1/map/raster/',
        weatherApi: 'https://sa1.ops.2gis.dev/',
      );
}
