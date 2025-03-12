import 'package:balady_plus/app/core/utils/constants/apis/env_types.dart';
import 'package:balady_plus/etmam_app/features/etmam_entry_point/presentation/cubit/etmam_entry_point_cubit.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:balady_plus/etmam_app/core/dependency_injection/injection_container.dart'
    show sl;
import 'package:balady_plus/etmam_app/core/utils/common_properties.dart';
import 'package:balady_plus/etmam_app/core/utils/constants/app_config.dart';
import 'package:balady_plus/etmam_app/core/utils/enums/order_status.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'constants/app_color.dart';
import 'constants/constans.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

import 'package:balady_plus/app/core/utils/common_functions.dart' as CommonFunctionsApp;

//FirebaseAnalytics fbAnalytics = FirebaseAnalytics.instance;

class CommonFunctions {
  static showError(String error) {
    if (error.isNotEmpty) {
      try {
        BotToast.showSimpleNotification(
            title: error,
            backgroundColor: const Color.fromARGB(255, 204, 51, 51),
            titleStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
                fontSize: 16.0),
            hideCloseButton: true,
            duration: const Duration(seconds: 3));
      } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
        //print(error);
      }
    }
  }

  static void sendEventToAnalytics(String event) {
    try {
      //fbAnalytics.logEvent(name: event);
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

  static void sendSentryLog(
      {String? url,
      String? qeuryParms,
      dynamic data,
      dynamic body,
      int? statusCode,
      String? errorMsg,
      dynamic headers,
      String enviroment = "Staging"}) async {
    /* //print("Send Log");
    try {
      SentryUser? user;

      String? userID = sl<EtmamEntryPointCubit>().state.profile?.nationalId;

      if (userID != null) {
        String? profileId = sl<EtmamEntryPointCubit>().state.profile?.id;
        String? mobile = sl<EtmamEntryPointCubit>().state.profile?.mobile;
        String? email = sl<EtmamEntryPointCubit>().state.profile?.email;
        String? name = sl<EtmamEntryPointCubit>().state.profile?.nameAr;
        user = SentryUser(id: userID, extras: {
          "profileId": profileId,
          //  "mobile": mobile,
          //  "email": email,
          //  "name": name
        });
      }
      Map<String, String>? headersMap;
      try {
        var headersM =
            headers != null ? headers as Map<String, dynamic>? : null;
        headersM?.remove("authorization");
        headersMap = headersM != null
            ? headersM
                .map((key, value) => MapEntry(key, value?.toString() ?? ""))
            : null;
      } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
        //print(error);
      }

      SentryMessage msg = SentryMessage(data != null ? data.toString() : "");
      SentryRequest req = SentryRequest(
          url: url,
          headers: headersMap,
          queryString: qeuryParms,
          data: body != null ? body.toString() : "",
          other: {"StatusCode": (statusCode ?? 0).toString()});
      SentryEvent event = SentryEvent(
        user: user,
        message: msg,
        request: req,
        release: CommonProperties.appVersion,
        environment: enviroment,
        tags: {"StatusCode": (statusCode ?? 0).toString()},
        exceptions: [SentryException(value: url ?? "", type: url)],
      );
      Sentry.captureEvent(event).then((value) => //print(value));
      //print("sent log");
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      //print("exx");
      //print(error);
    }*/
  }

  static sendExceptionLog({dynamic exception, dynamic response}) {
    try {
      CommonFunctions.sendSentryLog(
          body: response?.requestOptions.data,
          data: response?.data,
          qeuryParms: response?.requestOptions.queryParameters.toString(),
          url: exception.toString(),
          statusCode: response?.statusCode,
          headers: response?.requestOptions.headers,
          enviroment: sl<EnvType>().name);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      //print(error);
    }
  }

  static externalLaunch(String url) async {
    final Uri convertUrl = Uri.parse(url);
    if (!await launchUrl(convertUrl, mode: LaunchMode.externalApplication))
      throw 'Could not launch $convertUrl';
  }

  static launch(String url) async {
    final Uri convertUrl = Uri.parse(url);
    if (!await launchUrl(convertUrl)) throw 'Could not launch $convertUrl';
  }

  static void launchMap(LatLng? location) async {
    if (location != null) {
      // final url =
      //     'https://www.google.com/maps/search/?api=1&query=${location.latitude},${location.longitude}';
      CommonFunctionsApp.CommonFunctions.openMap(location.latitude, location.longitude);
    }
  }

  static void call(String? number) async {
    if (number != null && number.isNotEmpty) {
      await CommonFunctions.launch("tel://$number");
    } else {
      showError(trans("errors_phone_not_exists"));
    }
  }

  static String getFormattedTime(String? timeStr,
      {Duration? subtractedDuration}) {
    String formattedTime = "";
    try {
      String biddingEndingTime = timeStr ?? "";
      DateTime tempTime = DateFormat("hh:mm").parse(biddingEndingTime);
      String time = DateFormat("h:mm a", 'ar_SA').format(tempTime).toString();
      formattedTime = time;
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      //print(error);
    }
    return replaceArabicNumberWithEnglish(formattedTime);
  }

  static String replaceArabicNumberWithEnglish(String value) {
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

  static String convertDayNameFromEnglishToArabic(String dayName) {
    switch (dayName.toLowerCase()) {
      case "sunday":
        return "الأحد";
      case "monday":
        return "الأثنين";
      case "tuesday":
        return "الثلاثاء";
      case "wednesday":
        return "الأربعاء";
      case "thursday":
        return "الخميس";
      case "friday":
        return "الجمعه";
      case "saturday":
        return "السبت";
      default:
        return dayName;
    }
  }

  static OrderStatus getOrderStatus(String? statusId) {
    switch (statusId) {
      case Constants.waitingForApproval:
        return OrderStatus.waitingForApproval;
      case Constants.approved:
        return OrderStatus.approved;
      case Constants.canceled:
        return OrderStatus.canceled;
      case Constants.rejected:
        return OrderStatus.rejected;
      case Constants.inProgress:
        return OrderStatus.inProgress;
      case Constants.startFailed:
        return OrderStatus.startFailed;
      case Constants.completed:
        return OrderStatus.completed;
      case Constants.failed:
        return OrderStatus.failed;
      default:
        return OrderStatus.waitingForApproval;
    }
  }

  static String generateGUID() {
    try {
      String v1UUID = CommonProperties.uuidInstance.v1();
      String v5UUID =
          CommonProperties.uuidInstance.v5(v1UUID, CommonProperties.deviceId);
      //print("v5UUID");
      //print(v5UUID);
      if (v5UUID.isNotEmpty)
        return v5UUID.replaceAll("-", "");
      else if (v1UUID.isNotEmpty)
        return v1UUID.replaceAll("-", "");
      else
        return DateTime.now().millisecondsSinceEpoch.toString();
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      //print("EXXXXXX GUId");
      //print(error);
      return DateTime.now().millisecondsSinceEpoch.toString();
    }
  }

  static Color getMainServiceColor(int index) {
    int servicesIndex = index;
    while (servicesIndex >= AppColor.servicesBackgroundColors.length) {
      servicesIndex = servicesIndex - AppColor.servicesBackgroundColors.length;
    }
    return AppColor.servicesBackgroundColors[servicesIndex];
  }
}
