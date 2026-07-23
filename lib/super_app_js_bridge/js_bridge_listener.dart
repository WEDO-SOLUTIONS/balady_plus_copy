import 'dart:convert';
import 'dart:io';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/presentation/cubit/new_mini_app_logic_cubit.dart';
import 'package:balady_plus/super_app_js_bridge/model/app_theme_config.dart';
import 'package:balady_plus/super_app_js_bridge/model/js_pdf_model.dart';
import 'package:balady_plus/super_app_js_bridge/pages/pdf_viewer_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:archive/archive.dart';
import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/services/local/helpers.dart';
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/services/local/notification_service.dart';
import 'package:balady_plus/app/core/services/local/shared_prefs_manager.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/features/delegators/domain/entities/agent_entity.dart';
import 'package:balady_plus/app/features/delegators/domain/entities/delegator_entity.dart';
import 'package:balady_plus/app/features/delegators/presentation/delegators_cubit/delegators_cubit.dart';
import 'package:balady_plus/super_app_js_bridge/model/js_delegator_model.dart';
import 'package:balady_plus/super_app_js_bridge/model/js_agent_model.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/core/utils/dialog_on_web_view/show_dialog_on_web_view.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/need_login_dialog.dart';
import 'package:balady_plus/app/features/entry_point/domain/use_cases/get_cookie.dart';
import 'package:balady_plus/mini_apps_engine/presentation/bloc/mini_apps_engine_bloc.dart';
import 'package:balady_plus/super_app_js_bridge/camera/entities/camera/attachment_item.dart';
import 'package:balady_plus/super_app_js_bridge/model/access_token_model.dart';
import 'package:balady_plus/super_app_js_bridge/model/base_response.dart';
import 'package:balady_plus/super_app_js_bridge/model/call_back_model.dart';
import 'package:balady_plus/super_app_js_bridge/model/js_file_model.dart';
import 'package:balady_plus/super_app_js_bridge/model/location_model.dart';
import 'package:balady_plus/super_app_js_bridge/model/user_profile_model.dart';
import 'package:dgis_map/library.dart';
import 'package:dio/dio.dart';
import 'package:dsbridge_flutter/dsbridge_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app/features/accecipilities/AccessibilitySettings.dart';
import 'Requirement_enum.dart';
import 'model/download_file_paths_model.dart';

class JsBridgeListener extends JavaScriptNamespaceInterface {
  MiniAppsEngineBloc miniAppsEngineBloc;
  ValueNotifier<bool> isLoading;

  JsBridgeListener({required this.miniAppsEngineBloc, required this.isLoading}) : super();

  @override
  void register() {
    registerFunction(getAccessToken);
    ////////////////////////////////////////////////////////////
    ///  need remove this function, for the partner knows this
    registerFunction(getAccessSSOToken);

    /// this the new Oen For Use in the Municipal Mini App
    registerFunction(getBaladySSOToken);
    ////////////////////////////////////////////////////////////
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
    registerFunction(openMiniApps);
    registerFunction(openPdfFile);
    registerFunction(openAppSetting);
    registerFunction(closeCurrentMiniApp);
    registerFunction(selectedDelegator);
    registerFunction(selectedAgent);
    registerFunction(getRideHailingKey);
  }

  @pragma('vm:entry-point')
  void closeCurrentMiniApp(dynamic msg, CompletionHandler handler) async {
    if (NavigationService.navigatorKey.currentContext!.mounted) {
      Navigator.of(NavigationService.navigatorKey.currentContext!).pop();
    }
  }

  @pragma('vm:entry-point')
  void openAppSetting(dynamic msg, CompletionHandler handler) async {
    openAppSettings();
  }

  @pragma('vm:entry-point')
  void getAccessSSOToken(dynamic msg, CompletionHandler handler) async {
    getBaladySSOToken(msg, handler);
  }

  @pragma('vm:entry-point')
  void getBaladySSOToken(dynamic msg, CompletionHandler handler) async {
    BaseResponse response = BaseResponse(
      code: 401,
      message: "Unauthorized",
      eventName: "getAccessToken",
      data: AccessTokenModel(accessToken: CommonProperties.token),
    );

    if ((miniAppsEngineBloc.miniApp.serviceKey == 'municipalservice' ||
            miniAppsEngineBloc.miniApp.serviceKey == 'volunteerapp') &&
        !CommonProperties.isLoggedInMunicipality) {
      final needDialog = NeedLoginDialog(
        onSuccessLogin: (bool? isSuccess) async {
          if (isSuccess ?? false) {
            response = BaseResponse(
              code: 200,
              message: "success",
              eventName: "getAccessToken",
              data: AccessTokenModel(accessToken: CommonProperties.token),
            );
          } else {
            response = BaseResponse(code: 401, eventName: "getAccessToken", message: "Unauthorized", data: null);
          }
          handler.complete(response.jsonEncodeModel());
        },
        mainPage: RouteName.miniAppsMainScreen,
      );
      try {
        await ShowDialogOnWebView.showAlertDialog(
          context: NavigationService.navigatorKey.currentContext!,
          content: needDialog.content(withoutActions: Platform.isIOS),
          actions: Platform.isIOS ? (ctx) => needDialog.textActions(ctx) : null,
        );
      } catch (_) {
        handler.complete(response.jsonEncodeModel());
      }
    } else {
      response = BaseResponse(
        code: 200,
        message: "success",
        eventName: "getAccessToken",
        data: AccessTokenModel(accessToken: CommonProperties.token),
      );
      handler.complete(response.jsonEncodeModel());
    }
  }

  @pragma('vm:entry-point')
  void getAccessToken(dynamic msg, CompletionHandler handler) async {
    late BaseResponse response;
    if ((miniAppsEngineBloc.miniApp.serviceKey == 'municipalservice' ||
            miniAppsEngineBloc.miniApp.serviceKey == 'volunteerapp') &&
        !CommonProperties.isLoggedInMunicipality) {
      final needDialog = NeedLoginDialog(
        onSuccessLogin: (bool? isSuccess) async {
          if (isSuccess ?? false) {
            await sl<NewMiniAppLogicCubit>().getMiniAppAcessToken(miniAppsEngineBloc.miniApp).then((result) {
              response = result!;
            });
          } else {
            response = BaseResponse(code: 401, eventName: "getAccessToken", message: "Unauthorized", data: null);
          }
        },
        mainPage: RouteName.miniAppsMainScreen,
      );

      await ShowDialogOnWebView.showAlertDialog(
        context: NavigationService.navigatorKey.currentContext!,
        content: needDialog.content(withoutActions: Platform.isIOS),
        actions: Platform.isIOS ? (ctx) => needDialog.textActions(ctx) : null,
      );
    } else if (miniAppsEngineBloc.miniApp.otpLogin == true && !CommonProperties.isLoggedIn) {
      CommonFunctions.onLogin(mainPage: RouteName.miniAppsMainScreen);
      response = BaseResponse(code: 401, eventName: "getAccessToken", message: "Unauthorized", data: null);
    } else {
      await sl<NewMiniAppLogicCubit>().getMiniAppAcessToken(miniAppsEngineBloc.miniApp).then((result) {
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
              data: UserProfileModel.fromJson(CommonProperties.userInfo!.toJson()),
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
              data: CookiesModel(cookies: r),
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
                data: AccessTokenModel(accessToken: CommonProperties.token),
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
  void getAppPreferences(dynamic msg, CompletionHandler handler) async {
    try {
      final accessibility = await AccessibilitySettings.load();
      BaseResponse response = BaseResponse(
        code: 200,
        message: "success",
        eventName: "AppPreferences",
        data: AppThemeConfig(
          language: 'locale'.tr(),
          accessibilityModel: accessibility,
          deviceType: Platform.isAndroid ? 'android' : 'ios',
          themeType: Theme.of(NavigationService.navigatorKey.currentContext!).brightness.name,
          colorSchemeDark: ColorSchemeModel(
            colorScheme: Theme.of(NavigationService.navigatorKey.currentContext!).colorScheme,
            cardColor: Theme.of(NavigationService.navigatorKey.currentContext!).cardColor,
            scaffoldBackgroundColor: Theme.of(NavigationService.navigatorKey.currentContext!).scaffoldBackgroundColor,
          ),
          colorSchemeLight: ColorSchemeModel(
            colorScheme: Theme.of(NavigationService.navigatorKey.currentContext!).colorScheme,
            cardColor: Theme.of(NavigationService.navigatorKey.currentContext!).cardColor,
            scaffoldBackgroundColor: Theme.of(NavigationService.navigatorKey.currentContext!).scaffoldBackgroundColor,
          ),
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
        response = BaseResponse(code: 200, message: "success", eventName: "navigateToSuperAppScreen", data: null);
        NavigationService.pushNamed(routeName: data['screenName'], args: data['arguments']);
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
  void openMiniApps(dynamic msg, CompletionHandler handler) {
    String serviceKey = "municipalservice"; //for testing only
    //String serviceKey =  msg["serviceKey"];

    if (checkAppRequirement(serviceKey, RequirementEnum.navigateToSuperAppScreen.name) == true) {
      late BaseResponse response;
      if (msg != null && msg is String) {
        Map data = jsonDecode(msg);
        sl<NewMiniAppLogicCubit>().openMiniAppByServiceKey(serviceKey: data["miniAppKey"], path: data['path']);
        response = BaseResponse(code: 200, message: "success", eventName: "navigateToSuperAppScreen", data: null);
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
        code: 401,
        message: "you do not have permission to access this functionality",
        eventName: "navigateToSuperAppScreen",
        data: null,
      );
      handler.complete(response.jsonEncodeModel());
    }
  }

  @pragma('vm:entry-point')
  void checkPermission(dynamic msg, CompletionHandler handler) async {
    String serviceKey = "municipalservice"; //for testing only
    //String serviceKey =  msg["serviceKey"];
    if (checkAppRequirement(serviceKey, RequirementEnum.checkPermission.name) == true) {
      if (msg != null && (msg is String || msg is Map)) {
        Map data;
        msg is String ? data = jsonDecode(msg) : data = msg;
        String permissionName = data["permission_name"];
        bool state = false;
        BaseResponse response;
        switch (permissionName) {
          case "location":
            state = await CommonFunctions.checkLocationSettings(NavigationService.navigatorKey.currentContext!);
            break;
          case "camera":
            state = await CommonFunctions.checkCameraSettings(NavigationService.navigatorKey.currentContext!);
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
          response = BaseResponse(code: 200, message: "success", eventName: "getPermissionResponse", data: null);
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
          data: JsLocationModel(latitude: latLng.latitude, longitude: latLng.longitude),
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
        // var res=  await CommonFunctions.checkLocationSettings(
        //    NavigationService.navigatorKey.currentContext!,
        //  );
        // if(res)
        //   {
        //     getLocation(msg, handler);
        //   }
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
      isLoading.value = true;
      final XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
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
            filePath: path,
          );
          response = BaseResponse(code: 200, eventName: "openImagePicker", message: "success", data: file);
        }
      } else {
        response = BaseResponse(code: 300, eventName: "openImagePicker", message: "Can't get image", data: null);
      }
      isLoading.value = false;
      handler.complete(response.jsonEncodeModel());
    } else {
      BaseResponse response = BaseResponse(
        code: 500,
        message: "you do not have permission to access this functionality",
        eventName: "openImagePicker",
        data: null,
      );
      handler.complete(response.jsonEncodeModel());
      isLoading.value = false;
    }
  }

  @pragma('vm:entry-point')
  void openCameraWithUI(dynamic msg, CompletionHandler handler) async {
    String serviceKey = "municipalservice"; //for testing only
    //String serviceKey =  msg["serviceKey"];
    if (checkAppRequirement(serviceKey, RequirementEnum.camera.name) == true) {
      late BaseResponse response;
      isLoading.value = true;
      FocusManager.instance.primaryFocus?.unfocus();
      var fileData = await NavigationService.navigatorKey.currentState!.pushNamed(RouteName.vdCameraPage);
      if (fileData != null) {
        response = BaseResponse(
          code: 200,
          eventName: "openCameraWithUI",
          message: "success",
          data: fileData is AttachmentItem ? fileData : null,
        );
      } else {
        response = BaseResponse(code: 300, eventName: "openCameraWithUI", message: "Not Selected File", data: null);
      }
      // String data = response.jsonEncodeModel();
      isLoading.value = false;
      handler.complete(response.jsonEncodeModel());
    } else {
      BaseResponse response = BaseResponse(
        code: 500,
        message: "you do not have permission to access this functionality",
        eventName: "openCameraWithUI",
        data: null,
      );
      isLoading.value = false;
      handler.complete(response.jsonEncodeModel());
    }
  }

  @pragma('vm:entry-point')
  void openFilePicker(dynamic msg, CompletionHandler handler) async {
    print('raw msg : $msg');

    // Ensure msg is always a Map<String, dynamic>
    late final Map<String, dynamic> data;
    if (msg is String) {
      try {
        data = jsonDecode(msg) as Map<String, dynamic>;
      } catch (e) {
        print("❌ Failed to decode msg as JSON: $e");
        data = {};
      }
    } else if (msg is Map) {
      data = Map<String, dynamic>.from(msg);
    } else {
      print("❌ Unsupported msg type: ${msg.runtimeType}");
      data = {};
    }

    // Extract values safely
    final String serviceKey = data["serviceKey"]?.toString() ?? "municipalservice";
    final String? attachmentSource = data["attachmentSource"]?.toString();
    final List<String> attachmentExtension = data["attachmentExtension"] != null
        ? (data["attachmentExtension"] as List<dynamic>).map((e) => e.toString()).toList()
        : [];

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

              JsFilesModel pickedFile = JsFilesModel(fileBase64: base64File, fileName: fileName, filePath: path);

              response = BaseResponse(code: 200, message: "success", data: pickedFile, eventName: "openFilePicker");
            }
          }
        } else {
          response = BaseResponse(code: 300, message: "Can't get file", data: null, eventName: "openFilePicker");
        }
      } on PlatformException catch (_) {
        response = BaseResponse(code: 500, message: "Error occurred", eventName: "openFilePicker", data: null);
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
        final context = NavigationService.navigatorKey.currentContext;
        if (context != null) {
          safeShareText(msg, context: context);
        }
        response = BaseResponse(code: 200, eventName: "openShare", message: "success", data: null);
        handler.complete(response.jsonEncodeModel());
      } else {
        response = BaseResponse(code: 400, eventName: "openShare", message: "Invalid share data", data: null);
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
      if (msg != null && msg is String) {
        Map data = jsonDecode(msg);
        bool canLaunch = await canLaunchUrl(Uri.parse(data['uri']));
        if (canLaunch) {
          await launchUrl(Uri.parse(data['uri']));
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
      if (dataUri != null && dataUri is String) {
        Map data = jsonDecode(dataUri);
        if (data["url"] != null) {
          if (data["type"] == "pdf") {
            NavigationService.navigatorKey.currentState!.push(
              MaterialPageRoute(
                builder: (_) {
                  return Scaffold(
                    appBar: AppBar(title: const Text("")),
                    body: SfPdfViewer.network(data["url"]),
                  );
                },
              ),
            );
            BaseResponse response = BaseResponse(
              code: 200,
              eventName: "openWebView",
              message: "pdf_opened",
              data: null,
            );
            handler.complete(response.jsonEncodeModel());
          } else {
            List<String>? callbackUrls;
            final cbList = data['callbackUrls'];
            if (cbList is List) {
              callbackUrls = cbList.map((e) => e.toString()).toList();
            }

            final result = await CommonFunctions.openBaladyWebView(
              data["url"],
              needLogin: data["needLogin"] ?? true,
              callbackUrls: callbackUrls,
              isObjections: data["isObjections"] ?? false,
            );

            BaseResponse response = BaseResponse(
              code: 200,
              eventName: "openWebView",
              message: "done",
              data: result != null ? CallBackModel.fromJson(result as Map<String, dynamic>) : null,
            );
            handler.complete(response.jsonEncodeModel());
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
  void openPdfFile(dynamic dataUri, CompletionHandler handler) async {
    String serviceKey = "municipalservice"; //for testing only
    //String serviceKey =  msg["serviceKey"];
    if (checkAppRequirement(serviceKey, RequirementEnum.openWebView.name) == true) {
      if (dataUri != null && dataUri is String) {
        Map data = jsonDecode(dataUri);
        NavigationService.navigatorKey.currentState!.push(
          MaterialPageRoute(
            builder: (_) {
              return PdfViewerScreen(pdfData: JsPdfModel.fromJson(data));
            },
          ),
        );
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
    BaseResponse response = BaseResponse(code: 400, eventName: "trackLogs", message: "Invalid event data", data: null);
    if (kDebugMode) print("Errors :  $msg");
    if (msg != null && msg is String && msg.isNotEmpty) {
      try {
        Map<String, dynamic> data = jsonDecode(msg);
        response = BaseResponse(code: 200, eventName: "trackLogs", message: "Event tracked successfully", data: null);
        Map<String, dynamic> miniAppData = {
          'MiniAppKey': miniAppsEngineBloc.miniApp.serviceKey,
          'MiniAppVersion': miniAppsEngineBloc.miniApp.latestVersion?.versionNumber,
        };
        if (data['type'] == "marketing") {
          FlutterUxcam.logEventWithProperties(data['event_name'], miniAppData);
          Sentry.addBreadcrumb(Breadcrumb(message: data['event_name'], data: miniAppData));
        } else if (data['type'] == "exception") {
          data.addAll(miniAppData);
          FlutterUxcam.logEventWithProperties(data['event_name'], data);
          Sentry.captureEvent(
            SentryEvent(
              message: SentryMessage(data['event_name']),
              transaction: data['errors_model']?['error']?.toString() ?? "",
              // value: data['errors_model']?['error']?.toString() ?? "",
              // module: miniAppsEngineBloc.miniApp.serviceKey,
              serverName: miniAppsEngineBloc.miniApp.serviceKey,
              contexts: Contexts()..['MiniAppDataErrors'] = data,
            ),
            stackTrace: data['errors_model']?['stackTrace'],
          );
        } else {}
      } catch (e) {
        print(e);
      }
    }
    handler.complete(response.jsonEncodeModel());
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
      if (data != null) {
        data = jsonDecode(data);
      }
      if (data is Map) {
        BaseResponse response = BaseResponse(
          code: 200,
          eventName: "openDirectionsMap",
          message: "Event tracked successfully",
          data: null,
        );
        CommonFunctions.launchMap(LatLng(latitude: data["latitude"], longitude: data["longitude"]));
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
  void sendToCalender(dynamic mas, CompletionHandler handler) {
    String serviceKey = "municipalservice"; //for testing only
    //String serviceKey =  msg["serviceKey"];
    if (checkAppRequirement(serviceKey, RequirementEnum.sendToCalender.name) == true) {
      Map? data;
      if (mas is String) {
        data = jsonDecode(mas);
      } else {
        data = mas;
      }
      if (data != null) {
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
        if (kDebugMode) print('data: $mas');
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
                  if (kDebugMode) print("object");
                }
              },
              //Received data with List<int>
              options: Options(
                responseType: ResponseType.bytes,
                followRedirects: false,
                validateStatus: (status) {
                  return (status ?? 501) < 500;
                },
              ),
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

  Future<void> unarchiveAndSave(String? extractPath, var zippedFile, CompletionHandler handler) async {
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

  @pragma('vm:entry-point')
  void selectedDelegator(dynamic msg, CompletionHandler handler) async {
    try {
      final cubit = sl<DelegatorsCubit>();

      // First, check if there's a currently selected delegator in the cubit state
      DelegatorEntity? selectedDelegate = cubit.state.selectedDelegate;

      // If not in state, try to get from SharedPreferences and find it in the list
      if (selectedDelegate == null) {
        final savedDelegatorId = sharedPrefs.getSelectedDelegatorId();

        if (savedDelegatorId == null) {
          // No selection saved
          final response = BaseResponse(code: 200, message: "success", eventName: "selectedDelegator", data: null);
          handler.complete(response.jsonEncodeModel());
          return;
        }

        // Fetch delegators if not already loaded
        if (cubit.state.delegators.isEmpty) {
          cubit.loadData();

          // Wait for data to load (max 10 seconds)
          int attempts = 0;
          while (attempts < 20 && cubit.state.accountStatus == DelegatorsAccountStatus.loading) {
            await Future.delayed(const Duration(milliseconds: 500));
            attempts++;
          }
        }

        // Find the delegator matching the saved ID
        try {
          selectedDelegate = cubit.state.delegators.firstWhere((d) => d.id == savedDelegatorId);
        } catch (e) {
          // Delegator not found in current list
          print('Selected delegator $savedDelegatorId not found in delegators list');
        }
      }

      BaseResponse response;
      if (selectedDelegate != null) {
        response = BaseResponse(
          code: 200,
          message: "success",
          eventName: "selectedDelegator",
          data: JsDelegatorModel.fromEntity(selectedDelegate),
        );
      } else {
        // No delegator selected
        response = BaseResponse(code: 200, message: "success", eventName: "selectedDelegator", data: null);
      }

      handler.complete(response.jsonEncodeModel());
    } catch (e) {
      BaseResponse response = BaseResponse(
        code: 500,
        message: "Error getting selected delegator: $e",
        eventName: "selectedDelegator",
        data: null,
      );
      handler.complete(response.jsonEncodeModel());
    }
  }

  @pragma('vm:entry-point')
  void selectedAgent(dynamic msg, CompletionHandler handler) async {
    try {
      final cubit = sl<DelegatorsCubit>();

      // First, check if there's a currently selected agent in the cubit state
      AgentEntity? selectedAgent = cubit.state.selectedAgent;

      // If not in state, try to get from SharedPreferences and find it in the list
      if (selectedAgent == null) {
        final savedAgentId = sharedPrefs.getSelectedAgentId();

        if (savedAgentId == null) {
          // No selection saved
          final response = BaseResponse(code: 200, message: "success", eventName: "selectedAgent", data: null);
          handler.complete(response.jsonEncodeModel());
          return;
        }

        // Fetch agents if not already loaded
        if (cubit.state.agents.isEmpty) {
          cubit.loadData();

          // Wait for data to load (max 10 seconds)
          int attempts = 0;
          while (attempts < 20 && cubit.state.accountStatus == DelegatorsAccountStatus.loading) {
            await Future.delayed(const Duration(milliseconds: 500));
            attempts++;
          }
        }

        // Find the agent matching the saved ID
        try {
          selectedAgent = cubit.state.agents.firstWhere((a) => a.agencyNumber == savedAgentId);
        } catch (e) {
          // Agent not found in current list
          print('Selected agent $savedAgentId not found in agents list');
        }
      }

      BaseResponse response;
      if (selectedAgent != null) {
        response = BaseResponse(
          code: 200,
          message: "success",
          eventName: "selectedAgent",
          data: JsAgentModel.fromEntity(selectedAgent),
        );
      } else {
        // No agent selected
        response = BaseResponse(code: 200, message: "success", eventName: "selectedAgent", data: null);
      }

      handler.complete(response.jsonEncodeModel());
    } catch (e) {
      BaseResponse response = BaseResponse(
        code: 500,
        message: "Error getting selected agent: $e",
        eventName: "selectedAgent",
        data: null,
      );
      handler.complete(response.jsonEncodeModel());
    }
  }

  @pragma('vm:entry-point')
  void getRideHailingKey(dynamic msg, CompletionHandler handler) async {
    String serviceKey = "municipalservice";
    if (checkAppRequirement(serviceKey, RequirementEnum.rideHailingKey.name) == true) {
      BaseResponse response = BaseResponse(
        code: 200,
        eventName: "getRideHailingKey",
        message: "success",
        data: RideHailingKeyModel(rideHailingKey: "test_key"),
      );
      handler.complete(response.jsonEncodeModel());
    } else {
      BaseResponse response = BaseResponse(
        code: 500,
        message: "you do not have permission to access this functionality",
        eventName: "getRideHailingKey",
        data: null,
      );
      handler.complete(response.jsonEncodeModel());
    }
  }
}

bool checkAppRequirement(String serviceKey, String requirementKey) {
  return true;
}
