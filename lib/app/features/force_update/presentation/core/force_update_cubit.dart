import 'package:balady_plus/app/core/remote_services/api_constants.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:version/version.dart';

import '../../data/VersionInfo.dart';

part 'force_update_state.dart';

class ForceUpdateCubit extends Cubit<ForceUpdateState> {
  final webService = sl<WebService>();

  ForceUpdateCubit() : super(const ForceUpdateState()) {
    getVersionInfo();
  }

  Future<bool> getVersionInfo() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersionNumber = packageInfo.version;
      String type = Platform.isAndroid ? "ANDROID" : "IOS";
      Response respons;
      respons = await webService.dio.get(
        ApiConstants.forceUpdate,
        queryParameters: {
          'appID': "balady_mobile",
          'type': type,
        },
      );
      VersionInfo response = VersionInfo.fromJson(respons.data);
      return compareVersion(
        currentVersionNumber,
        response.data?.result?.versionNumber,
        response.data?.result?.forceUpdate,
      );
    } catch (error, stackTrace) {
      emit(const NotHaveForceUpdateState());
      // Log the error if needed
      print("Error fetching version info: $error");
      print("Stack trace: $stackTrace");
    }
    return false;
  }

  bool compareVersion(
    String? currentVersionNo,
    String? latestVersionNo,
    bool? forceUpdate,
  ) {
    // if (currentVersionNo != null &&
    //     latestVersionNo != null &&
    //     forceUpdate != null) {
    //   if (forceUpdate) {
    //     Version currentVersion = Version.parse(currentVersionNo);
    //     Version latestVersion = Version.parse(latestVersionNo);
    //     if (currentVersion < latestVersion) {
    //       emit(const HaveForceUpdateState());
    //       return true;
    //     }
    //   }
    // }
    emit(const NotHaveForceUpdateState());
    return false;
  }
}
