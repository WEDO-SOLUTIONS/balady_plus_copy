import '../../dependency_injection/dependency_injection_exports.dart' show sl;
import '../utils_exports.dart' show EnvType;

import 'package:flutter_dotenv/flutter_dotenv.dart';

class RemoteConfig {
  //////  Not Used
  static String get baladyToken => _RemoteConfig.baladyToken[env]!;
  static String get xBaladyToken => _RemoteConfig.xBaladyToken[env]!;
  // static String get ewaaUrl => _RemoteConfig.ewaaUrl[env]!;
  // static String get publicLicenseShareURL => _RemoteConfig.publicLicenseShareURL[env]!;

  ////   Not Used with API  used with downlod quran and image and open webView
  static String get baladyBaseUrl => _RemoteConfig.baladyBaseUrl[env]!;

  ////   Need Stop Using it
  // static String get pegaURL => _RemoteConfig.pegaURL[env]!;
  static String get gis => _RemoteConfig.gis[env]!;
  // static String get apigeeUsername => "__APIGEE-USERNAME__";
  static String get apigeeUsername {
    String apigeeUserName = '__APIGEE_USERNAME__';
    // String apigeeUserName = const String.fromEnvironment(
    //   'APIGEE_USERNAME',
    // );
    return apigeeUserName != "__APIGEE_USERNAME__"
        ? apigeeUserName
        : dotenv.env['APIGEE_USERNAME'] ?? "default"; // Get from .env
  }

  // static String get apigeePassword => "__APIGEE-PASSWORD__";
  static String get apigeePassword {
    String apigeePassword = '__APIGEE_PASSWORD__';
    // String apigeePassword = const String.fromEnvironment(
    //   'APIGEE_PASSWORD',
    // );
    return apigeePassword != "__APIGEE_PASSWORD__"
        ? apigeePassword
        : dotenv.env['APIGEE_PASSWORD'] ?? "default"; // Get from .env
  }

  ////   just used in one place in the app
  static String get webSiteUrl => _RemoteConfig.webSiteUrl[env]!;

  static String get baladyCommercialUrl => _RemoteConfig.baladyCommercialUrl[env]!;

  static String get publicAppointmentShareURL => _RemoteConfig.publicAppointmentShareURL[env]!;

  static String get damagedCarsClass => _RemoteConfig.damagedCarsClass[env]!;

  static String get regaClass => _RemoteConfig.regaClass[env]!;

  static List<String> get MSRAllowedMuncipalites => _RemoteConfig.MSRAllowedMuncipalites[env]!;

  //////////////////////////////////////////////////////
  //   static String get apigeeURL => "__APIGEE-URL__";
  static String get apigeeURL {
    String apigeeURL = '__APIGEE_URL__';
    // String apigeeURL = const String.fromEnvironment(
    //   'APIGEE_URL',
    // );
    return apigeeURL != "__APIGEE_URL__" ? apigeeURL : dotenv.env['APIGEE_URL'] ?? "default"; // Get from .env
  }

  // static String get hmCode => "__HM-CODE__";
  static String get hmCode {
    String hmCode = '__HM_CODE__';
    // String hmCode = const String.fromEnvironment(
    //   'HM_CODE',
    // );
    // print("HM_CODE : $hmCode");
    // print("HM_CODE : $hmCode");
    // print("HM_CODE : $hmCode");
    // print("HM_CODE : $hmCode");
    // print("HM_CODE : $hmCode");
    return hmCode != "__HM_CODE__" ? hmCode : dotenv.env['HM_CODE'] ?? "default"; // Get from .env
  }

  //////////////////////////////////////////////////////
  static String get ssoUrl => _RemoteConfig.ssoUrl[env]!;

  static String get ssoLoginUrl => _RemoteConfig.ssoLoginUrl[env]!;

  static String get ssoLogOutUrl => _RemoteConfig.ssoLogOutUrl[env]!;

  static String get ssoMomraDomain => _RemoteConfig.ssoMomraDomain[env]!;

  // static String get ssoSecret => "__SSO-SECRET__";
  static String get ssoSecret {
    String ssoSecret = '__SSO_SECRET__';
    // String ssoSecret = const String.fromEnvironment(
    //   'SSO_SECRET',
    // );
    return ssoSecret != "__SSO_SECRET__" ? ssoSecret : dotenv.env['SSO_SECRET'] ?? "default"; // Get from .env
  }

  // static String get ssoClient => "__SSO-CLINT__";
  static String get ssoClient {
    String ssoClient = '__SSO_CLINT__';
    // String ssoClient = const String.fromEnvironment(
    //   'SSO_CLINT'
    // );
    return ssoClient != "__SSO_CLINT__" ? ssoClient : dotenv.env['SSO_CLINT'] ?? "default"; // Get from .env
  }

  //////////////////////////////////////////////////////
  // BytePlus RangersAppLog (DataFinder) — read per-flavor from the loaded .env.
  // prod → .env.prod (10000002), stg/pre/dev → staging (10000000).
  static String get bytePlusAppId => dotenv.env['BYTEPLUS_APP_ID'] ?? '';

  static String get bytePlusAppName => dotenv.env['BYTEPLUS_APP_NAME'] ?? '';

  static String get bytePlusChannel => dotenv.env['BYTEPLUS_CHANNEL'] ?? 'TestFlight';

  static String get bytePlusAppKey => dotenv.env['BYTEPLUS_APP_KEY'] ?? '';

  static String get bytePlusAppUrl => dotenv.env['BYTEPLUS_APP_URL'] ?? '';

  static String get bytePlusUrlScheme => dotenv.env['BYTEPLUS_URL_SCHEME'] ?? '';

  //////////////////////////////////////////////////////
  static String get momraDomain => _RemoteConfig.momraDomain[env]!;

  static String get cookieURL => _RemoteConfig.cookieURL[env]!;

  static double get mapRadius => _RemoteConfig.mapRadius[env]!;

  static String get specialConditionOldId => _RemoteConfig.specialConditionOldId[env]!;

  static String get specialConditionId => _RemoteConfig.specialConditionId[env]!;

  // List<String> get munciplities => _RemoteConfig.munciplities[env]!;

  static String get webCookieHeader => _RemoteConfig.webCookieHeader[env]!;

  static List<String> get marketClass => _RemoteConfig.marketClass[env]!;

  static EnvType get env => sl<EnvType>();

  static Map<String, dynamic> get MunicipalServicesIDs => _RemoteConfig.municipal_services_IDS[env]!;

  // BaladyAnalytics (our own pipeline) — mode read per-flavor from the loaded
  // .env: legacy | dual | ours. Absent/unknown value falls back to `legacy`.
  static String get baladyAnalyticsMode => dotenv.env['BALADY_ANALYTICS_MODE'] ?? 'legacy';

  static String get movingVeichleCategoryKey => _RemoteConfig.movingVeichleCategoryKey[env]!;

  static String get QaseemCategoryKey => _RemoteConfig.QaseemCategoryKey[env]!;
}

//! First solution
class _RemoteConfig {
  // static final apigeeURL = _initValues<String>(
  //   devVal: "__DEV-APIGEE-URL__",
  //   stgVal: "__STG-APIGEE-URL__",
  //   preVal: "__PRE-APIGEE-URL__",
  //   prodVal: "__PROD-APIGEE-URL",
  //   urbiPreVal: "__STG-APIGEE-URL__",
  // );
  // static final hmCode = _initValues<String>(
  //   devVal: "__DEV-HM-CODE__",
  //   stgVal: "__STG-HM-CODE__",
  //   preVal: "__PRE-HM-CODE__",
  //   prodVal: "__PROD-HM-CODE__",
  //   urbiPreVal: "__STG-HM-CODE__",
  // );
  // static final apigeeUsername = _initValues<String>(
  //   devVal: "__DEV-APIGEE-USERNAME__",
  //   stgVal: "__STG-APIGEE-USERNAME__",
  //   preVal: "__PRE-APIGEE-USERNAME__",
  //   prodVal: "__PROD-APIGEE-USERNAME__",
  //   urbiPreVal: "__STG-APIGEE-USERNAME__",
  // );
  // static final apigeePassword = _initValues<String>(
  //   devVal: "__DEV-APIGEE-PASSWORD__",
  //   stgVal: "__STG-APIGEE-PASSWORD__",
  //   preVal: "__PRE-APIGEE-PASSWORD__",
  //   prodVal: "__PROD-APIGEE-PASSWORD__",
  //   urbiPreVal: "__STG-APIGEE-PASSWORD__",
  // );
  // static final ssoClient = _initValues<String>(
  //   devVal: "__DEV-SSO-CLINT__",//balady_mobile_app
  //   stgVal: "__STG-SSO-CLINT__",
  //   preVal: "__PRE-SSO-CLINT__",
  //   prodVal: "__PROD-SSO-CLINT__",
  //   urbiPreVal: "__STG-SSO-CLINT__",
  // );
  // static final ssoSecret = _initValues<String>(
  //   devVal: "__DEV-SSO-SECRET__",
  //   stgVal: "__STG-SSO-SECRET__",
  //   preVal: "__PRE-SSO-SECRET__",
  //   prodVal: "__PROD-SSO-SECRET__",
  //   urbiPreVal: "__STG-SSO-SECRET__",
  // );

  static final gis = _initValues<String>(
    devVal: "https://gisappstg.momra.gov.sa",
    stgVal: "https://gisappstg.momra.gov.sa",
    preVal: "https://gisappstg.momra.gov.sa",
    prodVal: "https://gisapps.momra.gov.sa",
    urbiPreVal: "https://gisappstg.momra.gov.sa",
  );

  /////////////////////////
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

  /////////////////////////
  static final cookieURL = _initValues<String>(
    devVal: "https://baladyapps.momra.gov.sa/",
    stgVal: "https://baladyapps.momra.gov.sa/",
    preVal: "https://prebaladyapps.momra.gov.sa/",
    prodVal: "https://apps.balady.gov.sa/",
    urbiPreVal: "https://prebaladyapps.momra.gov.sa/",
  );

  /////////////////////////

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
    urbiPreVal: "BIGipServerssoappstg.momra.gov.sa.app~ssoappstg.momra.gov.sa_pool",
  );

  static final MSRAllowedMuncipalites = _initValues<List<String>>(
    devVal: ["007", "010", "016", "002", "008", "009", "012", "011", "013", "014", "015", "017", "018", "003", "005"],
    stgVal: ["007", "010", "016", "002", "008", "009", "012", "011", "013", "014", "015", "017", "018", "003", "005"],
    preVal: ["007", "010", "016", "002", "008", "009", "012", "011", "013", "014", "015", "017", "018", "003", "005"],
    prodVal: ["007", "010", "016", "002", "008", "009", "012", "011", "013", "014", "015", "017", "018", "003", "005"],
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
      "005",
    ],
  );

  static final municipal_services_IDS = _initValues<Map<String, dynamic>>(
    devVal: {
      "CommercialLicenseRenew": {"id": 10485, "Key_name": "CommercialLicenseRenew"},
      "CommercialLicenseTransfer": {"id": 10502, "Key_name": "CommercialLicenseTransfer"},
      "CommercialLicenseCancel": {"id": 10492, "Key_name": "CommercialLicenseCancel"},
      "PostersLicenseService": {"id": 11820, "Key_name": "PostersLicenseService"},
      "PermitsLicenseService24H": {"id": 10528, "Key_name": "PermitsLicenseService24H"},
      "PermitsTobaccoLicense": {"id": 10526, "Key_name": "PermitsTobaccoLicense"},
      /////////  Not Used   //////////
      "survey_report_inquery": {"id": 11428, "Key_name": "license_query"},
      "inquiry_construction_license": {"id": 11124, "Key_name": "license_query"},
      "classification_certificate": {"id": 11340, "Key_name": "classification_certificate"},
      "create_complianceLocation": {"id": 11429, "Key_name": "create_complianceLocation"},
    },
    stgVal: {
      "CommercialLicenseRenew": {"id": 10485, "Key_name": "CommercialLicenseRenew"},
      "CommercialLicenseTransfer": {"id": 10502, "Key_name": "CommercialLicenseTransfer"},
      "CommercialLicenseCancel": {"id": 10492, "Key_name": "CommercialLicenseCancel"},
      "PostersLicenseService": {"id": 11946, "Key_name": "PostersLicenseService"},
      "PermitsLicenseService24H": {"id": 10528, "Key_name": "PermitsLicenseService24H"},
      "PermitsTobaccoLicense": {"id": 10526, "Key_name": "PermitsTobaccoLicense"},
      /////////  Not Used   //////////
      "survey_report_inquery": {"id": 11428, "Key_name": "license_query"},
      "inquiry_construction_license": {"id": 11124, "Key_name": "license_query"},
      "classification_certificate": {"id": 11340, "Key_name": "classification_certificate"},
      "create_complianceLocation": {"id": 11429, "Key_name": "create_complianceLocation"},
    },
    preVal: {
      "CommercialLicenseRenew": {"id": 10485, "Key_name": "CommercialLicenseRenew"},
      "CommercialLicenseTransfer": {"id": 10502, "Key_name": "CommercialLicenseTransfer"},
      "CommercialLicenseCancel": {"id": 10492, "Key_name": "CommercialLicenseCancel"},
      "PostersLicenseService": {"id": 11820, "Key_name": "PostersLicenseService"},
      "PermitsLicenseService24H": {"id": 10528, "Key_name": "PermitsLicenseService24H"},
      "PermitsTobaccoLicense": {"id": 10526, "Key_name": "PermitsTobaccoLicense"},
      /////////  Not Used   //////////
      "classification_certificate": {"id": 11380, "Key_name": "classification_certificate"},
      "survey_report_inquery": {"id": 11632, "Key_name": "license_query"},
      "inquiry_construction_license": {"id": 11124, "Key_name": "license_query"},
      "create_complianceLocation": {"id": 13701, "Key_name": "create_complianceLocation"},
    },
    prodVal: {
      "CommercialLicenseRenew": {"id": 10485, "Key_name": "CommercialLicenseRenew"},
      "CommercialLicenseTransfer": {"id": 10502, "Key_name": "CommercialLicenseTransfer"},
      "CommercialLicenseCancel": {"id": 10492, "Key_name": "CommercialLicenseCancel"},
      "PostersLicenseService": {"id": 11820, "Key_name": "PostersLicenseService"},
      "PermitsLicenseService24H": {"id": 10528, "Key_name": "PermitsLicenseService24H"},
      "PermitsTobaccoLicense": {"id": 10526, "Key_name": "PermitsTobaccoLicense"},
      /////////  Not Used   //////////
      "classification_certificate": {"id": 11380, "Key_name": "classification_certificate"},
      "survey_report_inquery": {"id": 11632, "Key_name": "license_query"},
      "inquiry_construction_license": {"id": 11124, "Key_name": "license_query"},
      "create_complianceLocation": {"id": 13701, "Key_name": "create_complianceLocation"},
    },
    urbiPreVal: {
      "CommercialLicenseRenew": {"id": 10485, "Key_name": "CommercialLicenseRenew"},
      "CommercialLicenseTransfer": {"id": 10502, "Key_name": "CommercialLicenseTransfer"},
      "CommercialLicenseCancel": {"id": 10492, "Key_name": "CommercialLicenseCancel"},
      "PostersLicenseService": {"id": 11820, "Key_name": "PostersLicenseService"},
      "PermitsLicenseService24H": {"id": 10528, "Key_name": "PermitsLicenseService24H"},
      "PermitsTobaccoLicense": {"id": 10526, "Key_name": "PermitsTobaccoLicense"},
      /////////  Not Used   //////////
      "survey_report_inquery": {"id": 11428, "Key_name": "license_query"},
      "inquiry_construction_license": {"id": 11124, "Key_name": "license_query"},
      "inquiry_construction_license": {"id": 11124, "Key_name": "license_query"},
      "create_complianceLocation": {"id": 11429, "Key_name": "create_complianceLocation"},
    },
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

  static final QaseemCategoryKey = _initValues<String>(
    devVal: "CG-61",
    stgVal: "CG-61",
    preVal: "CG-14",
    prodVal: "CG-14",
    urbiPreVal: "CG-61",
  );

  static Map<EnvType, T> _initValues<T>({
    dynamic devVal,
    dynamic stgVal,
    dynamic preVal,
    dynamic prodVal,
    dynamic urbiPreVal,
  }) => {
    EnvType.dev: devVal,
    EnvType.stg: stgVal,
    EnvType.pre: preVal,
    EnvType.prod: prodVal,
    EnvType.urbiPre: urbiPreVal,
  };
}
