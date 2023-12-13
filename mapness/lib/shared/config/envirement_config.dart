import 'package:mapness/features/sso_auth/data/sso_config.dart';

enum DgisEnv { dev, preProd, momrahStaging, momrahProd }

class EnvirementConfig {
  final String url;
  final String meteoblue;
  final String weatherApi;
  final SsoAuthConfig sso;

  EnvirementConfig({
    required this.url,
    required this.meteoblue,
    required this.weatherApi,
    required this.sso,
  });

  factory EnvirementConfig.dev() => EnvirementConfig(
        url: 'https://momrah-balady-dev.public-poc.urbi.ae/api/1.0/',
        meteoblue: 'https://maps-api.meteoblue.com/v1/map/raster/',
        weatherApi: 'https://api.weatherapi.com',
        sso: SsoAuthConfig.dev(),
      );

  factory EnvirementConfig.preProd() => EnvirementConfig(
        url: 'https://momrah-balady.public-poc.urbi.ae/api/1.0/',
        meteoblue: 'https://maps-api.meteoblue.com/v1/map/raster/',
        weatherApi: 'https://api.weatherapi.com',
        sso: SsoAuthConfig.preProd(),
      );

  factory EnvirementConfig.momrahStaging() => EnvirementConfig(
        url: 'https://apiservicesstg.balady.gov.sa/v1/urbi-services/',
        meteoblue: 'https://maps-api.meteoblue.com/v1/map/raster/',
        weatherApi: 'https://api.weatherapi.com',
        sso: SsoAuthConfig.momrahStaging(),
      );

  factory EnvirementConfig.momrahProd() => EnvirementConfig(
        url: 'https://apiservices.balady.gov.sa/v1/urbi-services/',
        meteoblue: 'https://maps-api.meteoblue.com/v1/map/raster/',
        weatherApi: 'https://api.weatherapi.com',
        sso: SsoAuthConfig.momrahProd(),
      );
}
