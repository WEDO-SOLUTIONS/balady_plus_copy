import '../../dependency_injection/dependency_injection_exports.dart' show sl;
import '../utils_exports.dart' show EnvType;

class RemoteConfig {
  //! First
  static String get gis => _RemoteConfig.gis[env]!;
  static String get apigeeURL => _RemoteConfig.apigeeURL[env]!;
  static String get pegaURL => _RemoteConfig.pegaURL[env]!;
  static String get webSiteUrl => _RemoteConfig.webSiteUrl[env]!;
  static String get baladyCommercialUrl =>
      _RemoteConfig.baladyCommercialUrl[env]!;

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

  static String get specialConditionOldId =>
      _RemoteConfig.specialConditionOldId[env]!;
  static String get specialConditionId =>
      _RemoteConfig.specialConditionId[env]!;

  // List<String> get munciplities => _RemoteConfig.munciplities[env]!;
  static String get baladyToken => _RemoteConfig.baladyToken[env]!;
  static String get xBaladyToken => _RemoteConfig.xBaladyToken[env]!;
  static String get baladyBaseUrl => _RemoteConfig.baladyBaseUrl[env]!;

  static String get publicAppointmentShareURL =>
      _RemoteConfig.publicAppointmentShareURL[env]!;

  static String get publicLicenseShareURL =>
      _RemoteConfig.publicLicenseShareURL[env]!;

  static String get webCookieHeader => _RemoteConfig.webCookieHeader[env]!;
  static List<String> get marketClass => _RemoteConfig.marketClass[env]!;

  static EnvType get env => sl<EnvType>();

  static List<String> get MSRAllowedMuncipalites =>
      _RemoteConfig.MSRAllowedMuncipalites[env]!;

  static Map<String, dynamic> get MunicipalServicesIDs =>
      _RemoteConfig.municipal_services_IDS[env]!;

  static String get ewaaUrl => _RemoteConfig.ewaaUrl[env]!;

  static String get uxCamKey => _RemoteConfig.uxCamKey[env]!;
}

//! First solution
class _RemoteConfig {
  static final gis = _initValues<String>(
    devVal: "https://gisappstg.momra.gov.sa",
    stgVal: "https://gisappstg.momra.gov.sa",
    preVal: "https://gisappstg.momra.gov.sa",
    prodVal: "https://gisapps.momra.gov.sa",
    urbiPreVal: "https://gisappstg.momra.gov.sa",
  );

  static final uxCamKey = _initValues<String>(
    devVal: "",
    stgVal: "2w1otnta9bvvhzo",
    preVal: "3i45abbyrbljp32",
    prodVal: "2w1otnta9bvvhzo",
    urbiPreVal: "",
  );
  static final hmCode = _initValues<String>(
    devVal: "oxqUHJH1KXD84vP0KYBnyaHDUk5sJ9HkzqPDTice5TABqvfACZaLscG1TjjyPgIT",
    stgVal: "oxqUHJH1KXD84vP0KYBnyaHDUk5sJ9HkzqPDTice5TABqvfACZaLscG1TjjyPgIT",
    preVal: "oxqUHJH1KXD84vP0KYBnyaHDUk5sJ9HkzqPDTice5TABqvfACZaLscG1TjjyPgIT",
    prodVal: "TU9NUkEgTW9iaWxlIFRlYW0gMjAyMg==",
    urbiPreVal:
        "oxqUHJH1KXD84vP0KYBnyaHDUk5sJ9HkzqPDTice5TABqvfACZaLscG1TjjyPgIT",
  );

  static final apigeeURL = _initValues<String>(
    devVal: "https://apiservicesstg.balady.gov.sa",
    stgVal: "https://apiservicesstg.balady.gov.sa",
    preVal: "https://apiservicespp.balady.gov.sa",
    prodVal: "https://apiservices.balady.gov.sa",
    urbiPreVal: "https://apiservicespp.balady.gov.sa",
  );
  static final pegaURL = _initValues<String>(
    devVal: "https://crmustg.momra.gov.sa",
    stgVal: "https://crmustg.momra.gov.sa",
    preVal: "https://crmpre.momra.gov.sa",
    prodVal: "https://crm.balady.gov.sa",
    urbiPreVal: "https://crumupre.momra.gov.sa",
  );

  static final apigeeUsername = _initValues<String>(
    devVal: "7RmIkhYi6v4M7GUibBrpFdZuo8NsL2CC",
    stgVal: "7RmIkhYi6v4M7GUibBrpFdZuo8NsL2CC",
    preVal: "7RmIkhYi6v4M7GUibBrpFdZuo8NsL2CC",
    prodVal: "4YxScCXqgTqPUpNqTH8rX1QZZUUzfbtw",
    urbiPreVal: "7RmIkhYi6v4M7GUibBrpFdZuo8NsL2CC",
  );
  static final apigeePassword = _initValues<String>(
    devVal: "ak3JXde3KdBB1xbM",
    stgVal: "ak3JXde3KdBB1xbM",
    preVal: "ak3JXde3KdBB1xbM",
    prodVal: "b4Ocmvf3sNDNDdrs",
    urbiPreVal: "ak3JXde3KdBB1xbM",
  );
  static final ssoUrl = _initValues<String>(
    devVal: "https://sa1.ops.2gis.dev",
    stgVal: "https://ssoappdev.momra.gov.sa",
    preVal: "https://ssoappstg.momra.gov.sa",
    prodVal: "https://ssoapp.balady.gov.sa",
    urbiPreVal: "https://sa1.ops.2gis.dev",
  );
  static final ssoLoginUrl = _initValues<String>(
    devVal: "com.momra.balady://callback",
    stgVal: "com.momra.balady://callback",
    preVal: "com.momra.balady://callback",
    prodVal: "com.balady://callback",
    urbiPreVal: "com.momra.balady://callback",
  );
  static final ssoSecret = _initValues<String>(
    devVal: "secret",
    stgVal: "secret",
    preVal: "1afa033f369849a2ac6d0d42e713eb82",
    prodVal: "d19e0d31729144d3bff32d5cebbaef63",
    urbiPreVal: "secret",
  );
  static final ssoLogOutUrl = _initValues<String>(
    devVal: "com.momra.balady://logout",
    stgVal: "com.momra.balady://logout",
    preVal: "com.momra.balady://logout",
    prodVal: "com.balady://logout",
    urbiPreVal: "com.momra.balady://logout",
  );
  static final momraDomain = _initValues<String>(
    devVal: ".momra.gov.sa",
    stgVal: ".momra.gov.sa",
    preVal: ".momra.gov.sa",
    prodVal: ".balady.gov.sa",
    urbiPreVal: ".momra.gov.sa",
  );
  static final ssoMomraDomain = _initValues<String>(
    devVal: ".ssoappdev.momra.gov.sa",
    stgVal: ".ssoappdev.momra.gov.sa",
    preVal: ".ssoappstg.momra.gov.sa",
    prodVal: ".ssoapp.balady.gov.sa",
    urbiPreVal: ".ssoappstg.momra.gov.sa",
  );
  static final cookieURL = _initValues<String>(
    devVal: "https://baladyapps.momra.gov.sa/",
    stgVal: "https://baladyapps.momra.gov.sa/",
    preVal: "https://prebaladyapps.momra.gov.sa/",
    prodVal: "https://apps.balady.gov.sa/",
    urbiPreVal: "https://prebaladyapps.momra.gov.sa/",
  );

  static final ssoClient = _initValues<String>(
    devVal: "balady_mobile_app",
    stgVal: "balady_mobile_app",
    preVal: "balady_mobile_app",
    prodVal: "balady_mobile_app",
    urbiPreVal: "balady_mobile_app",
  );

  static final mapRadius = _initValues<double>(
    devVal: 20000000000000.0,
    stgVal: 2000000000000.0,
    preVal: 2000.0,
    prodVal: 2000.0,
    urbiPreVal: 2000.0,
  );

  static final marketClass = _initValues<List<String>>(
    devVal: ["CG-14"],
    stgVal: ["CG-14"],
    preVal: ["CG-14"],
    prodVal: ["CG-6", "CG-9"],
    urbiPreVal: ["CG-14"],
  );

  static final regaClass = _initValues<String>(
    devVal: "CG-26",
    stgVal: "CG-26",
    preVal: "CG-26",
    prodVal: "CG-11",
    urbiPreVal: "CG-26",
  );
  static final damagedCarsClass = _initValues<String>(
    devVal: "NSPCL-192",
    stgVal: "NSPCL-192",
    preVal: "NSPCL-192",
    prodVal: "NSPCL-36",
    urbiPreVal: "NSPCL-192",
  );

  static final specialConditionOldId = _initValues<String>(
    devVal: "21",
    stgVal: "21",
    preVal: "21",
    prodVal: "21",
    urbiPreVal: "21",
  );

  static final specialConditionId = _initValues<String>(
    devVal: "22",
    stgVal: "22",
    preVal: "22",
    prodVal: "22",
    urbiPreVal: "22",
  );

  static final webSiteUrl = _initValues<String>(
    devVal: "https://balady.momra.gov.sa",
    stgVal: "https://balady.momra.gov.sa",
    preVal: "https://prebalady.momra.gov.sa",
    prodVal: "https://balady.gov.sa",
    urbiPreVal: "https://prebalady.momra.gov.sa",
  );

  static final baladyBaseUrl = _initValues<String>(
    devVal: "https://baladyapps.momra.gov.sa",
    stgVal: "https://baladyapps.momra.gov.sa",
    preVal: "https://prebaladyapps.momra.gov.sa",
    prodVal: "https://apps.balady.gov.sa",
    urbiPreVal: "https://prebaladyapps.momra.gov.sa",
  );

  static final baladyCommercialUrl = _initValues<String>(
    devVal: "https://stgcommercial.momra.gov.sa",
    stgVal: "https://stgcommercial.momra.gov.sa",
    preVal: "https://commercial.balady.gov.sa",
    prodVal: "https://commercial.balady.gov.sa",
    urbiPreVal: "https://commercial.balady.gov.sa",
  );

  static final baladyToken = _initValues<String>(
    devVal: "E48C0CF6386948D5A22D8F4AD46B9CBB",
    stgVal: "E48C0CF6386948D5A22D8F4AD46B9CBB",
    preVal: "E48C0CF6386948D5A22D8F4AD46B9CBB",
    prodVal: "BEDD09A1277C4E099DEB80D0AEFAA245",
    urbiPreVal: "E48C0CF6386948D5A22D8F4AD46B9CBB",
  );

  static final xBaladyToken = _initValues<String>(
    devVal: "5EBC1331132E4C55B9726AFFA5D6B6F4",
    stgVal: "5EBC1331132E4C55B9726AFFA5D6B6F4",
    preVal: "5EBC1331132E4C55B9726AFFA5D6B6F4",
    prodVal: "BE2019B8FECE4DACA5275BE2STGPROD",
    urbiPreVal: "5EBC1331132E4C55B9726AFFA5D6B6F4",
  );

  static final publicAppointmentShareURL = _initValues<String>(
    devVal: "https://bldtrain.momra.gov.sa/commonapi/apt/",
    stgVal: "https://bldtrain.momra.gov.sa/commonapi/apt/",
    preVal: "https://bldtrain.momra.gov.sa/commonapi/apt/",
    prodVal: "https://ebalady.momra.gov.sa/commonapi/apt/",
    urbiPreVal: "https://bldtrain.momra.gov.sa/commonapi/apt/",
  );

  static final publicLicenseShareURL = _initValues<String>(
    devVal: "https://bldtrain.momra.gov.sa/commonapi/clp",
    stgVal: "https://bldtrain.momra.gov.sa/commonapi/clp",
    preVal: "https://bldtrain.momra.gov.sa/commonapi/clp",
    prodVal: "https://ebalady.momra.gov.sa/commonapi/clp",
    urbiPreVal: "https://bldtrain.momra.gov.sa/commonapi/clp",
  );

  static final webCookieHeader = _initValues<String>(
    devVal: "BIGipServerssoappdev.momra.gov.sa.app~ssoappdev.momra.gov.sa_pool",
    stgVal: "BIGipServerssoappdev.momra.gov.sa.app~ssoappdev.momra.gov.sa_pool",
    preVal: "BIGipServerssoappstg.momra.gov.sa.app~ssoappstg.momra.gov.sa_pool",
    prodVal: "BIGipServerssoapp.balady.gov.sa.app~ssoapp.balady.gov.sa_pool",
    urbiPreVal:
        "BIGipServerssoappstg.momra.gov.sa.app~ssoappstg.momra.gov.sa_pool",
  );

  static final MSRAllowedMuncipalites = _initValues<List<String>>(
    devVal: [
      "007",
      "010",
      "016",
      "002",
      "008",
      "009",
      "012",
      "011",
      "013",
      "014",
      "015",
      "017",
      "018",
      "003",
      "005"
    ],
    stgVal: [
      "007",
      "010",
      "016",
      "002",
      "008",
      "009",
      "012",
      "011",
      "013",
      "014",
      "015",
      "017",
      "018",
      "003",
      "005"
    ],
    preVal: [
      "007",
      "010",
      "016",
      "002",
      "008",
      "009",
      "012",
      "011",
      "013",
      "014",
      "015",
      "017",
      "018",
      "003",
      "005"
    ],
    prodVal: [
      "007",
      "010",
      "016",
      "002",
      "008",
      "009",
      "012",
      "011",
      "013",
      "014",
      "015",
      "017",
      "018",
      "003",
      "005"
    ],
    urbiPreVal: [
      "007",
      "010",
      "016",
      "002",
      "008",
      "009",
      "012",
      "011",
      "013",
      "014",
      "015",
      "017",
      "018",
      "003",
      "005"
    ],
  );

  static final municipal_services_IDS = _initValues<Map<String, dynamic>>(
    devVal: {
      "survey_report_inquery": {
        "id": 11428,
        "Key_name": "license_query",
      },
      "inquiry_construction_license": {
        "id": 11124,
        "Key_name": "license_query",
      },
    },
    stgVal: {
      "survey_report_inquery": {
        "id": 11428,
        "Key_name": "license_query",
      },
      "inquiry_construction_license": {
        "id": 11124,
        "Key_name": "license_query",
      },
    },
    preVal: {
      "survey_report_inquery": {
        "id": 11632,
        "Key_name": "license_query",
      },
      "inquiry_construction_license": {
        "id": 11124,
        "Key_name": "license_query",
      },
    },
    prodVal: {
      "survey_report_inquery": {
        "id": 11632,
        "Key_name": "license_query",
      },
      "inquiry_construction_license": {
        "id": 11124,
        "Key_name": "license_query",
      },
    },
    urbiPreVal: {
      "survey_report_inquery": {
        "id": 11428,
        "Key_name": "license_query",
      },
      "inquiry_construction_license": {
        "id": 11124,
        "Key_name": "license_query",
      },
    },
  );

  static final ewaaUrl = _initValues<String>(
    devVal: "https://stgfees.momra.gov.sa/ewaa",
    stgVal: "https://stgfees.momra.gov.sa/ewaa",
    preVal: "https://stgfees.momra.gov.sa/ewaa",
    prodVal: "https://fees.balady.gov.sa/ewaa",
    urbiPreVal: "https://fees.balady.gov.sa/ewaa",
  );
  static Map<EnvType, T> _initValues<T>({
    dynamic devVal,
    dynamic stgVal,
    dynamic preVal,
    dynamic prodVal,
    dynamic urbiPreVal,
  }) =>
      {
        EnvType.dev: devVal,
        EnvType.stg: stgVal,
        EnvType.pre: preVal,
        EnvType.prod: prodVal,
        EnvType.urbiPre: urbiPreVal,
      };
}
