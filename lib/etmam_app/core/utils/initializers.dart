import 'dart:io';

import 'package:balady_plus/app/core/services/local/shared_prefs_manager.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show
        CommonProperties,
        AppConfig,
        AppColorsTheme,
        CommonProperties,
        CommonFunctions;
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class Initializers {
  static void loadData() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      CommonProperties.appVersion = packageInfo.version;
      if (Platform.isAndroid) {
        CommonProperties.deviceOs = "ANDROID"; //MM
        CommonProperties.deviceId =
            (await DeviceInfoPlugin().androidInfo).id ?? "1";
        CommonProperties.deviceName =
            (await DeviceInfoPlugin().androidInfo).brand ?? "ANDROID";
      } else {
        CommonProperties.deviceOs = "IOS";

        CommonProperties.deviceId =
            (await DeviceInfoPlugin().iosInfo).identifierForVendor ?? "1";
        CommonProperties.deviceName = (await DeviceInfoPlugin().iosInfo).name;
      }
      CommonProperties.sessionId = CommonFunctions.generateGUID();
      //CommonProperties.cityId = sharedPrefs.getCity()?.id ?? "";
      // Theme: init Theme
      AppColorsTheme.setTheme(CommonProperties.cityId);
      var ip;
      try {
        ip = await Ipify.ipv4(format: Format.TEXT);
      } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
        try {
          ip = await NetworkInfo().getWifiIP();
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

      try {
        CommonProperties.clientIP = ip.toString();
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

      if (CommonProperties.clientIP == null ||
          (CommonProperties.clientIP != null &&
              CommonProperties.clientIP!.isEmpty)) {
        CommonProperties.clientIP = "1";
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
    }
  }
}
