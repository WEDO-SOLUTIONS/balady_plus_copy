import '../../dependency_injection/dependency_injection_exports.dart' show sl;
import '../utils_exports.dart' show EnvType;

class RemoteConfig {
  //! First
  static String get gis => _RemoteConfig.gis[env]!;
  static String get apigeeURL => _RemoteConfig.apigeeURL[env]!;
  static String get pegaURL => _RemoteConfig.pegaURL[env]!;

  static String get hmCode => _RemoteConfig.hmCode[env]!;
  static String get apigeeUsername => _RemoteConfig.apigeeUsername[env]!;
  static String get apigeePassword => _RemoteConfig.apigeePassword[env]!;
  static String get ssoUrl => _RemoteConfig.ssoUrl[env]!;
  static String get ssoLoginUrl => _RemoteConfig.ssoLoginUrl[env]!;
  static String get ssoLogOutUrl => _RemoteConfig.ssoLogOutUrl[env]!;
  static String get ssoSecret => _RemoteConfig.ssoSecret[env]!;
  static String get momraDomain => _RemoteConfig.momraDomain[env]!;
  static String get ssoMomraDomain => _RemoteConfig.ssoMomraDomain[env]!;
  static String get cookieURL => _RemoteConfig.cookieURL[env]!;
  static String get ssoClient => _RemoteConfig.ssoClient[env]!;

  static double get mapRadius => _RemoteConfig.mapRadius[env]!;
  static String get regaClass => _RemoteConfig.regaClass[env]!;
  static String get damagedCarsClass => _RemoteConfig.damagedCarsClass[env]!;

  List<String> get munciplities => _RemoteConfig.munciplities[env]!;

  static EnvType get env => sl<EnvType>();
}

//! First solution
class _RemoteConfig {
  static final gis = _initValues<String>(
    devVal: "",
    stgVal: "",
    prodVal: "",
  );
  static final hmCode = _initValues<String>(
    devVal: "oxqUHJH1KXD84vP0KYBnyaHDUk5sJ9HkzqPDTice5TABqvfACZaLscG1TjjyPgIT",
    stgVal: "oxqUHJH1KXD84vP0KYBnyaHDUk5sJ9HkzqPDTice5TABqvfACZaLscG1TjjyPgIT",
    prodVal: "",
  );

  static final apigeeURL = _initValues<String>(
    devVal: "https://apiservicesstg.balady.gov.sa",
    stgVal: "https://apiservicesstg.balady.gov.sa",
    prodVal: "1",
  );
  static final pegaURL = _initValues<String>(
    devVal: "https://crmustg.momra.gov.sa",
    stgVal: "https://crmustg.momra.gov.sa",
    prodVal: "",
  );

  static final apigeeUsername = _initValues<String>(
    devVal: "7RmIkhYi6v4M7GUibBrpFdZuo8NsL2CC",
    stgVal: "7RmIkhYi6v4M7GUibBrpFdZuo8NsL2CC",
    prodVal: "",
  );
  static final apigeePassword = _initValues<String>(
    devVal: "ak3JXde3KdBB1xbM",
    stgVal: "ak3JXde3KdBB1xbM",
    prodVal: "",
  );
  static final ssoUrl = _initValues<String>(
    devVal: "https://ssoappdev.momra.gov.sa",
    stgVal: "https://ssoappdev.momra.gov.sa",
    prodVal: "",
  );
  static final ssoLoginUrl = _initValues<String>(
    devVal: "com.momra.balady://callback",
    stgVal: "com.momra.balady://callback",
    prodVal: "",
  );
  static final ssoSecret = _initValues<String>(
    devVal: "secret",
    stgVal: "secret",
    prodVal: "secret",
  );
  static final ssoLogOutUrl = _initValues<String>(
    devVal: "com.momra.balady://logout",
    stgVal: "com.momra.balady://logout",
    prodVal: "",
  );
  static final momraDomain = _initValues<String>(
    devVal: ".momra.gov.sa",
    stgVal: ".momra.gov.sa",
    prodVal: "1",
  );
  static final ssoMomraDomain = _initValues<String>(
    devVal: ".ssoappdev.momra.gov.sa",
    stgVal: ".ssoappdev.momra.gov.sa",
    prodVal: "1",
  );
  static final cookieURL = _initValues<String>(
    devVal: "https://baladyapps.momra.gov.sa/",
    stgVal: "https://baladyapps.momra.gov.sa/",
    prodVal: "1",
  );

  static final ssoClient = _initValues<String>(
    devVal: "balady_mobile_app",
    stgVal: "balady_mobile_app",
    prodVal: "1",
  );

  static final mapRadius = _initValues<double>(
    devVal: 20000000000000.0,
    stgVal: 2000000000000.0,
    prodVal: 2000.0,
  );

  static final regaClass = _initValues<String>(
    devVal: "CG-26",
    stgVal: "CG-26",
    prodVal: "CG-11",
  );
  static final damagedCarsClass = _initValues<String>(
    devVal: "NSPCL-192",
    stgVal: "NSPCL-192",
    prodVal: "NSPCL-36",
  );

  static final munciplities = {
    EnvType.dev: [""],
    EnvType.stg: [""],
    EnvType.prod: [""]
  };

  static Map<EnvType, T> _initValues<T>({
    dynamic devVal,
    dynamic stgVal,
    dynamic prodVal,
  }) =>
      {
        EnvType.dev: devVal,
        EnvType.stg: stgVal,
        EnvType.prod: prodVal,
      };
}
