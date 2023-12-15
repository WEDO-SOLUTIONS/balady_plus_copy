// TODO: move to env variables
class SsoAuthConfig {
  final String ssoUrl;
  final String ssoUserInfo;
  final String ssoClient;
  final String ssoRedirectUrl;
  final String ssoLogoutUrl;
  final String ssoSecret;

  SsoAuthConfig({
    required this.ssoUrl,
    required this.ssoUserInfo,
    required this.ssoClient,
    required this.ssoRedirectUrl,
    required this.ssoLogoutUrl,
    required this.ssoSecret,
  });

  factory SsoAuthConfig.dev() => SsoAuthConfig(
        ssoUrl: 'https://sa1.ops.2gis.dev/connect',
        ssoUserInfo: '/userinfo',
        ssoClient: 'balady_mobile_app',
        ssoRedirectUrl: 'com.momra.balady://callback',
        ssoLogoutUrl: 'com.momra.balady://callback',
        ssoSecret: 'secret',
      );

  factory SsoAuthConfig.urbiPreProd() => SsoAuthConfig(
        ssoUrl: 'https://sa1.ops.2gis.dev/connect',
        ssoUserInfo: '/userinfo',
        ssoClient: 'balady_mobile_app',
        ssoRedirectUrl: 'com.momra.balady://callback',
        ssoLogoutUrl: 'com.momra.balady://callback',
        ssoSecret: 'secret',
      );

  factory SsoAuthConfig.preProd() => SsoAuthConfig(
        ssoUrl: 'https://ssoappstg.momra.gov.sa/connect',
        ssoUserInfo: '/userinfo',
        ssoClient: 'balady_mobile_app',
        ssoRedirectUrl: 'com.momra.balady://callback',
        ssoLogoutUrl: 'com.momra.balady://callback',
        ssoSecret: 'secret',
      );

  factory SsoAuthConfig.prod() => SsoAuthConfig(
        ssoUrl: 'https://ssoapp.momra.gov.sa',
        ssoUserInfo: '/userinfo',
        ssoClient: 'balady_mobile_app',
        ssoRedirectUrl: 'com.momra.balady://callback',
        ssoLogoutUrl: 'com.momra.balady://callback',
        ssoSecret: 'secret',
      );

  factory SsoAuthConfig.momrahStaging() => SsoAuthConfig(
        ssoUrl: 'https://ssoappdev.momra.gov.sa',
        ssoUserInfo: '/userinfo',
        ssoClient: 'balady_mobile_app',
        ssoRedirectUrl: 'com.momra.balady://callback',
        ssoLogoutUrl: 'com.momra.balady://callback',
        ssoSecret: 'secret',
      );

  factory SsoAuthConfig.momrahProd() => SsoAuthConfig(
        ssoUrl: 'https://ssoapp.momra.gov.sa',
        ssoUserInfo: '/userinfo',
        ssoClient: 'balady_mobile_app',
        ssoRedirectUrl: 'com.momra.balady://callback',
        ssoLogoutUrl: 'com.momra.balady://callback',
        ssoSecret: 'secret',
      );
}
