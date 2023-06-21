import 'dart:convert' show base64Decode, base64Encode, utf8;
import 'dart:io' show File;
import 'dart:typed_data' show Uint8List;
import 'dart:ui';

import 'package:balady_plus/app/core/utils/constants/remote_config.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart' show PlatformFile;
import 'package:flutter_bloc/flutter_bloc.dart' show EventTransformer;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:open_file/open_file.dart' show OpenFile;
import 'package:path_provider/path_provider.dart' show getTemporaryDirectory;

import 'package:flutter_bloc/flutter_bloc.dart' show EventTransformer;
import 'package:permission_handler/permission_handler.dart';
import 'package:stream_transform/stream_transform.dart' show RateLimit, Switch;
import 'package:url_launcher/url_launcher.dart' show canLaunchUrl, launchUrl;
import 'package:uuid/uuid.dart';

import './utils_exports.dart'
    show AppConfig, AppLanguage, EnvType, MimeType, UIHelper, WithDelay;
import '../../features/_shared_feature_/data/entities/device_details.dart';
import '../../features/_shared_feature_/presentation/dialogs/camera_permission_dialog.dart';
import '../../features/_shared_feature_/presentation/dialogs/location_permission_dialog.dart';
import '../../features/_shared_feature_/presentation/dialogs/location_service_dialog.dart';
import '../../features/_shared_feature_/shared_feature_exports.dart'
    show AuthData, BridgeParams, FileInfo;
import '../../features/entry_point/domain/entities/sso_user_info.dart'
    show SsoUserInfo;
import '../../features/entry_point/domain/entities/sso_user_info.dart';
import '../../features/entry_point/presentation/cubit/auth_cubit.dart';
import '../../features/profile_features/delegators/delegators_exports.dart'
    show DelegatorEntity;
import '../dependency_injection/dependency_injection_exports.dart' show sl;
import '../services/services_exports.dart'
    show AppInterceptors, EntryPointBridge;

class CommonFunctions {
  static EventTransformer<Event> debounce<Event>([Duration? duration]) =>
      (events, mapper) =>
          events.debounce(duration ?? UIHelper.duration).switchMap(mapper);

  static void signOut() {
    final params = sl<BridgeParams>().copyWith(isAuthenticated: false);

    final entryPointBridge = sl<EntryPointBridge>();
    entryPointBridge(params);
  }

  static String fileMimeType(String extension) {
    extension = extension.toLowerCase();
    return MimeType.values.byName(extension).mime;
  }

  static Uint8List dataFromBase64String(String base64String) =>
      Uri.parse(base64String).data!.contentAsBytes();

  static String base64String(Uint8List data) => base64Encode(data);

  static int convertBytesToMB(int bytes) => (bytes / 1048576).round();

  static Future<FileInfo> getFileInfo(PlatformFile file) async {
    final mimeType = fileMimeType(file.extension ?? '');
    final content = await fileToBase64(file.path ?? '', mimeType: mimeType);
    final fileInfo = sl<FileInfo>().copyWith(
      fileBase64: content,
      filePath: file.path,
      fileName: file.name,
      sizeInMB: convertBytesToMB(file.size),
      extension: file.extension,
    );
    return fileInfo.toFuture();
  }

  static Future<String> fileToBase64(
    String filePath, {
    String? mimeType,
  }) async {
    final bytes = await File(filePath).readAsBytes();
    String base64RecordingFile = base64Encode(bytes);
    if (mimeType != null) {
      final baseData = "data:$mimeType;base64,";
      base64RecordingFile = baseData + base64RecordingFile;
    }
    return Future.value(base64RecordingFile);
  }

  static String formatDate(String? date, [Duration? duration]) {
    final dateStr = DateTime.tryParse(date ?? '')?.toLocal();
    return dateStr != null
        ? DateFormat('dd-MM-yyyy')
            .format(dateStr.add(duration ?? const Duration()))
        : '';
  }

  static Dio getDio({required String baseUrl}) {
    Dio dio = Dio();
    dio.options.baseUrl = sl<EnvType>().domain;
    dio.options.connectTimeout = 5000;
    dio.options.receiveTimeout = 5000;
    dio.options.sendTimeout = 5000;
    dio.options.headers = {};
    dio.interceptors.add(AppInterceptors());
    return dio;
  }

  static Future<void> createOpenTempFile(
    String fileName,
    String content,
  ) async {
    // create Temporary File
    final tempDir = await getTemporaryDirectory();
    final tempDocumentPath = '${tempDir.path}/$fileName';
    final file = await File(tempDocumentPath).create(recursive: true);
    Uint8List bytes = base64Decode(content);
    file.writeAsBytesSync(bytes);

    // Open File From file path
    OpenFile.open(tempDocumentPath);
  }

  static Future<void> openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }

  static Future<void> openMap(double latitude, double longitude) async {
    final Uri googleUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
    );
    if (await canLaunchUrl(googleUrl)) {
      await launchUrl(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  static String mapARNumbersToENNumbers(String numbers) {
    Map<String, String> arToEnMapper = {
      '٠': '0',
      '١': '1',
      '٢': '2',
      '٣': '3',
      '٤': '4',
      '٥': '5',
      '٦': '6',
      '٧': '7',
      '٨': '8',
      '٩': '9',
    };
    String englishNumbers = '';
    // numbers can be mix between ar and en
    for (int i = 0; i < numbers.length; i++) {
      if (arToEnMapper.containsKey(numbers[i])) {
        englishNumbers += arToEnMapper[numbers[i]]!;
      } else {
        englishNumbers += numbers[i];
      }
    }

    return englishNumbers;
  }

  static String generateUUID() {
    try {
      const uuid = Uuid();
      String v1UUID = uuid.v1();
      final deviceDetails = sl<DeviceDetails>();
      String v5UUID = uuid.v5(v1UUID, deviceDetails.deviceId);
      if (v5UUID.isNotEmpty) {
        return v5UUID.replaceAll("-", "");
      } else if (v1UUID.isNotEmpty) {
        return v1UUID.replaceAll("-", "");
      } else {
        return DateTime.now().millisecondsSinceEpoch.toString();
      }
    } catch (ex) {
      return DateTime.now().millisecondsSinceEpoch.toString();
    }
  }

  static String hashRequest(
    String url,
    String method, {
    String? body,
    bool authorization = false,
    String? corelationId,
  }) {
    //var encodedURL = Uri.encodeComponent(url);

    String message = "";
    message = url + method;

    if (corelationId != null) message += corelationId;
    //if (authorization) message += 'Bearer $token';

    if (body != null) {
      message += body.replaceAll(RegExp(r'^/\\n/g'), "");
    }
    /*message.errorLog();
    ;
    body.errorLog();*/

    message.trim();
    var key = utf8.encode(RemoteConfig.hmCode);
    var bytes = utf8.encode(message);

    var hmacSha256 = Hmac(sha256, key);
    var digest = hmacSha256.convert(bytes);
    String base64 = base64Encode(digest.bytes);
    return base64;
  }

  static bool get isAuthed => sl.isRegistered<AuthData>();
  static bool get isAppAR => AppConfig.languageCode == AppLanguage.ar.name;

  static Future<bool> onLogin() async => await sl<EntryPointCubit>().onLogin();
  static bool doesContainsLettrs(String str) {
    RegExp r = RegExp(r"[a-zA-Z\u0621-\u064A]");
    return r.allMatches(str).length >= 15;
  }

  static bool hasArabicCharacters(String str) {
    RegExp r = RegExp(r"[\u0621-\u064A0-9\s*]");
    return r.allMatches(str).length == str.length;
  }

  static bool hasArabicOrEnglishCharacters(String str) {
    RegExp r = RegExp(r"[\u0621-\u064Aa-zA-Z\s]");
    return r.allMatches(str).length == str.length;
  }

  static bool checkForVDExpectedForINC(
      {String? adminMunicipalityId,
      String? municipalityName,
      bool? isVDExcepted}) {
    if (adminMunicipalityId == "003" && municipalityName == "العلا") {
      try {
        String error = ("ola_incident_error").tr(); //MMTr;
        showError(error);
      } catch (ex) {}

      return true;
    } else {
      if (isVDExcepted ?? false) {
        String error = ("inc_vd_excepted").tr();

        showError(error);
        return true;
      }
    }

    return false;
  }

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
      } catch (ex) {
        print(ex);
      }
    }
  }

  static Future<bool> checkLocationSettings(BuildContext context) async {
    ServiceStatus serviceStatus = await Permission.location.serviceStatus;
    if (serviceStatus != ServiceStatus.disabled) {
      var status = await Permission.location.request();
      print(status);
      if (status == PermissionStatus.permanentlyDenied) {
        showDialog(
            context: context,
            builder: (ctx) => const LocationPermissionDialog());
        return false;
      } else if (status != PermissionStatus.granted) {
        Permission.location.request();
        return false;
      } else {
        return true;
      }
    } else {
      showDialog(
          context: context, builder: (ctx) => const LocationServiceDialog());

      return false;
    }
  }

  static Future<bool> checkCameraSettings(BuildContext context) async {
    var status = await Permission.camera.request();
    if (status == PermissionStatus.permanentlyDenied) {
      showDialog(
          context: context, builder: (ctx) => const CameraPermissionDialog());
      return false;
    } else if (status != PermissionStatus.granted) {
      Permission.camera.request();
      return false;
    } else {
      return true;
    }
  }
}

class CommonProperties {
  // static String token = sl<EntryPointCubit>().state.token?.token ?? "";
  static SsoUserInfo? userInfo =
      _fakeUser; //sl<EntryPointCubit>().state.userInfo;
  static DelegatorEntity? get selectedDelegator =>
      sl<EntryPointCubit>().state.selectedDelegator;
  static bool isLoggedIn = sl<EntryPointCubit>().state.token != null;
  //static SsoUserInfo? userInfo = sl<EntryPointCubit>().state.userInfo;

  static LatLng defaultLocation =
      const LatLng(24.76836756001484, 46.720988751704304);

  static String token =
      "eyJhbGciOiJSUzI1NiIsImtpZCI6IjhFRDBCN0UzRjNDOTFBOEQwMUU3MEMxRUM4MTNGQTJBRjgxOEQ5MUZSUzI1NiIsIng1dCI6Imp0QzM0X1BKR28wQjV3d2V5QlA2S3ZnWTJSOCIsInR5cCI6ImF0K2p3dCJ9.eyJpc3MiOiJodHRwczovL3Nzb2FwcGRldi5tb21yYS5nb3Yuc2EiLCJuYmYiOjE2ODY2NTAzMjksImlhdCI6MTY4NjY1MDMyOSwiZXhwIjoxNjg3NTE0MzI5LCJhdWQiOlsiR2lzQXBpIiwiaHR0cHM6Ly9zc29hcHBkZXYubW9tcmEuZ292LnNhL3Jlc291cmNlcyJdLCJzY29wZSI6WyJvcGVuaWQiLCJwcm9maWxlIiwiR2lzQXBpIiwib2ZmbGluZV9hY2Nlc3MiXSwiYW1yIjpbInB3ZCJdLCJjbGllbnRfaWQiOiJCYWxhZHkuTW9tdGF0aGVsLkFQUCIsInN1YiI6IjdjMzY2Nzc4LWEwMjEtNDcwNy04MjQzLTdjM2RmNTljN2ZmOCIsImF1dGhfdGltZSI6MTY4NjY1MDMyOCwiaWRwIjoibG9jYWwiLCJuYW1lIjoiMjExMTY5MjU5MiIsIm1haWwiOiJtLmFobWVkQGlubm9zb2Z0Lm1leHgiLCJzZXgiOiIxIiwiZG9iIjoiMzEvMDUvMTk5NSIsInBob25lIjoiMDU5Mjg0MjI3NSIsImFyX25hbWUiOiLZhdit2YXZiNivINmF2K3Zhdiv2KjZh9in2KHYp9mE2K_ZitmGICDYp9it2YXYryIsImVuX25hbWUiOiJNQUhNT1VEIE1PSEFNRURCQUhBRUxESSAgQUhNRUQiLCJpZF9ubyI6IjIxMTE2OTI1OTIiLCJuaWQiOiIyMDciLCJuYXRpb25hbGl0eSI6ItmF2LXYsSIsImlkX3R5cGUiOiIyIiwic25hbWUiOiLZhdit2YXZiNivLNmF2K3Zhdiv2KjZh9in2KHYp9mE2K_ZitmGLCzYp9it2YXYryIsInNpZCI6IjhCMDI5NTQzMDI0Mzk5NTRCMEJENjI3MzFGNEU2RDE2IiwianRpIjoiQkJDMzI3QzYyMTQ0QzAwOTRCRDVEMzZCOThFMDc0NTgifQ.Q1fXhvrc_HROU3KC_07BIIIGz44BKCrLA5tjU1IpUT2vw0CXBIczEFBrIP05ustjIirQhGWZ-dY9rYDXxqivZ-TnYTtROs1fPi9Z3pT1_tjqWKinFCFNW3GhY2JV2BsCjrzK51WTJkUHbJJB9NowmMpD5jnjB5fQEo671_8gFuL3uzmYcjdtVF7Y5S1q_lC8oee04LTCQQF2WerTfDCyyo7Y4YCHbF6-b8huFmbK7Pzn7LubmSd1prN9-zwJj93RwoMTIkVrO23Y8wiOkz0rEL0MSn-dXlAYp8A8d9SmoZSxM9QF_ifrFLzENPMpNMR0-GI8xtGBOW0Gy3nJl5B8uw";
}

const _fakeUser = SsoUserInfo(
  name: "احمد بن خالد",
  phone: "05055032820",
  mail: "Example@example.com",
  arName: "احمد بن خالد",
  idNo: "7483364364",
  nid: "",
  idType: "",
  sex: "ذكر",
  dob: "23/05/1998",
  sname: "احمد,بن خالد",
  sub: "",
  nationality: "سعودي",
);
