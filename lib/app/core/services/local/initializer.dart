import 'dart:io' show Platform;

import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:package_info_plus/package_info_plus.dart';

import '../../../features/_shared_feature_/data/entities/device_details.dart';
import '../../../features/_shared_feature_/data/entities/package_details.dart';
import '../../dependency_injection/dependency_injection_exports.dart' show sl;

class Initializer {
  static Future<void> init() async {
    // di: dependency injection

    // Initialize hive and open all needed boxes
    // await HiveManager.initializeHive();
    await registerDeviceDetails();
    await registerPackageDetails();

    // await sentryInit();
  }

  static Future<void> registerDeviceDetails() async {
    String? deviceName;
    String? deviceId;
    String? deviceOs;
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        final info = await deviceInfoPlugin.androidInfo;
        // deviceName = info.brand;
        deviceName = info.model;
        // deviceId = info.androidId + CommonFunctions.generateRandomString(10);
        deviceId = info.id;
        deviceOs = "ANDROID";
      } else if (Platform.isIOS) {
        final info = await deviceInfoPlugin.iosInfo;
        deviceName = info.name ?? info.utsname.machine;
        deviceId = info.identifierForVendor ?? "2"; //UUID for iOS
        deviceOs = "iOS";
      }
    } on PlatformException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }

    final details = sl<DeviceDetails>().copyWith(deviceName: deviceName, deviceId: deviceId, deviceOs: deviceOs);
    await sl.unregister<DeviceDetails>();
    sl.registerLazySingleton(() => details);
  }

  static Future<void> registerPackageDetails() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

    final details = sl<PackageDetails>().copyWith(
      appName: appName,
      packageName: packageName,
      version: version,
      buildNumber: buildNumber,
    );
    await sl.unregister<PackageDetails>();
    sl.registerLazySingleton(() => details);
  }

  static Future<void> sentryInit() async {
    // await SentryFlutter.init(
    //     (options) => options.dsn =
    //         'https://0e5806da9c6d44bcb7350bb722562e63@o303998.ingest.sentry.io/5301848',
    //     appRunner: () => runApp(LocalizedApp(child: const App())));
  }
}
