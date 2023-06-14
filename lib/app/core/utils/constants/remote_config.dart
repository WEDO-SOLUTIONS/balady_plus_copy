import '../../dependency_injection/dependency_injection_exports.dart' show sl;
import '../utils_exports.dart' show EnvType;

class RemoteConfig {
  //! First
  static String get gis => _RemoteConfig.gis[env]!;
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

  List<String> get munciplities => _RemoteConfig.munciplities[env]!;

  /*//! Second  I
  String get gis2 {
    switch (env) {
      case EnvType.dev:
        return _RCDev.gis;
      case EnvType.stg:
        return _RCStg.gis;
      case EnvType.prod:
        return _RCProd.gis;
    }
  }*/

  /* //! Second  II
  String get gis3 => {
        EnvType.dev: _RCDev.gis,
        EnvType.stg: _RCStg.gis,
        EnvType.prod: _RCProd.gis,
      }[env]!;
  List<String> get munciplities2 => {
        EnvType.dev: _RCDev.munciplities,
        EnvType.stg: _RCStg.munciplities,
        EnvType.prod: _RCProd.munciplities,
      }[env]!;*/

  static EnvType get env => sl<EnvType>();
}

//! First solution
class _RemoteConfig {
  static final gis = _initValues<String>(
    devVal: "htttps:klfdflkd",
    stgVal: "htttps:klfdflkd",
    prodVal: "htttps:klfdflkd",
  );
  static final hmCode = _initValues<String>(
    devVal: "oxqUHJH1KXD84vP0KYBnyaHDUk5sJ9HkzqPDTice5TABqvfACZaLscG1TjjyPgIT",
    stgVal: "1",
    prodVal: "1",
  );
  static final apigeeUsername = _initValues<String>(
    devVal: "7RmIkhYi6v4M7GUibBrpFdZuo8NsL2CC",
    stgVal: "7RmIkhYi6v4M7GUibBrpFdZuo8NsL2CC",
    prodVal: "1",
  );
  static final apigeePassword = _initValues<String>(
    devVal: "ak3JXde3KdBB1xbM",
    stgVal: "ak3JXde3KdBB1xbM",
    prodVal: "1",
  );
  static final ssoUrl = _initValues<String>(
    devVal: "https://ssoappdev.momra.gov.sa",
    stgVal: "https://ssoappdev.momra.gov.sa",
    prodVal: "1",
  );
  static final ssoLoginUrl = _initValues<String>(
    devVal: "com.momra.balady://callback",
    stgVal: "com.momra.balady://callback",
    prodVal: "1",
  );
  static final ssoSecret = _initValues<String>(
    devVal: "secret",
    stgVal: "secret",
    prodVal: "1",
  );
  static final ssoLogOutUrl = _initValues<String>(
    devVal: "com.momra.balady://logout",
    stgVal: "1",
    prodVal: "1",
  );
  static final momraDomain = _initValues<String>(
    devVal: ".momra.gov.sa",
    stgVal: "1",
    prodVal: "1",
  );
  static final ssoMomraDomain = _initValues<String>(
    devVal: ".ssoappdev.momra.gov.sa",
    stgVal: "1",
    prodVal: "1",
  );
  static final cookieURL = _initValues<String>(
    devVal: "https://baladyapps.momra.gov.sa/",
    stgVal: "1",
    prodVal: "1",
  );

  static final ssoClient = _initValues<String>(
    devVal: "balady_mobile_app",
    stgVal: "1",
    prodVal: "1",
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

//! Second solution
/*class _RCDev {
  static const String gis = "";
  static const List<String> munciplities = [];
}

class _RCStg {
  static const String gis = "";
  static const List<String> munciplities = [];
}

class _RCProd {
  static const String gis = "";
  static const List<String> munciplities = [];
}
*/