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
import 'package:image_picker/image_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class JsBridgeListener extends JavaScriptNamespaceInterface {
  @override
  void register() {
    registerFunction(getAccessToken);
    registerFunction(getUserProfile);
    registerFunction(getAppPreferences);
    registerFunction(navigateToSuperAppScreen);
    registerFunction(getLocation);
    registerFunction(openCamera);
    registerFunction(openFilePicker);
    registerFunction(openShare);
    registerFunction(jsLaunchUri);
    registerFunction(trackEvent);
  }

  @pragma('vm:entry-point')
  void getAccessToken(dynamic msg, CompletionHandler handler) async {
    late BaseResponse response;
    if (CommonProperties.isLoggedIn) {
      response = BaseResponse(
        code: 200,
        message: "success",
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
                data: AccessTokenModel(
                  accessToken: CommonProperties.token,
                ),
              );
            } else {
              BaseResponse response = BaseResponse(
                code: 401,
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
        data: UserProfileModel.fromJson(CommonProperties.userInfo!.toJson()),
      );
      handler.complete(response.jsonEncodeModel());
    } else {
      BaseResponse response = BaseResponse(
        code: 401,
        message: "Unauthorized",
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
      data: JsPreferencesModel(
        language: 'locale'.tr(),
        themeType: "dark",
        colors: {
          "primary": AppColor.primary900Light,
          "secondary": AppColor.secondary900Light,
          // "background": AppColor.backgroundColor,
          // "text": AppColor.textColor,
          // "error": AppColor.errorColor,
          // "warning": AppColor.warningColor,
          // "success": AppColor.successColor,
        },
      ),
    );
    handler.complete(response.jsonEncodeModel());
  }

  @pragma('vm:entry-point')
  void navigateToSuperAppScreen(dynamic msg, CompletionHandler handler) {
    late BaseResponse response;
    if (msg != null && msg is String && msg.isNotEmpty) {
      Map<String, dynamic> data = jsonDecode(msg);
      response = BaseResponse(
        code: 200,
        message: "success",
        data: null,
      );
      NavigationService.pushNamed(
        routeName: data['screenName'],
        args: data['arguments'],
      );
    } else {
      response = BaseResponse(
        code: 400,
        message: "Invalid screen name",
        data: null,
      );
    }

    handler.complete(response.jsonEncodeModel());
  }

  @pragma('vm:entry-point')
  void getLocation(dynamic msg, CompletionHandler handler) async {
    LatLng? latLng = await Helpers.getMapLocation();
    if (latLng != null) {
      BaseResponse response = BaseResponse(
        code: 200,
        message: "success",
        data: JsLocationModel(
          latitude: latLng.latitude,
          longitude: latLng.longitude,
        ),
      );
      handler.complete(response.jsonEncodeModel());
    } else {
      BaseResponse response = BaseResponse(
        code: 401,
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
        );
        response = BaseResponse(
          code: 200,
          message: "success",
          data: file,
        );
      }
    } else {
      response = BaseResponse(
        code: 300,
        message: "Can't get image",
        data: null,
      );
    }
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
            );
            response = BaseResponse(
              code: 200,
              message: "success",
              data: file,
            );
          }
        }
      } else {
        response = BaseResponse(
          code: 300,
          message: "Can't get file",
          data: null,
        );
      }
    } on PlatformException catch (error, stackTrace) {
      response = BaseResponse(
        code: 500,
        message: "Error occurred",
        data: null,
      );
    }

    handler.complete(response.jsonEncodeModel());
  }

  @pragma('vm:entry-point')
  void openShare(dynamic msg, CompletionHandler handler) {
    late BaseResponse response;
    if (msg != null && msg is String && msg.isNotEmpty) {
      Share.share(msg);
      response = BaseResponse(
        code: 200,
        message: "success",
        data: null,
      );
      handler.complete(response.jsonEncodeModel());
    } else {
      response = BaseResponse(
        code: 400,
        message: "Invalid share data",
        data: null,
      );
      handler.complete(response.jsonEncodeModel());
    }
  }

  @pragma('vm:entry-point')
  void jsLaunchUri(dynamic msg, CompletionHandler handler) async {
    if (msg != null && msg is String && msg.isNotEmpty) {
      bool canLaunch = await canLaunchUrl(Uri.parse(msg));
      if (canLaunch) {
        await launchUrl(Uri.parse(msg));
      } else {
        BaseResponse response = BaseResponse(
          code: 400,
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
      BaseResponse response = BaseResponse(
        code: 200,
        message: "Event tracked successfully",
        data: null,
      );
      CommonFunctions.sendEventToAnalytics(msg);
      handler.complete(response.jsonEncodeModel());
    } else {
      BaseResponse response = BaseResponse(
        code: 400,
        message: "Invalid event data",
        data: null,
      );
      handler.complete(response.jsonEncodeModel());
    }
  }
}
