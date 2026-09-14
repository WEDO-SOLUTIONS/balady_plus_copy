import 'package:balady_plus/app/core/remote_services/api_constants.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:version/version.dart';

import '../../data/VersionInfo.dart';

part 'force_update_state.dart';

class ForceUpdateCubit extends Cubit<ForceUpdateState> {
  final webService = sl<WebService>();

  ForceUpdateCubit() : super(const ForceUpdateState()) {
    debugPrint('FORCE_UPDATE DEBUG: ForceUpdateCubit constructor called, starting getVersionInfo');
    getVersionInfo();
  }

  Future<bool> getVersionInfo() async {
    try {
      debugPrint('FORCE_UPDATE DEBUG: Starting version check...');
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersionNumber = packageInfo.version;
      String type = Platform.isAndroid ? "ANDROID" : "IOS";
      debugPrint('FORCE_UPDATE DEBUG: Current version: $currentVersionNumber, Platform: $type');

      debugPrint('FORCE_UPDATE DEBUG: Making network request to ${ApiConstants.forceUpdate}');
      Response respons;
      respons = await webService.dio.get(
        ApiConstants.forceUpdate,
        queryParameters: {'appID': "balady_mobile", 'type': type},
      );
      debugPrint('FORCE_UPDATE DEBUG: Network request completed successfully');

      VersionInfo response = VersionInfo.fromJson(respons.data);
      return compareVersion(
        currentVersionNumber,
        response.data?.result?.versionNumber,
        response.data?.result?.forceUpdate,
      );
    } catch (error, stackTrace) {
      debugPrint('FORCE_UPDATE DEBUG: Network request failed: $error');
      emit(const NotHaveForceUpdateState());
      // Log the error if needed
      debugPrint("Error fetching version info: $error");
      debugPrint("Stack trace: $stackTrace");
    }
    return false;
  }

  bool compareVersion(String? currentVersionNo, String? latestVersionNo, bool? forceUpdate) {
    debugPrint(
      'FORCE_UPDATE DEBUG: Comparing versions - Current: $currentVersionNo, Latest: $latestVersionNo, ForceUpdate: $forceUpdate',
    );

    if (currentVersionNo != null && latestVersionNo != null && forceUpdate != null) {
      if (forceUpdate) {
        Version currentVersion = Version.parse(currentVersionNo);
        Version latestVersion = Version.parse(latestVersionNo);
        if (currentVersion < latestVersion) {
          debugPrint('FORCE_UPDATE DEBUG: Force update required, emitting HaveForceUpdateState');
          emit(const HaveForceUpdateState());
          return true;
        }
      }
    }
    debugPrint('FORCE_UPDATE DEBUG: No force update needed, emitting NotHaveForceUpdateState');
    emit(const NotHaveForceUpdateState());
    return false;
  }
}
