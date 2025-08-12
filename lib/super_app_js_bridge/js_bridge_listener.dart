import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:dio/dio.dart';
import 'Requirement_enum.dart';
import 'package:archive/archive.dart';
import 'package:dgis_map/library.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dsbridge_flutter/dsbridge_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'model/download_file_paths_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:add_2_calendar/add_2_calendar.dart';

import 'package:balady_plus/app/core/services/local/helpers.dart';
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/services/local/notification_service.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/super_app_js_bridge/model/base_response.dart';
import 'package:balady_plus/super_app_js_bridge/model/js_file_model.dart';
import 'package:balady_plus/super_app_js_bridge/model/location_model.dart';
import 'package:balady_plus/super_app_js_bridge/model/user_profile_model.dart';
import 'package:balady_plus/super_app_js_bridge/model/access_token_model.dart';
import 'package:balady_plus/super_app_js_bridge/model/js_preferences_model.dart';
import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/features/entry_point/domain/use_cases/get_cookie.dart';
import 'package:balady_plus/mini_apps_engine/presentation/bloc/mini_apps_engine_bloc.dart';
import 'package:balady_plus/app/core/utils/dialog_on_web_view/show_dialog_on_web_view.dart';
import 'package:balady_plus/super_app_js_bridge/camera/entities/camera/attachment_item.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/need_login_dialog.dart';
import 'package:balady_plus/mini_apps_engine/presentation/bloc/home_mini_apps_list_bloc/home_mini_apps_list_cubit.dart';

class JsBridgeListener extends JavaScriptNamespaceInterface {
  MiniAppsEngineBloc miniAppsEngineBloc;
  ValueNotifier<bool> isLoading;

  JsBridgeListener({
    required this.miniAppsEngineBloc,
    required this.isLoading,
  }) : super();

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
    registerFunction(trackLogs);
    registerFunction(trackEvent);
    registerFunction(trackLogsErrors);
    registerFunction(openDirectionsMap);
    registerFunction(openWebView);
    registerFunction(checkPermission);
    registerFunction(sendToCalender);
    registerFunction(getPrayerTime);
    registerFunction(downloadAndExtractInAssets);
    registerFunction(openCameraWithUI);
  }

  @pragma('vm:entry-point')
  void getAccessToken(dynamic msg, CompletionHandler handler) async {
    late BaseResponse response;
    if (miniAppsEngineBloc.miniApp.serviceKey == 'municipalservice' && !CommonProperties.isLoggedInMunicipality) {
      final needDialog = NeedLoginDialog(
        onSuccessLogin: (bool? isSuccess) async {
          if (isSuccess ?? false) {
            await sl<HomeMiniAppsListCubit>()
                .getMiniAppAcessToken(miniAppsEngineBloc.miniApp.serviceKey!)
                .then((result) {
              response = result!;
            });
          } else {
            response = BaseResponse(
              code: 401,
              eventName: "getAccessToken",
              message: "Unauthorized",
              data: null,
            );
          }
        },
        mainPage: RouteName.miniAppsMainScreen,
      );

      await ShowDialogOnWebView.showAlertDialog(
        context: NavigationService.navigatorKey.currentContext!,
        content: needDialog.content(withoutActions: Platform.isIOS),
        actions: Platform.isIOS ? (ctx) => needDialog.textActions(ctx) : null,
      );
    } else if (miniAppsEngineBloc.miniApp.latestVersion?.otpLogin == true && !CommonProperties.isLoggedIn) {
      CommonFunctions.onLogin(
        mainPage: RouteName.miniAppsMainScreen,
      );
      response = BaseResponse(
        code: 401,
        eventName: "getAccessToken",
        message: "Unauthorized",
        data: null,
      );
    } else {
      await sl<HomeMiniAppsListCubit>().getMiniAppAcessToken(miniAppsEngineBloc.miniApp.serviceKey!).then((result) {
        response = result!;
      });
    }
    handler.complete(response.jsonEncodeModel());
  }

  @pragma('vm:entry-point')
  void getUserProfile(dynamic msg, CompletionHandler handler) {
    String serviceKey = "municipalservice"; //for testing only
    //String serviceKey =  msg["serviceKey"];
    if (checkAppRequirement(serviceKey, RequirementEnum.userProfile.name) == true) {
      if (CommonProperties.isLoggedIn) {
        if (CommonProperties.userInfo == null) {
          BaseResponse response = BaseResponse(
            code: 401,
            message: "Unauthorized",
            eventName: "getUserProfile",
            data: null,
          );
          handler.complete(response.jsonEncodeModel());
        } else {
          try {
            BaseResponse response = BaseResponse(
              code: 200,
              message: "success",
              eventName: "getUserProfile",
              data: UserProfileModel.fromJson(
                CommonProperties.userInfo!.toJson(),
              ),
            );
            handler.complete(response.jsonEncodeModel());
          } catch (e) {
            BaseResponse response = BaseResponse(
              code: 404,
              message: "Profile not found",
              eventName: "getUserProfile",
              data: null,
            );
            handler.complete(response.jsonEncodeModel());
          }
        }
      } else {
        BaseResponse response = BaseResponse(
          code: 401,
          message: "Unauthorized",
          eventName: "getUserProfile",
          data: null,
        );
        handler.complete(response.jsonEncodeModel());
      }
    } else {
      BaseResponse response = BaseResponse(
        code: 500,
        message: "you do not have permission to access this functionality",
        eventName: "getUserProfile",
        data: null,
      );
      handler.complete(response.jsonEncodeModel());
    }
  }

  @pragma('vm:entry-point')
  void getCookies(dynamic msg, CompletionHandler handler) async {
    String serviceKey = "municipalservice"; //for testing only
    //String serviceKey =  msg["serviceKey"];
    if (checkAppRequirement(serviceKey, RequirementEnum.cookies.name) == true) {
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
        final needDialog = NeedLoginDialog(
          onSuccessLogin: (bool? isSuccess) async {
            if (isSuccess ?? false) {
              response = BaseResponse(
                code: 200,
                message: "success",
                eventName: "getCookies",
                data: AccessTokenModel(
                  accessToken: CommonProperties.token,
                ),
              );
            }
          },
        );

        await ShowDialogOnWebView.showAlertDialog(
          context: NavigationService.navigatorKey.currentContext!,
          content: needDialog.content(withoutActions: Platform.isIOS),
          actions: Platform.isIOS ? (ctx) => needDialog.textActions(ctx) : null,
        );

        handler.complete(response.jsonEncodeModel());
      }
    } else {
      BaseResponse response = BaseResponse(
        code: 500,
        message: "you do not have permission to access this functionality",
        eventName: "getCookies",
        data: null,
      );
      handler.complete(response.jsonEncodeModel());
    }
  }

  @pragma('vm:entry-point')
  void getAppPreferences(dynamic msg, CompletionHandler handler) {
    try {
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
      var dataJsonString = response.jsonEncodeModel();
      handler.complete(dataJsonString);
    } catch (_) {
      BaseResponse response = BaseResponse(
        code: 500,
        message: "Error occurred while getting app preferences",
        eventName: "AppPreferences",
        data: null,
      );
      handler.complete(response.jsonEncodeModel());
    }
    isLoading.value = false;
  }

  @pragma('vm:entry-point')
  void navigateToSuperAppScreen(dynamic msg, CompletionHandler handler) {
    String serviceKey = "municipalservice"; //for testing only
    //String serviceKey =  msg["serviceKey"];
    if (checkAppRequirement(serviceKey, RequirementEnum.navigateToSuperAppScreen.name) == true) {
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
    } else {
      BaseResponse response = BaseResponse(
        code: 500,
        message: "you do not have permission to access this functionality",
        eventName: "navigateToSuperAppScreen",
        data: null,
      );
      handler.complete(response.jsonEncodeModel());
    }
  }

  @pragma('vm:entry-point')
  void checkPermission(dynamic data, CompletionHandler handler) async {
    String serviceKey = "municipalservice"; //for testing only
    //String serviceKey =  msg["serviceKey"];
    if (checkAppRequirement(serviceKey, RequirementEnum.checkPermission.name) == true) {
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
              eventName: "getPermissionResponse",
              data: null,
            );
            handler.complete(response.jsonEncodeModel());
            return;
        }
        if (state) {
          response = BaseResponse(
            code: 200,
            message: "success",
            eventName: "getPermissionResponse",
            data: null,
          );
        } else {
          response = BaseResponse(
            code: 401,
            message: "Permission denied",
            eventName: "getPermissionResponse",
            data: null,
          );
        }
        handler.complete(response.jsonEncodeModel());
      }
    } else {
      BaseResponse response = BaseResponse(
        code: 500,
        message: "you do not have permission to access this functionality",
        eventName: "getPermissionResponse",
        data: null,
      );
      handler.complete(response.jsonEncodeModel());
    }
  }

  @pragma('vm:entry-point')
  void getLocation(dynamic msg, CompletionHandler handler) async {
    String serviceKey = "municipalservice"; //for testing only
    //String serviceKey =  msg["serviceKey"];
    if (checkAppRequirement(serviceKey, RequirementEnum.location.name) == true) {
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
    } else {
      BaseResponse response = BaseResponse(
        code: 500,
        message: "you do not have permission to access this functionality",
        eventName: "getLocation",
        data: null,
      );
      handler.complete(response.jsonEncodeModel());
    }
  }

  @pragma('vm:entry-point')
  void openCamera(dynamic msg, CompletionHandler handler) async {
    String serviceKey = "municipalservice"; //for testing only
    //String serviceKey =  msg["serviceKey"];
    if (checkAppRequirement(serviceKey, RequirementEnum.camera.name) == true) {
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
          String fileName = path.isNotEmpty ? path.split('/').last : ('attachment_name').tr();
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
      handler.complete(response.jsonEncodeModel());
    } else {
      BaseResponse response = BaseResponse(
        code: 500,
        message: "you do not have permission to access this functionality",
        eventName: "openImagePicker",
        data: null,
      );
      handler.complete(response.jsonEncodeModel());
    }
  }

  @pragma('vm:entry-point')
  void openCameraWithUI(dynamic msg, CompletionHandler handler) async {
    String serviceKey = "municipalservice"; //for testing only
    //String serviceKey =  msg["serviceKey"];
    if (checkAppRequirement(serviceKey, RequirementEnum.camera.name) == true) {
      late BaseResponse response;
      var fileData = await NavigationService.navigatorKey.currentState!.pushNamed(
        RouteName.vdCameraPage,
      );
      if (fileData != null) {
        response = BaseResponse(
          code: 200,
          eventName: "openCameraWithUI",
          message: "success",
          data: fileData is AttachmentItem ? fileData : null,
        );
      } else {
        response = BaseResponse(
          code: 300,
          eventName: "openCameraWithUI",
          message: "Not Selected File",
          data: null,
        );
      }
      // String data = response.jsonEncodeModel();
      handler.complete(response.jsonEncodeModel());
    } else {
      BaseResponse response = BaseResponse(
        code: 500,
        message: "you do not have permission to access this functionality",
        eventName: "openCameraWithUI",
        data: null,
      );
      handler.complete(response.jsonEncodeModel());
    }
  }

  @pragma('vm:entry-point')
  void openFilePicker(dynamic msg, CompletionHandler handler) async {
    String serviceKey = "municipalservice"; //for testing only
    //String serviceKey =  msg["serviceKey"];
    final attachmentSource = msg["attachmentSource"];
    final List<String>? attachmentExtension = (msg["attachmentExtension"] as List<dynamic>?)?.cast<String>();
    if (checkAppRequirement(serviceKey, RequirementEnum.filePicker.name) == true) {
      var file = await FilePicker.platform.pickFiles(
        type: (attachmentSource == "gallery" ? FileType.image : FileType.custom),
        allowMultiple: false,
        allowedExtensions: attachmentSource == "gallery" ? [] : attachmentExtension,
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
              String fileName = path.isNotEmpty ? path.split('/').last : ('attachment_name').tr();
              final fileBytes = await File(path).readAsBytes();
              String base64File = base64Encode(fileBytes);
              JsFilesModel file = JsFilesModel(
                  fileBase64: base64File,
                  fileName: fileName,
                  // fileBytes: fileBytes,
                  filePath: path);
              response = BaseResponse(code: 200, message: "success", data: file, eventName: "openFilePicker");
            }
          }
        } else {
          response = BaseResponse(code: 300, message: "Can't get file", data: null, eventName: "openFilePicker");
        }
      } on PlatformException catch (_) {
        response = BaseResponse(
          code: 500,
          message: "Error occurred",
          eventName: "openFilePicker",
          data: null,
        );
      }
      handler.complete(response.jsonEncodeModel());
    } else {
      BaseResponse response = BaseResponse(
        code: 500,
        message: "you do not have permission to access this functionality",
        eventName: "openFilePicker",
        data: null,
      );
      handler.complete(response.jsonEncodeModel());
    }
  }

  /// TODO: Need To Test
  @pragma('vm:entry-point')
  void openShare(dynamic msg, CompletionHandler handler) {
    String serviceKey = "municipalservice"; //for testing only
    //String serviceKey =  msg["serviceKey"];
    if (checkAppRequirement(serviceKey, RequirementEnum.share.name) == true) {
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
    } else {
      BaseResponse response = BaseResponse(
        code: 500,
        message: "you do not have permission to access this functionality",
        eventName: "openShare",
        data: null,
      );
      handler.complete(response.jsonEncodeModel());
    }
  }

  @pragma('vm:entry-point')
  void jsLaunchUri(dynamic msg, CompletionHandler handler) async {
    String serviceKey = "municipalservice"; //for testing only
    //String serviceKey =  msg["serviceKey"];
    if (checkAppRequirement(serviceKey, RequirementEnum.launchUri.name) == true) {
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
    } else {
      BaseResponse response = BaseResponse(
        code: 500,
        message: "you do not have permission to access this functionality",
        eventName: "jsLaunchUri",
        data: null,
      );
      handler.complete(response.jsonEncodeModel());
    }
  }

  @pragma('vm:entry-point')
  void openWebView(dynamic dataUri, CompletionHandler handler) async {
    String serviceKey = "municipalservice"; //for testing only
    //String serviceKey =  msg["serviceKey"];
    if (checkAppRequirement(serviceKey, RequirementEnum.openWebView.name) == true) {
      if (dataUri != null && dataUri is Map) {
        if (dataUri["url"] != null) {
          if (dataUri["type"] == "pdf") {
            NavigationService.navigatorKey.currentState!.push(
              MaterialPageRoute(
                builder: (_) {
                  return Scaffold(
                    appBar: AppBar(
                      title: const Text(""),
                    ),
                    body: SfPdfViewer.network(
                      dataUri["url"],
                    ),
                  );
                },
              ),
            );
          } else {
            CommonFunctions.openBaladyWebView(dataUri["url"], needLogin: dataUri["needLogin"] ?? true);
          }
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
    } else {
      BaseResponse response = BaseResponse(
        code: 500,
        message: "you do not have permission to access this functionality",
        eventName: "openWebView",
        data: null,
      );
      handler.complete(response.jsonEncodeModel());
    }
  }

  @pragma('vm:entry-point')
  void trackLogs(dynamic msg, CompletionHandler handler) {
    if (msg != null && msg is String && msg.isNotEmpty) {
      if (kDebugMode) print("%%%%%%%%%  $msg %%%%%%%%%");
      BaseResponse response = BaseResponse(
        code: 200,
        eventName: "trackLogs",
        message: "Event tracked successfully",
        data: null,
      );
      CommonFunctions.sendUXCamEvent(msg);
      handler.complete(response.jsonEncodeModel());
    } else {
      BaseResponse response = BaseResponse(
        code: 400,
        eventName: "trackLogs",
        message: "Invalid event data",
        data: null,
      );
      handler.complete(response.jsonEncodeModel());
    }
  }

  @pragma('vm:entry-point')
  void trackEvent(dynamic msg, CompletionHandler handler) {
    if (msg != null && msg is String && msg.isNotEmpty) {
      if (kDebugMode) print("%%%%%%%%%  $msg %%%%%%%%%");
      BaseResponse response = BaseResponse(
        code: 200,
        eventName: "trackLogs",
        message: "Event tracked successfully",
        data: null,
      );
      CommonFunctions.sendUXCamEvent(msg);
      handler.complete(response.jsonEncodeModel());
    } else {
      BaseResponse response = BaseResponse(
        code: 400,
        eventName: "trackLogs",
        message: "Invalid event data",
        data: null,
      );
      handler.complete(response.jsonEncodeModel());
    }
  }

  @pragma('vm:entry-point')
  void trackLogsErrors(dynamic msg, CompletionHandler handler) {
    if (msg != null && msg is String && msg.isNotEmpty) {
      if (kDebugMode) print("%%%%%%%%%  $msg %%%%%%%%%");
      BaseResponse response = BaseResponse(
        code: 200,
        eventName: "trackLogs",
        message: "Event tracked successfully",
        data: null,
      );
      CommonFunctions.sendUXCamEvent(msg);
      handler.complete(response.jsonEncodeModel());
    } else {
      BaseResponse response = BaseResponse(
        code: 400,
        eventName: "trackLogs",
        message: "Invalid event data",
        data: null,
      );
      handler.complete(response.jsonEncodeModel());
    }
  }

  @pragma('vm:entry-point')
  void openDirectionsMap(dynamic data, CompletionHandler handler) {
    String serviceKey = "municipalservice"; //for testing only
    //String serviceKey =  msg["serviceKey"];
    if (checkAppRequirement(serviceKey, RequirementEnum.directionsMap.name) == true) {
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
    } else {
      BaseResponse response = BaseResponse(
        code: 500,
        message: "you do not have permission to access this functionality",
        eventName: "openDirectionsMap",
        data: null,
      );
      handler.complete(response.jsonEncodeModel());
    }
  }

  @pragma('vm:entry-point')
  void sendToCalender(dynamic data, CompletionHandler handler) {
    String serviceKey = "municipalservice"; //for testing only
    //String serviceKey =  msg["serviceKey"];
    if (checkAppRequirement(serviceKey, RequirementEnum.sendToCalender.name) == true) {
      if (data != null && data is Map) {
        BaseResponse response = BaseResponse(
          code: 200,
          eventName: "sendToCalender",
          message: "added to calender successfully",
          data: null,
        );
        try {
          Add2Calendar.addEvent2Cal(
            Event(
              title: data["title"] ?? "",
              description: "",
              location: "",
              startDate: DateTime.parse(data["startDate"]),
              endDate: DateTime.parse(data["endDate"]),
              iosParams: const IOSParams(url: ""),
              allDay: false,
            ),
          );
        } catch (e) {
          BaseResponse response = BaseResponse(
            code: 400,
            eventName: "sendToCalender",
            message: "failed to add",
            data: null,
          );
          handler.complete(response.jsonEncodeModel());
        }
        handler.complete(response.jsonEncodeModel());
      } else {
        BaseResponse response = BaseResponse(
          code: 400,
          eventName: "sendToCalender",
          message: "failed to add",
          data: null,
        );
        if (kDebugMode) print('data: $data');
        handler.complete(response.jsonEncodeModel());
      }
    } else {
      BaseResponse response = BaseResponse(
        code: 500,
        message: "you do not have permission to access this functionality",
        eventName: "sendToCalender",
        data: null,
      );
      handler.complete(response.jsonEncodeModel());
    }
  }

  @pragma('vm:entry-point')
  void getPrayerTime(dynamic data, CompletionHandler handler) {
    if (data != null && data is Map) {
      try {
        final notifications = data['notifications'];

        if (notifications != null && notifications is List && notifications.isNotEmpty) {
          final Map<String, List<Map>> notificationsByType = {};

          // Process and group notifications
          for (var notification in notifications) {
            if (notification is Map) {
              final String title = notification['title'] ?? '';
              if (!notificationsByType.containsKey(title)) {
                notificationsByType[title] = [];
              }
              notificationsByType[title]!.add(notification);
            }
          }

          // For each prayer type, only schedule the next occurrence
          for (var entry in notificationsByType.entries) {
            final notificationsForType = entry.value;

            // Sort notifications by date (ascending)
            notificationsForType.sort((a, b) {
              final dateA = DateTime.tryParse(a['scheduled_date'] ?? '') ?? DateTime(2000);
              final dateB = DateTime.tryParse(b['scheduled_date'] ?? '') ?? DateTime(2000);
              return dateA.compareTo(dateB);
            });

            // Find the next notification that's in the future
            final now = DateTime.now();
            Map? nextNotification;

            for (var notification in notificationsForType) {
              final scheduledDateStr = notification['scheduled_date'] ?? '';
              if (scheduledDateStr.isNotEmpty) {
                try {
                  final scheduledDate = DateTime.parse(scheduledDateStr);
                  if (scheduledDate.isAfter(now)) {
                    nextNotification = notification;
                    break; // Found the next notification
                  }
                } catch (e) {
                  debugPrint('Error parsing date: $e');
                }
              }
            }

            // If no future notification found, use the first one (for tomorrow)
            nextNotification ??= notificationsForType.isNotEmpty ? notificationsForType.first : null;

            // Schedule or cancel the notification
            if (nextNotification != null) {
              final int id = nextNotification['id'] ?? 0;
              final String title = nextNotification['title'] ?? '';
              final String scheduledDateStr = nextNotification['scheduled_date'] ?? '';
              final bool isEnabled = nextNotification['is_enabled'] ?? false;

              if (isEnabled && scheduledDateStr.isNotEmpty) {
                try {
                  final scheduledDate = DateTime.parse(scheduledDateStr);

                  // Schedule notification using NotificationService
                  NotificationService.showScheduledNotification(id: id, title: title, scheduledDate: scheduledDate);
                } catch (e) {
                  debugPrint('Error parsing date: $e');
                }
              } else if (!isEnabled) {
                // Cancel notification if disabled
                NotificationService.cancel(id);
              }
            }
          }
        }

        // Return success response
        BaseResponse response = BaseResponse(
          code: 200,
          eventName: "getPrayerTime",
          message: "Prayer notifications processed successfully",
          data: null,
        );
        handler.complete(response.jsonEncodeModel());
      } catch (e) {
        BaseResponse response = BaseResponse(
          code: 400,
          eventName: "getPrayerTime",
          message: "Error processing prayer notifications: $e",
          data: null,
        );
        handler.complete(response.jsonEncodeModel());
      }
    } else {
      BaseResponse response = BaseResponse(
        code: 400,
        eventName: "getPrayerTime",
        message: "Invalid prayer time data",
        data: null,
      );
      handler.complete(response.jsonEncodeModel());
    }
  }

  @pragma('vm:entry-point')
  void downloadAndExtractInAssets(dynamic data, CompletionHandler handler) async {
    String serviceKey = "municipalservice"; //for testing only
    //String serviceKey =  msg["serviceKey"];
    if (checkAppRequirement(serviceKey, RequirementEnum.downloadAndExtractInAssets.name) == true) {
      if (data != null && data is Map) {
        try {
          String? exratctPath = data['pathFile'];
          var tempDir = await getTemporaryDirectory();
          String fullPath = "${tempDir.path}/quran.zip'";
          File file = File(fullPath);
          if (await file.exists()) {
            await unarchiveAndSave(exratctPath, file, handler);
          } else {
            WebService webService = sl();

            Response response = await webService.dio.get(
              data['url'],
              onReceiveProgress: (received, total) {
                if (total != -1) {
                  if (kDebugMode)  print("object");
                }
              },
              //Received data with List<int>
              options: Options(
                  responseType: ResponseType.bytes,
                  followRedirects: false,
                  validateStatus: (status) {
                    return (status ?? 501) < 500;
                  }),
            );

            File file = File(fullPath);
            var raf = file.openSync(mode: FileMode.write);
            // response.data is List<int> type
            raf.writeFromSync(response.data);
            await raf.close();

            await unarchiveAndSave(exratctPath, file, handler);
          }
        } catch (e) {
          BaseResponse response = BaseResponse(
            code: 500,
            eventName: "downloadAndExtractInAssets",
            message: "failure",
            data: null,
          );
          handler.complete(response.jsonEncodeModel());
        }
      }
    } else {
      BaseResponse response = BaseResponse(
        code: 500,
        message: "you do not have permission to access this functionality",
        eventName: "downloadAndExtractInAssets",
        data: null,
      );
      handler.complete(response.jsonEncodeModel());
    }
  }

  unarchiveAndSave(String? extractPath, var zippedFile, CompletionHandler handler) async {
    try {
      extractPath ??= "assets/quran";
      var bytes = zippedFile.readAsBytesSync();
      var archive = ZipDecoder().decodeBytes(bytes);
      String? filesPath;
      int counter = 0;
      for (var file in archive) {
        if (file.isFile && !file.name.contains("__MACOSX")) {
          var outFile = File('${CommonProperties.currentLocalServerDirectory}/assets/$extractPath/${file.name}');
          outFile = await outFile.create(recursive: true);
          if (counter == 0) {
            filesPath = outFile.path;
            counter++;
          }
          await outFile.writeAsBytes(file.content);
        }
      }

      if (filesPath != null) {
        filesPath = filesPath.replaceAll("${CommonProperties.currentLocalServerDirectory}/assets/", "");
        final lastIndex = filesPath.lastIndexOf('/');
        if (lastIndex != -1) {
          filesPath = filesPath.substring(0, lastIndex);
        }
      }

      BaseResponse response = BaseResponse(
        code: 200,
        eventName: "downloadAndExtractInAssets",
        message: "successfully",
        data: DownloadFilePathModel(path: filesPath!),
      );
      handler.complete(response.jsonEncodeModel());
    } catch (e) {
      BaseResponse response = BaseResponse(
        code: 500,
        eventName: "downloadAndExtractInAssets",
        message: "failure",
        data: null,
      );
      handler.complete(response.jsonEncodeModel());
    }
    // return indexFilePath;
  }
}

bool checkAppRequirement(String serviceKey, String requirementKey) {
  return true;
}
