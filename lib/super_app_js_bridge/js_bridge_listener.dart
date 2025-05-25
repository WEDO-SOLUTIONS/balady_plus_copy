import 'dart:convert';
import 'dart:io';

import 'package:balady_plus/app/core/services/local/helpers.dart';
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/need_login_dialog.dart';
import 'package:balady_plus/super_app_js_bridge/model/access_token_model.dart';
import 'package:balady_plus/super_app_js_bridge/model/base_response.dart';
import 'package:balady_plus/super_app_js_bridge/model/js_file_model.dart';
import 'package:balady_plus/super_app_js_bridge/model/js_preferences_model.dart';
import 'package:balady_plus/super_app_js_bridge/model/location_model.dart';
import 'package:balady_plus/super_app_js_bridge/model/user_profile_model.dart';
import 'package:dgis_map/library.dart';
import 'package:dsbridge_flutter/dsbridge_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app/core/dependency_injection/injection_container.dart';
import '../app/features/entry_point/domain/use_cases/get_cookie.dart';

class JsBridgeListener extends JavaScriptNamespaceInterface {
  @override
  void register() {
    registerFunction(getAccessToken);
    registerFunction(getCookies);
    registerFunction(getUserProfile);
    registerFunction(getAppPreferences);
    registerFunction(navigateToSuperAppScreen);
    registerFunction(getLocation);
    registerFunction(openCamera);
    registerFunction(openFilePicker);
    registerFunction(openShare);
    registerFunction(jsLaunchUri);
    registerFunction(trackEvent);
    registerFunction(trackLogsErrors);
    registerFunction(openDirectionsMap);
    registerFunction(openWebView);
    registerFunction(checkPermission);
  }

  // Done
  @pragma('vm:entry-point')
  void getAccessToken(dynamic msg, CompletionHandler handler) async {
    late BaseResponse response;
    if (CommonProperties.isLoggedIn) {
      response = BaseResponse(
        code: 200,
        message: "success",
        eventName: "getAccessToken",
        data: AccessTokenModel(
          accessToken: CommonProperties.token,
        ),
      );
      handler.complete(response.jsonEncodeModel());
    } else {
      await showDialog(
        context: NavigationService.navigatorKey.currentContext!,
        builder: (ctx) => NeedLoginDialog(
          onSuccessLogin: (bool? isSuccess) async {
            if (isSuccess ?? false) {
              response = BaseResponse(
                code: 200,
                message: "success",
                eventName: "getAccessToken",
                data: AccessTokenModel(
                  accessToken: CommonProperties.token,
                ),
              );
            } else {
              BaseResponse response = BaseResponse(
                code: 401,
                eventName: "getAccessToken",
                message: "Unauthorized",
                data: null,
              );
            }
          },
        ),
      );
    }
    handler.complete(response.jsonEncodeModel());
  }

  @pragma('vm:entry-point')
  void getUserProfile(dynamic msg, CompletionHandler handler) {
    if (CommonProperties.isLoggedIn) {
      BaseResponse response = BaseResponse(
        code: 200,
        message: "success",
        eventName: "getUserProfile",
        data: UserProfileModel.fromJson(CommonProperties.userInfo!.toJson()),
      );
      handler.complete(response.jsonEncodeModel());
    } else {
      BaseResponse response = BaseResponse(
        code: 401,
        message: "Unauthorized",
        eventName: "getUserProfile",
        data: null,
      );
      handler.complete(response.jsonEncodeModel());
    }
  }

  @pragma('vm:entry-point')
  void getCookies(dynamic msg, CompletionHandler handler) async {
    late BaseResponse response;
    if (CommonProperties.isLoggedIn) {
      GetCookie getCookie = GetCookie(repository: sl());
      final failureOrSuccessForCookie = await getCookie(false);
      failureOrSuccessForCookie.fold(
        (l) {
          BaseResponse response = BaseResponse(
            code: 401,
            message: "failure get cookies",
            eventName: "getCookies",
            data: null,
          );
          handler.complete(response.jsonEncodeModel());
        },
        (r) async {
          response = BaseResponse(
            code: 200,
            eventName: "getCookies",
            message: "success",
            data: CookiesModel(
              cookies: r,
            ),
          );
          handler.complete(response.jsonEncodeModel());
        },
      );
    } else {
      BaseResponse response = BaseResponse(
        code: 401,
        message: "Unauthorized",
        eventName: "getUserProfile",
        data: null,
      );
      handler.complete(response.jsonEncodeModel());
    }
  }

  @pragma('vm:entry-point')
  void getAppPreferences(dynamic msg, CompletionHandler handler) {
    BaseResponse response = BaseResponse(
      code: 200,
      message: "success",
      eventName: "AppPreferences",
      data: JsPreferencesModel(
        language: 'locale'.tr(),
        themeType: "dark",
        colors: {
          "primary": AppColor.primary900Light.value,
          "secondary": AppColor.secondary900Light.value,
          // "background": AppColor.backgroundColor,
          // "text": AppColor.textColor,
          // "error": AppColor.errorColor,
          // "warning": AppColor.warningColor,
          // "success": AppColor.successColor,
        },
      ),
    );
    var dataJson = response.toJson();
    var dataJsonString = response.jsonEncodeModel();
    handler.complete(dataJsonString);
  }

  @pragma('vm:entry-point')
  void navigateToSuperAppScreen(dynamic msg, CompletionHandler handler) {
    late BaseResponse response;
    if (msg != null && msg is String && msg.isNotEmpty) {
      Map<String, dynamic> data = jsonDecode(msg);
      response = BaseResponse(
        code: 200,
        message: "success",
        eventName: "navigateToSuperAppScreen",
        data: null,
      );
      NavigationService.pushNamed(
        routeName: data['screenName'],
        args: data['arguments'],
      );
    } else {
      response = BaseResponse(
        code: 400,
        eventName: "navigateToSuperAppScreen",
        message: "Invalid screen name",
        data: null,
      );
    }

    handler.complete(response.jsonEncodeModel());
  }

  @pragma('vm:entry-point')
  void checkPermission(dynamic data, CompletionHandler handler) async {
    if (data != null && data is Map) {
      String permissionName = data["permission_name"];
      bool state = false;
      BaseResponse response;
      switch (permissionName) {
        case "location":
          state = await CommonFunctions.checkLocationSettings(
            NavigationService.navigatorKey.currentContext!,
          );
          break;
        case "camera":
          state = await CommonFunctions.checkCameraSettings(
            NavigationService.navigatorKey.currentContext!,
          );
          break;
        default:
          response = BaseResponse(
            code: 400,
            message: "Invalid permission name",
            eventName: "checkPermission",
            data: null,
          );
          handler.complete(response.jsonEncodeModel());
          return;
      }
      if (state) {
        response = BaseResponse(
          code: 200,
          message: "success",
          eventName: "checkPermission",
          data: null,
        );
      } else {
        response = BaseResponse(
          code: 401,
          message: "Permission denied",
          eventName: "checkPermission",
          data: null,
        );
      }
      handler.complete(response.jsonEncodeModel());
    }
  }

  @pragma('vm:entry-point')
  void getLocation(dynamic msg, CompletionHandler handler) async {
    LatLng? latLng = await Helpers.getMapLocation();
    if (latLng != null) {
      BaseResponse response = BaseResponse(
        code: 200,
        message: "success",
        eventName: "getLocation",
        data: JsLocationModel(
          latitude: latLng.latitude,
          longitude: latLng.longitude,
        ),
      );
      handler.complete(response.jsonEncodeModel());
    } else {
      BaseResponse response = BaseResponse(
        code: 401,
        eventName: "getLocation",
        message: "Can't get location",
        data: null,
      );
      handler.complete(response.jsonEncodeModel());
    }
  }

  @pragma('vm:entry-point')
  void openCamera(dynamic msg, CompletionHandler handler) async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    late BaseResponse response;
    if (image != null) {
      int imageSize = await image.length();
      if (imageSize > 25000000) {
        // CommonFunctions.showError(('file_size_error').tr());
        response = BaseResponse(
          code: 405,
          eventName: "openImagePicker",
          message: "File size exceeds limit",
          data: null,
        );
      } else {
        String path = image.path;
        String fileName =
            path.isNotEmpty ? path.split('/').last : ('attachment_name').tr();
        final fileBytes = await File(path).readAsBytes();
        String base64File = base64Encode(fileBytes);
        JsFilesModel file = JsFilesModel(
            fileBase64: base64File,
            fileName: fileName,
            // fileBytes:fileBytes,
            filePath: path);
        response = BaseResponse(
          code: 200,
          eventName: "openImagePicker",
          message: "success",
          data: file,
        );
      }
    } else {
      response = BaseResponse(
        code: 300,
        eventName: "openImagePicker",
        message: "Can't get image",
        data: null,
      );
    }

    var x = response.jsonEncodeModel();
    handler.complete(response.jsonEncodeModel());
  }

  @pragma('vm:entry-point')
  void openFilePicker(dynamic msg, CompletionHandler handler) async {
    var file = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
      // allowedExtensions: ['jpg', 'pdf', 'jpeg', 'png'],
    );
    late BaseResponse response;
    try {
      if (file != null && file.files.isNotEmpty) {
        String? path = file.files[0].path;
        if (path != null) {
          PlatformFile platformFile = file.files.first;
          if (platformFile.size > 25000000) {
            CommonFunctions.showError(('file_size_error').tr());
          } else {
            String fileName = path.isNotEmpty
                ? path.split('/').last
                : ('attachment_name').tr();
            final fileBytes = await File(path).readAsBytes();
            String base64File = base64Encode(fileBytes);
            JsFilesModel file = JsFilesModel(
                fileBase64: base64File,
                fileName: fileName,
                // fileBytes: fileBytes,
                filePath: path);
            response = BaseResponse(
                code: 200,
                message: "success",
                data: file,
                eventName: "openFilePicker");
          }
        }
      } else {
        response = BaseResponse(
            code: 300,
            message: "Can't get file",
            data: null,
            eventName: "openFilePicker");
      }
    } on PlatformException catch (error, stackTrace) {
      response = BaseResponse(
        code: 500,
        message: "Error occurred",
        eventName: "openFilePicker",
        data: null,
      );
    }
    handler.complete(response.jsonEncodeModel());
  }

  /// TODO: Need To Test
  @pragma('vm:entry-point')
  void openShare(dynamic msg, CompletionHandler handler) {
    late BaseResponse response;
    if (msg != null && msg is String && msg.isNotEmpty) {
      Share.share(msg);
      response = BaseResponse(
        code: 200,
        eventName: "openShare",
        message: "success",
        data: null,
      );
      handler.complete(response.jsonEncodeModel());
    } else {
      response = BaseResponse(
        code: 400,
        eventName: "openShare",
        message: "Invalid share data",
        data: null,
      );
      handler.complete(response.jsonEncodeModel());
    }
  }

  @pragma('vm:entry-point')
  void jsLaunchUri(dynamic msg, CompletionHandler handler) async {
    if (msg != null && msg is Map) {
      bool canLaunch = await canLaunchUrl(Uri.parse(msg['uri']));
      if (canLaunch) {
        await launchUrl(Uri.parse(msg['uri']));
      } else {
        BaseResponse response = BaseResponse(
          code: 400,
          eventName: "jsLaunchUri",
          message: "Can't open url",
          data: null,
        );
        handler.complete(response.jsonEncodeModel());
      }
    }
  }

  @pragma('vm:entry-point')
  void openWebView(dynamic dataUri, CompletionHandler handler) async {
    if (dataUri != null && dataUri is Map) {
      if (dataUri["url"] != null) {
        CommonFunctions.openBaladyWebView(dataUri["url"]);
      } else {
        BaseResponse response = BaseResponse(
          code: 400,
          eventName: "openWebView",
          message: "Can't open url",
          data: null,
        );
        handler.complete(response.jsonEncodeModel());
      }
    }
  }

  @pragma('vm:entry-point')
  void trackEvent(dynamic msg, CompletionHandler handler) {
    if (msg != null && msg is String && msg.isNotEmpty) {
      print("%%%%%%%%%  $msg %%%%%%%%%");
      BaseResponse response = BaseResponse(
        code: 200,
        eventName: "trackEvent",
        message: "Event tracked successfully",
        data: null,
      );
      CommonFunctions.sendUXCamEvent(msg);
      handler.complete(response.jsonEncodeModel());
    } else {
      BaseResponse response = BaseResponse(
        code: 400,
        eventName: "trackEvent",
        message: "Invalid event data",
        data: null,
      );
      handler.complete(response.jsonEncodeModel());
    }
  }

  @pragma('vm:entry-point')
  void trackLogsErrors(dynamic msg, CompletionHandler handler) {
    print("############## $msg ##############");
    if (msg != null && msg is String && msg.isNotEmpty) {
      BaseResponse response = BaseResponse(
        code: 200,
        eventName: "trackLogsErrors",
        message: "Event tracked successfully",
        data: null,
      );
      // CommonFunctions.sendEventToAnalytics(msg);
      handler.complete(response.jsonEncodeModel());
    } else {
      // BaseResponse response = BaseResponse(
      //   code: 400,
      //   message: "Invalid event data",
      //   data: null,
      // );
      // handler.complete(response.jsonEncodeModel());
    }
  }

  @pragma('vm:entry-point')
  void openDirectionsMap(dynamic data, CompletionHandler handler) {
    if (data != null && data is Map) {
      BaseResponse response = BaseResponse(
        code: 200,
        eventName: "openDirectionsMap",
        message: "Event tracked successfully",
        data: null,
      );
      CommonFunctions.launchMap(
        LatLng(
          latitude: data["latitude"],
          longitude: data["longitude"],
        ),
      );
      handler.complete(response.jsonEncodeModel());
    } else {
      BaseResponse response = BaseResponse(
        code: 400,
        eventName: "openDirectionsMap",
        message: "Invalid event data",
        data: null,
      );
      handler.complete(response.jsonEncodeModel());
    }
  }
}
