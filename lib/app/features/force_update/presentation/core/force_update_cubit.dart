import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:version/version.dart';

import '../../../../core/base/base_view_model.dart';
import '../../../../core/remote_services/api_constants.dart';
import '../../../../core/remote_services/pega_web_service.dart';
import '../../data/VersionInfo.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

part 'force_update_state.dart';


class ForceUpdateCubit extends Cubit<ForceUpdateState> {

  final webService = locator<PegaWebService>();

  ForceUpdateCubit() : super(const ForceUpdateState()) {
    getVersionInfo();
  }

  Future<bool> getVersionInfo() async {
    // try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersionNumber = packageInfo.version;
      String type = Platform.isAndroid ? "ANDROID" : "IOS";
      var isSuccess = false;
      var body;
        body = await webService
            .getApigeeRequest(
              ApiConstants.forceUpdate,
              queryParams: {
                'appID': "balady_mobile",
                'type': type,
              },
              autoLogout: false,
            )
            .timeout(
              const Duration(seconds: 10),
            );
        isSuccess = body["state"];
    

      if (isSuccess == true) {
        VersionInfo response =
            VersionInfo.fromJson(json.decode((body["data"])));
        return  compareVersion(
          currentVersionNumber,
          response.data?.result?.versionNumber,
          response.data?.result?.forceUpdate,
        );
      } else {
          emit(const NotHaveForceUpdateState());
      //   try {
      //     body = await webService
      //         .getApigeeRequest(
      //           ApiConstants.forceUpdate,
      //           queryParams: {
      //             'appID': "balady_mobile",
      //             'type': type,
      //           },
      //           autoLogout: false,
      //         )
      //         .timeout(const Duration(seconds: 10));
      //     isSuccess = body["state"];
      //   } catch (error, stackTrace) {
      //     LogsViewModel().sendEventFromModel(
      //       event: ErrorExceptionModel(
      //         nameEvent: EventsName.handledException,
      //         message: error.toString(),
      //         stackTrace: stackTrace.toString(),
      //       ),
      //     );
      //   }

      //   if (isSuccess == true) {
      //     VersionInfo response =
      //         VersionInfo.fromJson(json.decode((body["data"])));
      //   return compareVersion(
      //       currentVersionNumber,
      //       response.data?.result?.versionNumber,
      //       response.data?.result?.forceUpdate,
      //     );
      //   }
      }
    // } catch (error, stackTrace) {
    //   LogsViewModel().sendEventFromModel(
    //     event: ErrorExceptionModel(
    //       nameEvent: EventsName.handledException,
    //       message: error.toString(),
    //       stackTrace: stackTrace.toString(),
    //     ),
    //   );
    // }

    return false;
  }

  bool compareVersion(
      String? currentVersionNo, String? latestVersionNo, bool? forceUpdate)  {
    if (currentVersionNo != null &&
        latestVersionNo != null &&
        forceUpdate != null) {
      if (forceUpdate) {
        Version currentVersion = Version.parse(currentVersionNo);
        Version latestVersion = Version.parse(latestVersionNo);
        if (currentVersion < latestVersion) {
          emit(const HaveForceUpdateState());
          return true;
        }
      }
    }
    emit(const NotHaveForceUpdateState());
    return false;
  }
}
