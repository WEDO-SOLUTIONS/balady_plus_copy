import 'package:mapness/features/sso_auth/data/sso_config.dart';

enum DgisEnv { dev, preProd, momrahStaging, momrahProd, urbiPreprod }

extension DgisEnvExt on DgisEnv {
  EnvironmentConfig getConfig() {
    return switch (this) {
      DgisEnv.preProd => EnvironmentConfig.preProd(),
      DgisEnv.dev => EnvironmentConfig.dev(),
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
  final String proxy;
  final SsoAuthConfig sso;

  EnvironmentConfig({
    required this.url,
    required this.meteoblue,
    required this.weatherApi,
    required this.proxy,
    required this.sso,
  });

  factory EnvironmentConfig.dev() => EnvironmentConfig(
        proxy: 'https://sa1.ops.2gis.dev',
        url: 'https://momrah-balady-dev.public-poc.urbi.ae/api/1.0/',
        meteoblue: 'https://maps-api.meteoblue.com/v1/map/raster/',
        weatherApi: 'https://api.weatherapi.com',
        sso: SsoAuthConfig.dev(),
      );

  factory EnvironmentConfig.preProd() => EnvironmentConfig(
        proxy: 'https://sa1.ops.2gis.dev',
        url: 'https://momrah-balady.public-poc.urbi.ae/api/1.0/',
        meteoblue: 'https://maps-api.meteoblue.com/v1/map/raster/',
        weatherApi: 'https://api.weatherapi.com',
        sso: SsoAuthConfig.preProd(),
      );

  factory EnvironmentConfig.momrahStaging() => EnvironmentConfig(
        proxy: 'https://sa1.ops.2gis.dev',
        url: 'https://apiservicesstg.balady.gov.sa/v1/urbi-services/',
        meteoblue: 'https://maps-api.meteoblue.com/v1/map/raster/',
        weatherApi: 'https://api.weatherapi.com',
        sso: SsoAuthConfig.momrahStaging(),
      );

  factory EnvironmentConfig.momrahProd() => EnvironmentConfig(
        proxy: 'https://sa1.ops.2gis.dev',
        url: 'https://apiservices.balady.gov.sa/v1/urbi-services/',
        meteoblue: 'https://maps-api.meteoblue.com/v1/map/raster/',
        weatherApi: 'https://api.weatherapi.com',
        sso: SsoAuthConfig.momrahProd(),
      );

  factory EnvironmentConfig.urbiPreProd() => EnvironmentConfig(
        proxy: 'https://sa1.ops.2gis.dev',
        // url: 'https://apiservicesstg.balady.gov.sa/v1/urbi-services/',
        url: 'https://momrah-balady.public-poc.urbi.ae/api/1.0/',
        meteoblue: 'https://maps-api.meteoblue.com/v1/map/raster/',
        weatherApi: 'https://api.weatherapi.com',
        sso: SsoAuthConfig.urbiPreProd(),
      );
}
