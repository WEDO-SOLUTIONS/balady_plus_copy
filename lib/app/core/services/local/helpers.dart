import 'dart:async';
import 'dart:developer' as devtools show log;
import 'dart:io';

import 'package:balady_plus/app/core/services/services_exports.dart'
    show NavigationService;
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/balady_analytics/balady_analytics.dart';
import 'package:geolocator/geolocator.dart' as geo_locator;
import 'package:geolocator/geolocator.dart';
import 'package:localize_and_translate/localize_and_translate.dart'
    show translator, Translation;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../../features/_shared_feature_/presentation/dialogs/photo_permission_dialog.dart';
import '../../../features/bottom_navigation/presentation/cubits/bottom_nav_bar_cubit.dart';
import '../../dependency_injection/injection_container.dart';

// use it insead of print() or debugPrint()
extension Log<T extends Object> on T {
  void log() {
    devtools.log(toString());
  }
}

//FirebaseAnalytics fbAnalytics = FirebaseAnalytics.instance;

class Helpers {
  //static String translatingWord(String key) => key.tr();

  static String translatingWord(String key) => key.tr();

  static bool isArabic(BuildContext context) =>
      translator.isDirectionRTL(context);

  static bool isRTL() => translator.activeLanguageCode == 'ar';

  static String getCurrentLanguageCode() => translator.activeLanguageCode;

  /*static List<String> getListOfAppLanguages() =>
      Constants.defaultAppLanguage == APP_SUPPORTED_LANGUAGES.ar
          ? <String>['ar', 'en']
          : <String>['en', 'ar'];*/

  static bool isBiometricAvailable = true;

  static void backNavigationToHomeScreen({int index = 0}) {
    sl<BottomNavBarCubit>().onChangeBottomNavBar(index);
    NavigationService.navigatorKey.currentState!.popUntil(
      ModalRoute.withName(RouteName.bottomNavigation),
    );
  }

  /*
  static void backNavigationToSpecificScreen({
    String? navigationKey,
    Object? arguments,
  }) {
    if (NavigationService.navigatorKey.currentState!.canPop()) {
      NavigationService.navigatorKey.currentState!.pop();
    } else {
      NavigationService.navigatorKey.currentState!.pushNamedAndRemoveUntil(
        // navigationKey ?? RoutesNames.BOTTOM_NAVIGATION_ROUTE,
        navigationKey ?? RoutesNames.splashRoute,
        (route) => false,
        arguments: arguments,
      );
    }
  }

  static void backNavigationToSpecificScreen2({
    String? navigationKey,
    Object? arguments,
  }) {
    NavigationService.navigatorKey.currentState!.pushNamedAndRemoveUntil(
      navigationKey ?? RoutesNames.splashRoute,
      (route) => false,
      arguments: arguments,
    );
  }





  static void goToSpecificTabInBottomNavigation(int index) {
    NavigationService.navigatorKey.currentState!
        .pushReplacement(MaterialPageRoute(
            builder: (context) => BottomNavigationScreen(
                //  bottomTabIndex: index,
                )));
  }




*/

  static Future<LatLng?> getMapLocation() async {
    return await getCurrentLocation(
      accuracy: geo_locator.LocationAccuracy.medium,
      duration: const Duration(seconds: 5),
    );
  }

  static Future<LatLng?> getCurrentLocation({
    geo_locator.LocationAccuracy? accuracy,
    Duration? duration,
  }) async {
    try {
      bool isHuawei = await CommonFunctions.isHuaweiDevice();
      if (isHuawei) {
        final latLng = await CommonFunctions.getCurrentLocationHuawei();
        return latLng;
      }
      //  EasyLoading.show();
      geo_locator.Position position = await geo_locator
          .Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: accuracy ?? geo_locator.LocationAccuracy.high,
          timeLimit: duration ?? const Duration(seconds: 13),
        ),
      );
      //    EasyLoading.dismiss();
      return LatLng(latitude: position.latitude, longitude: position.longitude);
    } catch (error, stackTrace) {
      return CommonFunctions.handelLocationCatch(false, error, stackTrace);
    }
  }

  static Future<bool> checkPhotosSettings(BuildContext context) async {
    var status = await Permission.photos.request();

    if (status == PermissionStatus.permanentlyDenied) {
      showDialog(
        context: context,
        builder: (ctx) => const PhotoPermissionDialog(),
      );
      return false;
    } else if (status != PermissionStatus.granted) {
      Permission.photos.request();
      return false;
    } else {
      return true;
    }
  }

  /* static String getCRMType(CRM_REQUEST_TYPE? type) {
    switch (type) {
      case CRM_REQUEST_TYPE.req:
        return Helpers.translatingWord("customerVoiceRequestServiceCardWord");
      case CRM_REQUEST_TYPE.inc:
        return Helpers.translatingWord("customerVoiceReportsCardWord");
      case CRM_REQUEST_TYPE.daem:
        return Helpers.translatingWord("customerVoiceTechnicalSupportCardWord");
      case CRM_REQUEST_TYPE.inq:
        return Helpers.translatingWord("customerVoiceInquiriesCardWord");
      default:
        return Helpers.translatingWord("customerVoiceInquiriesCardWord");
    }
  }

  static String getCRMIconBasedType(CRM_REQUEST_TYPE? type) {
    switch (type) {
      case CRM_REQUEST_TYPE.req:
        return Constants.customerVoiceComplaintIcon;
      case CRM_REQUEST_TYPE.inc:
        return Constants.customerVoiceReportsIcon;
      case CRM_REQUEST_TYPE.daem:
        return Constants.customerVoiceTechnicalSupportIcon;
      case CRM_REQUEST_TYPE.inq:
        return Constants.customerVoiceInquiriesIcon;
      default:
        return Constants.customerVoiceReportsIcon;
    }
  }

  static String getCRMIconBasedTypeCard(CRM_REQUEST_TYPE? type) {
    switch (type) {
      case CRM_REQUEST_TYPE.req:
        return Constants.customerVoiceRequestServiceIconCard;
      case CRM_REQUEST_TYPE.inc:
        return Constants.customerVoiceReportsIconCard;
      case CRM_REQUEST_TYPE.daem:
        return Constants.customerVoiceTechnicalSupportIconCard;
      case CRM_REQUEST_TYPE.inq:
        return Constants.customerVoiceInquiriesIconCard;
      default:
        return Constants.customerVoiceReportsIconCard;
    }
  }*/

  static String? validatePhone(String? phone) {
    if (phone != null && int.tryParse(phone) != null && phone.length > 3) {
      if (phone.length == 10 && phone.startsWith("05")) {
        return null;
      } else {
        return ("mobile_number_err1").tr();
      }
    } else {
      return ("mobile_number_err1").tr();
    }
  }

  static String? validateIBAN(String? iban) {
    RegExp phoneReg = RegExp(r'^(SA)([0-9]{22})$');

    if (!phoneReg.hasMatch(iban ?? "")) {
      return ('please_enter_valid_iban').tr();
    }

    return null;
  }

  static String? validateMobile(String? phone) {
    RegExp phoneReg = RegExp(r'^(05)([0-9]{8})$');

    if (!phoneReg.hasMatch(phone ?? "")) {
      return ('mobile_err').tr();
    }

    return null;
  }

  static String? validateEmail(String? email) {
    RegExp emailPattern = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    );
    String e = email ?? "";
    e = e.replaceAll("\u200e", '').replaceAll("\u200f", '').trim();
    if (e.isEmpty) {
      return ('lbl_email_err1').tr();
    } else if (!emailPattern.hasMatch(e)) {
      return ('lbl_email_err1').tr();
    }

    return null;
  }

  static String changeToEnglish(String value) {
    var newStr = "";

    for (int i = 0; i < value.length; i++) {
      switch (value[i]) {
        case "٠":
          newStr += "0";
          break;
        case "١":
          newStr += "1";
          break;
        case "٢":
          newStr += "2";
          break;
        case "٣":
          newStr += "3";
          break;
        case "٤":
          newStr += "4";
          break;
        case "٥":
          newStr += "5";
          break;
        case "٦":
          newStr += "6";
          break;
        case "٧":
          newStr += "7";
          break;
        case "٨":
          newStr += "8";
          break;
        case "٩":
          newStr += "9";
          break;
        default:
          newStr += value[i];
      }
    }
    return newStr.isEmpty ? value : newStr;
  }

  static void sendLog({
    String? url,
    String? qeuryParms,
    dynamic data,
    dynamic body,
    int? statusCode,
    String? errorMsg,
  }) async {
    try {
      SentryRequest request = SentryRequest(
        url: url,
        queryString: qeuryParms,
        data: {
          if (body != null)
            'body': body != null ? body.toString() : "",
            "StatusCode": (statusCode ?? 0).toString(),
        },
      );
      SentryMessage sentryMessage = SentryMessage(
        data != null ? data.toString() : "",
      );

      SentryUser sentryUser = SentryUser(
        id: CommonProperties.userInfo?.idNo,
        name: CommonProperties.userInfo?.arName,
        email: "",
      );

      SentryEvent event = SentryEvent(
        user: sentryUser,
        request: request,
        message: sentryMessage,
        transaction: url,
        tags: {"StatusCode": (statusCode ?? 0).toString()},
        environment: sl<EnvType>().name,
        exceptions: [SentryException(value: url ?? "", type: url)],
      );
      Sentry.captureEvent(event);

      if (BaladyAnalytics.instance.mode.sendToOurs) {
        String data = body != null ? body.toString() : "";

        String queryString = qeuryParms ?? "";

        String message = data.toString();
        String? URL = url;

        if (URL != null) {
          BaladyAnalytics.instance.track(url ?? "Error", properties: {
            "Url": URL.length <= 1024 ? URL : URL.substring(0, 1023),
            "Data": data.length <= 1024 ? data : data.substring(0, 1023),
            "QueryString":
                queryString.length <= 1024
                    ? queryString
                    : queryString.substring(0, 1023),
            "Message":
                message.length <= 1024 ? message : message.substring(0, 1023),
            "Environment": sl<EnvType>().name,
          });
        }
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
  }

  static String? getDaemValue(String? value) {
    //return value != null ? value.split("-").last : value;
    return value;
  }

  /*static void sendEventToAnalytics(String event) {
    try {
      fbAnalytics.logEvent(name: event);
    } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
  }*/

  /*static void sendSuccessEvent(PAGE_TYPE type) {
    try {
      switch (type) {
        case PAGE_TYPE.appointmentScreen:
          sendEventToAnalytics(AppEvents.Appointments_Apply_Success);
          break;
        case PAGE_TYPE.cancelAppointment:
          sendEventToAnalytics(AppEvents.Appointments_Cancel_Success);

          break;
        case PAGE_TYPE.coObserver:
          sendEventToAnalytics(AppEvents.CO_Observer_Success);

          break;
        case PAGE_TYPE.deleteRequestScreen:
          sendEventToAnalytics(AppEvents.HealthCertificate_Delete);

          break;

        case PAGE_TYPE.incidentsScreen:
          sendEventToAnalytics(AppEvents.CustomerSound_incident_success);

          break;
        case PAGE_TYPE.msr:
          sendEventToAnalytics(AppEvents.CustomerSound_msr_success);

          break;
        case PAGE_TYPE.qrDetailsScreen:
        case PAGE_TYPE.qrDialog:
          sendEventToAnalytics(AppEvents.CustomerSound_incident_qr_success);

          break;

        case PAGE_TYPE.ratingScreen:
          break;
        default:
      }
    } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
  }*/

  /* static openFile(Uint8List bytes, {String? contentType}) async {
    String extension =
        contentType != null ? ("." + contentType.split("/").last) : "";
    try {
      if (extension.isNotEmpty) {
        String dir = (await getTemporaryDirectory()).path;
        File filetemp = File("$dir/" +
            "${DateTime.now().millisecondsSinceEpoch.toString()}$extension");
        await filetemp.writeAsBytes(bytes);
        //print(filetemp.path);
        // OpenFile.open(filetemp.path);
        Share.shareFiles([filetemp.path]);
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );

    }
  }

  static openFileLocal(Uint8List bytes, {String? contentType}) async {

    String extension =
        contentType != null ? ("." + contentType.split("/").last) : "";
    try {
      if (extension.isNotEmpty) {
        String dir = (await getTemporaryDirectory()).path;
        File filetemp = File("$dir/" +
            "${DateTime.now().millisecondsSinceEpoch.toString()}$extension");
        await filetemp.writeAsBytes(bytes);

        OpenFilex.open(filetemp.path);
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );

      try {
        sendLog(
            url: "OpenLoocalFile", data: error.toString(), body: error.toString());
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
    }
  }

  void showFile(Uint8List bytes, {required String contentType}) async {
    try {
      if (contentType.toLowerCase().contains("pdf")) {
        Navigator.push(
            NavigationService.navigatorKey.currentContext!,
            MaterialPageRoute(
                builder: (context) => PDFViewer(
                      file: bytes,
                      title: "",
                    )));
      } else if (contentType.toLowerCase().contains(".png") ||
          contentType.toLowerCase().contains(".jpeg") ||
          contentType.toLowerCase().contains(".jpg")) {
        Navigator.push(
            NavigationService.navigatorKey.currentContext!,
            MaterialPageRoute(
                builder: (context) => FullImageViewBytes(imageBase64: bytes)));
      } else {
        String extension =
            contentType != null ? ("." + contentType.split("/").last) : "";
        try {
          if (extension.isNotEmpty) {
            String dir = (await getTemporaryDirectory()).path;
            File filetemp = File("$dir/" +
                "${DateTime.now().millisecondsSinceEpoch.toString()}$extension");
            await filetemp.writeAsBytes(bytes);
            //print(filetemp.path);
            OpenFilex.open(filetemp.path);
          }
        } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );

        }
      }
    } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
  }

  static String getCRMDateStr(String? value) {
    if (value != null) {
      DateTime date = DateTime.parse(value!);
      String locale = "ar";

      String dateStr = date != null ? DateFormat.yMd(locale).format(date) : "";
      return replaceArabicNumberWithEnglish(dateStr);
    }
    return "";
  }

  static String getCRMDate(DateTime? value) {
    if (value != null) {
      DateTime date = value;
      String locale = "ar";

      String dateStr = date != null ? DateFormat.yMd(locale).format(date) : "";
      return replaceArabicNumberWithEnglish(dateStr);
    }
    return "";
  }*/

  static Future<void> openFile(Uint8List bytes, {String? contentType}) async {
    String extension =
        contentType != null ? (".${contentType.split("/").last}") : "";
    try {
      if (extension.isNotEmpty) {
        String dir = (await getTemporaryDirectory()).path;
        File filetemp = File(
          "$dir/"
          "${DateTime.now().millisecondsSinceEpoch.toString()}$extension",
        );
        await filetemp.writeAsBytes(bytes);
        //print(filetemp.path);
        OpenFilex.open(filetemp.path);
        //  Share.shareFiles([filetemp.path]);
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
  }

  static void backToHome() {
    try {
      CommonFunctions.showError("session_ended_error".tr());
      NavigationService.navigatorKey.currentState!.popUntil((route) {
        if (route.settings.name == RouteName.bottomNavigation ||
            route.settings.name == null) {
          return true;
        }
        return false;
      });
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
  }
}
