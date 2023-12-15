import 'package:mapness/features/sso_auth/data/sso_config.dart';

enum DgisEnv { dev, preProd, momrahStaging, momrahProd }

class EnvirementConfig {
  final String url;
  final String meteoblue;
  final String weatherApi;
  final String proxy;
  final SsoAuthConfig sso;

  EnvirementConfig({
    required this.url,
    required this.meteoblue,
    required this.weatherApi,
    required this.proxy,
    required this.sso,
  });

  factory EnvirementConfig.dev() => EnvirementConfig(
        proxy: 'https://sa1.ops.2gis.dev',
        url: 'https://momrah-balady-dev.public-poc.urbi.ae/api/1.0/',
        meteoblue: 'https://maps-api.meteoblue.com/v1/map/raster/',
        weatherApi: 'https://api.weatherapi.com',
        sso: SsoAuthConfig.dev(),
      );

  factory EnvirementConfig.preProd() => EnvirementConfig(
        proxy: 'https://sa1.ops.2gis.dev',
        url: 'https://momrah-balady.public-poc.urbi.ae/api/1.0/',
        meteoblue: 'https://maps-api.meteoblue.com/v1/map/raster/',
        weatherApi: 'https://api.weatherapi.com',
        sso: SsoAuthConfig.preProd(),
      );

  factory EnvirementConfig.momrahStaging() => EnvirementConfig(
        proxy: 'https://sa1.ops.2gis.dev',
        url: 'https://apiservicesstg.balady.gov.sa/v1/urbi-services/',
        meteoblue: 'https://maps-api.meteoblue.com/v1/map/raster/',
        weatherApi: 'https://api.weatherapi.com',
        sso: SsoAuthConfig.momrahStaging(),
      );

  factory EnvirementConfig.momrahProd() => EnvirementConfig(
        proxy: 'https://sa1.ops.2gis.dev',
        url: 'https://apiservices.balady.gov.sa/v1/urbi-services/',
        meteoblue: 'https://maps-api.meteoblue.com/v1/map/raster/',
        weatherApi: 'https://api.weatherapi.com',
        sso: SsoAuthConfig.momrahProd(),
      );

  factory EnvirementConfig.urbiPreProd() => EnvirementConfig(
        proxy: 'https://sa1.ops.2gis.dev',
        url: 'https://apiservicesstg.balady.gov.sa/v1/urbi-services/',
        meteoblue: 'https://maps-api.meteoblue.com/v1/map/raster/',
        weatherApi: 'https://api.weatherapi.com',
        sso: SsoAuthConfig.urbiPreProd(),
      );
}
