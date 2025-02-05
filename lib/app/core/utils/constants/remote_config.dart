import '../../dependency_injection/dependency_injection_exports.dart' show sl;
import '../utils_exports.dart' show EnvType;

class RemoteConfig {

  //////  Not Used
  // static String get baladyToken => _RemoteConfig.baladyToken[env]!;
  // static String get xBaladyToken => _RemoteConfig.xBaladyToken[env]!;
  // static String get ewaaUrl => _RemoteConfig.ewaaUrl[env]!;
  // static String get publicLicenseShareURL => _RemoteConfig.publicLicenseShareURL[env]!;



  ////   Not Used with API  used with downlod quran and image and open webView
  static String get baladyBaseUrl => _RemoteConfig.baladyBaseUrl[env]!;

  ////   Need Stop Using it
  // static String get pegaURL => _RemoteConfig.pegaURL[env]!;
  // static String get gis => _RemoteConfig.gis[env]!;
  static String get apigeeUsername => _RemoteConfig.apigeeUsername[env]!;
  static String get apigeePassword => _RemoteConfig.apigeePassword[env]!;


  ////   just used in one place in the app
  static String get webSiteUrl => _RemoteConfig.webSiteUrl[env]!;
  static String get baladyCommercialUrl =>
      _RemoteConfig.baladyCommercialUrl[env]!;
  static String get publicAppointmentShareURL =>
      _RemoteConfig.publicAppointmentShareURL[env]!;
  static String get damagedCarsClass => _RemoteConfig.damagedCarsClass[env]!;
  static String get regaClass => _RemoteConfig.regaClass[env]!;
  static List<String> get MSRAllowedMuncipalites =>
      _RemoteConfig.MSRAllowedMuncipalites[env]!;


  //! First
  static String get apigeeURL => _RemoteConfig.apigeeURL[env]!;
  static String get hmCode => _RemoteConfig.hmCode[env]!;




  static String get ssoUrl => _RemoteConfig.ssoUrl[env]!;
  static String get ssoLoginUrl => _RemoteConfig.ssoLoginUrl[env]!;
  static String get ssoLogOutUrl => _RemoteConfig.ssoLogOutUrl[env]!;
  static String get ssoSecret => _RemoteConfig.ssoSecret[env]!;
  static String get momraDomain => _RemoteConfig.momraDomain[env]!;
  static String get ssoMomraDomain => _RemoteConfig.ssoMomraDomain[env]!;
  static String get cookieURL => _RemoteConfig.cookieURL[env]!;
  static String get ssoClient => _RemoteConfig.ssoClient[env]!;



  static double get mapRadius => _RemoteConfig.mapRadius[env]!;

  static String get specialConditionOldId =>
      _RemoteConfig.specialConditionOldId[env]!;
  static String get specialConditionId =>
      _RemoteConfig.specialConditionId[env]!;

  // List<String> get munciplities => _RemoteConfig.munciplities[env]!;



  static String get webCookieHeader => _RemoteConfig.webCookieHeader[env]!;
  static List<String> get marketClass => _RemoteConfig.marketClass[env]!;

  static EnvType get env => sl<EnvType>();



  static Map<String, dynamic> get MunicipalServicesIDs =>
      _RemoteConfig.municipal_services_IDS[env]!;


  static String get uxCamKey => _RemoteConfig.uxCamKey[env]!;

  static String get movingVeichleCategoryKey =>
      _RemoteConfig.movingVeichleCategoryKey[env]!;
}

//! First solution
class _RemoteConfig {

  static final uxCamKey = _initValues<String>(
    devVal: "",
    stgVal: "",
    preVal: "__PRE-UX-CAM-KEY__",
    prodVal: "__PROD-UX-CAM-KEY__",
    urbiPreVal: "",
  );
  static final hmCode = _initValues<String>(
    devVal: "__DEV-HM-CODE__",
    stgVal: "oxqUHJH1KXD84vP0KYBnyaHDUk5sJ9HkzqPDTice5TABqvfACZaLscG1TjjyPgIT",
    preVal: "__PRE-HM-CODE__",
    prodVal: "__PROD-HM-CODE__",
    urbiPreVal: "oxqUHJH1KXD84vP0KYBnyaHDUk5sJ9HkzqPDTice5TABqvfACZaLscG1TjjyPgIT",
  );

  static final apigeeURL = _initValues<String>(
    devVal: "__DEV-APIGEE-URL__",
    stgVal: "https://apiservicesstg.balady.gov.sa",
    preVal: "__PRE-APIGEE-URL__",
    prodVal: "__PROD-APIGEE-URL",
    urbiPreVal: "https://apiservicespp.balady.gov.sa",
  );

  static final apigeeUsername = _initValues<String>(
    devVal: "__DEV-APIGEE-USERNAME__",
    stgVal: "7RmIkhYi6v4M7GUibBrpFdZuo8NsL2CC",
    preVal: "__PRE-APIGEE-USERNAME__",
    prodVal: "__PROD-APIGEE-USERNAME__",
    urbiPreVal: "7RmIkhYi6v4M7GUibBrpFdZuo8NsL2CC",
  );

  static final apigeePassword = _initValues<String>(
    devVal: "__DEV-APIGEE-PASSWORD__",
    stgVal: "ak3JXde3KdBB1xbM",
    preVal: "__PRE-APIGEE-PASSWORD__",
    prodVal: "__PROD-APIGEE-PASSWORD__",
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


  static final publicAppointmentShareURL = _initValues<String>(
    devVal: "https://bldtrain.momra.gov.sa/commonapi/apt/",
    stgVal: "https://bldtrain.momra.gov.sa/commonapi/apt/",
    preVal: "https://bldtrain.momra.gov.sa/commonapi/apt/",
    prodVal: "https://ebalady.momra.gov.sa/commonapi/apt/",
    urbiPreVal: "https://bldtrain.momra.gov.sa/commonapi/apt/",
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
      "CommercialLicenseRenew": {
        "id": 10485,
        "Key_name": "CommercialLicenseRenew",
      },
      "CommercialLicenseTransfer": {
        "id": 10502,
        "Key_name": "CommercialLicenseTransfer",
      },
      "CommercialLicenseCancel": {
        "id": 10492,
        "Key_name": "CommercialLicenseCancel",
      },
      "PostersLicenseService": {
        "id": 11820,
        "Key_name": "PostersLicenseService",
      },
      "PermitsLicenseService24H": {
        "id": 10528,
        "Key_name": "PermitsLicenseService24H",
      },
      "PermitsTobaccoLicense": {
        "id": 10526,
        "Key_name": "PermitsTobaccoLicense",
      },
      /////////  Not Used   //////////
      "survey_report_inquery": {
        "id": 11428,
        "Key_name": "license_query",
      },
      "inquiry_construction_license": {
        "id": 11124,
        "Key_name": "license_query",
      },
      "classification_certificate": {
        "id": 11340,
        "Key_name": "classification_certificate",
      },
      "create_complianceLocation": {
        "id": 11429,
        "Key_name": "create_complianceLocation",
      },
    },
    stgVal: {
      "CommercialLicenseRenew": {
        "id": 10485,
        "Key_name": "CommercialLicenseRenew",
      },
      "CommercialLicenseTransfer": {
        "id": 10502,
        "Key_name": "CommercialLicenseTransfer",
      },
      "CommercialLicenseCancel": {
        "id": 10492,
        "Key_name": "CommercialLicenseCancel",
      },
      "PostersLicenseService": {
        "id": 11820,
        "Key_name": "PostersLicenseService",
      },
      "PermitsLicenseService24H": {
        "id": 10528,
        "Key_name": "PermitsLicenseService24H",
      },
      "PermitsTobaccoLicense": {
        "id": 10526,
        "Key_name": "PermitsTobaccoLicense",
      },
      /////////  Not Used   //////////
      "survey_report_inquery": {
        "id": 11428,
        "Key_name": "license_query",
      },
      "inquiry_construction_license": {
        "id": 11124,
        "Key_name": "license_query",
      },
      "classification_certificate": {
        "id": 11340,
        "Key_name": "classification_certificate",
      },
      "create_complianceLocation": {
        "id": 11429,
        "Key_name": "create_complianceLocation",
      },
    },
    preVal: {
      "CommercialLicenseRenew": {
        "id": 10485,
        "Key_name": "CommercialLicenseRenew",
      },
      "CommercialLicenseTransfer": {
        "id": 10502,
        "Key_name": "CommercialLicenseTransfer",
      },
      "CommercialLicenseCancel": {
        "id": 10492,
        "Key_name": "CommercialLicenseCancel",
      },
      "PostersLicenseService": {
        "id": 11820,
        "Key_name": "PostersLicenseService",
      },
      "PermitsLicenseService24H": {
        "id": 10528,
        "Key_name": "PermitsLicenseService24H",
      },
      "PermitsTobaccoLicense": {
        "id": 10526,
        "Key_name": "PermitsTobaccoLicense",
      },
      /////////  Not Used   //////////
      "classification_certificate": {
        "id": 11380,
        "Key_name": "classification_certificate",
      },
      "survey_report_inquery": {
        "id": 11632,
        "Key_name": "license_query",
      },
      "inquiry_construction_license": {
        "id": 11124,
        "Key_name": "license_query",
      },
      "create_complianceLocation": {
        "id": 13701,
        "Key_name": "create_complianceLocation",
      },
    },
    prodVal: {
      "CommercialLicenseRenew": {
        "id": 10485,
        "Key_name": "CommercialLicenseRenew",
      },
      "CommercialLicenseTransfer": {
        "id": 10502,
        "Key_name": "CommercialLicenseTransfer",
      },
      "CommercialLicenseCancel": {
        "id": 10492,
        "Key_name": "CommercialLicenseCancel",
      },
      "PostersLicenseService": {
        "id": 11820,
        "Key_name": "PostersLicenseService",
      },
      "PermitsLicenseService24H": {
        "id": 10528,
        "Key_name": "PermitsLicenseService24H",
      },
      "PermitsTobaccoLicense": {
        "id": 10526,
        "Key_name": "PermitsTobaccoLicense",
      },
      /////////  Not Used   //////////
      "classification_certificate": {
        "id": 11380,
        "Key_name": "classification_certificate",
      },
      "survey_report_inquery": {
        "id": 11632,
        "Key_name": "license_query",
      },
      "inquiry_construction_license": {
        "id": 11124,
        "Key_name": "license_query",
      },
      "create_complianceLocation": {
        "id": 13701,
        "Key_name": "create_complianceLocation",
      },
    },
    urbiPreVal: {
      "CommercialLicenseRenew": {
        "id": 10485,
        "Key_name": "CommercialLicenseRenew",
      },
      "CommercialLicenseTransfer": {
        "id": 10502,
        "Key_name": "CommercialLicenseTransfer",
      },
      "CommercialLicenseCancel": {
        "id": 10492,
        "Key_name": "CommercialLicenseCancel",
      },
      "PostersLicenseService": {
        "id": 11820,
        "Key_name": "PostersLicenseService",
      },
      "PermitsLicenseService24H": {
        "id": 10528,
        "Key_name": "PermitsLicenseService24H",
      },
      "PermitsTobaccoLicense": {
        "id": 10526,
        "Key_name": "PermitsTobaccoLicense",
      },
      /////////  Not Used   //////////
      "survey_report_inquery": {
        "id": 11428,
        "Key_name": "license_query",
      },
      "inquiry_construction_license": {
        "id": 11124,
        "Key_name": "license_query",
      },
      "inquiry_construction_license": {
        "id": 11124,
        "Key_name": "license_query",
      },
      "create_complianceLocation": {
        "id": 11429,
        "Key_name": "create_complianceLocation",
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

  static final movingVeichleCategoryKey = _initValues<String>(
    devVal: "CG-53",
    stgVal: "CG-53",
    preVal: "CG-53",
    prodVal: "CG-53",
    urbiPreVal: "CG-53",
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
