import 'dart:convert' show base64Decode, base64Encode, utf8;
import 'dart:io' show File;
import 'dart:typed_data' show Uint8List;
import 'dart:ui';
import 'dart:math' show asin, cos, sqrt;

import 'package:balady_plus/app/core/utils/constants/remote_config.dart';
import 'package:balady_plus/app/features/location/presentation/bloc/location_bloc.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart' show PlatformFile;
import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show EventTransformer;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart'
    show getExternalStorageDirectory, getTemporaryDirectory;

import 'package:flutter_bloc/flutter_bloc.dart' show EventTransformer;
import 'package:permission_handler/permission_handler.dart';
import 'package:sentry_dio/sentry_dio.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:stream_transform/stream_transform.dart' show RateLimit, Switch;
import 'package:url_launcher/url_launcher.dart'
    show LaunchMode, canLaunchUrl, launchUrl;
import 'package:uuid/uuid.dart';

import '../../features/_shared_feature_/data/entities/file_data_item.dart';
import '../../features/_shared_feature_/presentation/dialogs/upload_file_dialog.dart';
import '../../features/_shared_feature_/presentation/pages/pdf_view.dart';
import '../../features/entry_point/domain/use_cases/get_cookie.dart';
import '../../features/profile_features/delegators/domain/entities/user_profile_entity.dart';
import '../../features/vd/domain/entities/gis/gis_params.dart';
import '../../features/vd/domain/entities/gis/gis_response.dart';
import '../../features/vd/presentation/dialogs/vd_all_types_dialog.dart';
import './utils_exports.dart'
    show
        AppColor,
        AppConfig,
        AppLanguage,
        EnvType,
        MimeType,
        RouteName,
        UIHelper,
        WithDelay;
import '../../features/_shared_feature_/data/entities/device_details.dart';
import '../../features/_shared_feature_/presentation/dialogs/camera_permission_dialog.dart';
import '../../features/_shared_feature_/presentation/dialogs/location_permission_dialog.dart';
import '../../features/_shared_feature_/presentation/dialogs/location_service_dialog.dart';
import '../../features/_shared_feature_/shared_feature_exports.dart'
    show
        AuthData,
        BottomSheetDialog,
        BottomSheetWithActions,
        BridgeParams,
        FileInfo;
import '../../features/entry_point/domain/entities/sso_user_info.dart'
    show SsoUserInfo;
import '../../features/entry_point/domain/entities/sso_user_info.dart';
import '../../features/entry_point/presentation/cubit/auth_cubit.dart';
import '../../features/profile_features/delegators/delegators_exports.dart'
    show AgentEntity, DelegatorEntity;
import '../dependency_injection/dependency_injection_exports.dart' show sl;
import '../services/services_exports.dart'
    show
        AppInterceptors,
        EntryPointBridge,
        NavigationService,
        NoParams,
        WebService;
import 'constants/dialog_names.dart';
import 'enums/enums.dart';

FirebaseAnalytics fbAnalytics = FirebaseAnalytics.instance;

var carPlateLettersList = [
  "أ",
  "ب",
  "ح",
  "د",
  "ر",
  "س",
  "ص",
  "ط",
  "ع",
  "ق",
  "ك",
  "ل",
  "م",
  "ن",
  "هـ",
  "و",
  "ي",
];

Map<String, String> carPlateLetters = {
  "أ": "A",
  "ب": "B",
  "ح": "J",
  "د": "D",
  "ر": "R",
  "س": "S",
  "ص": "X",
  "ط": "T",
  "ع": "E",
  "ق": "G",
  "ك": "K",
  "ل": "L",
  "م": "Z",
  "ن": "N",
  "هـ": "H",
  "و": "U",
  "ي": "V",
};
Map<String, String> carEnPlateLetters = {
  "A": "أ",
  "B": "ب",
  "J": "ح",
  "D": "د",
  "R": "ر",
  "S": "س",
  "X": "ص",
  "T": "ط",
  "E": "ع",
  "G": "ق",
  "K": "ك",
  "L": "ل",
  "Z": "م",
  "N": "ن",
  "H": "هـ",
  "U": "و",
  "V": "ي",
};

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

  static void sendEventToAnalytics(String event) {
    try {
      fbAnalytics.logEvent(name: event);
    } catch (ex) {}
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
    dio.options.baseUrl = baseUrl;
    dio.options.connectTimeout = const Duration(milliseconds: 60000);
    dio.options.receiveTimeout = const Duration(milliseconds: 60000);
    dio.options.sendTimeout = const Duration(milliseconds: 60000);
    dio.options.headers = {};
    dio.addSentry();

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

  static Future<void> createOpenTempBytesFile(
    String fileName,
    Uint8List bytes,
  ) async {
    // create Temporary File
    final tempDir = await getTemporaryDirectory();
    final tempDocumentPath = '${tempDir.path}/$fileName';
    final file = await File(tempDocumentPath).create(recursive: true);
    file.writeAsBytesSync(bytes);

    // Open File From file path
    OpenFile.open(tempDocumentPath);
  }

  static Future<void> openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }

  static String getDayName(String? dateStr) {
    String dayName = "";
    try {
      String bidEndDate = dateStr ?? "";
      DateTime tempDate = DateFormat("dd-MM-yyyy").parse(bidEndDate);
      dayName = DateFormat('EEEE', CommonFunctions.isAppAR ? 'ar_SA' : 'en_US')
          .format(tempDate)
          .toString();
    } catch (e) {}
    return dayName;
  }

  static String getDate(String? dateStr) {
    String formattedDate = "";
    try {
      String bidEndDate = dateStr ?? "";
      DateTime tempDate = DateFormat("dd-MM-yyyy").parse(bidEndDate);
      formattedDate =
          DateFormat('dd', CommonFunctions.isAppAR ? 'ar_SA' : 'en_US')
              .format(tempDate)
              .toString();
    } catch (e) {}
    return replaceArabicNumberWithEnglish(formattedDate);
  }

  static String getMonthName(String? dateStr) {
    String monthName = "";
    try {
      String bidEndDate = dateStr ?? "";
      DateTime tempDate = DateFormat("dd-MM-yyyy").parse(bidEndDate);
      monthName =
          DateFormat('MMMM', CommonFunctions.isAppAR ? 'ar_SA' : 'en_US')
              .format(tempDate)
              .toString();
    } catch (e) {}
    return monthName;
  }

  static int getDifferenceBetweenDays(String? dateStr) {
    int difference = 0;
    try {
      String bidEndDate = dateStr ?? "";
      DateTime tempDate = DateFormat("yyyy/MM/dd").parse(bidEndDate);
      final date = DateTime.now();
      difference = tempDate.difference(date).inDays;
    } catch (e) {}
    return difference;
  }

  static String getFormattedTimeEkram(String? timeStr,
      {Duration? subtractedDuration}) {
    String formattedTime = "";
    print(timeStr);
    try {
      String biddingEndingTime = timeStr ?? "";
      DateTime tempTime =
          DateFormat("yyyy/M/dd hh:mm:ss").parse(biddingEndingTime);
      String time = DateFormat("h:mm a", isAppAR ? 'ar_SA' : 'en_US')
          .format(tempTime)
          .toString();
      formattedTime = time;
    } catch (ex) {
      print(ex);
    }
    return replaceArabicNumberWithEnglish(formattedTime);
  }

  static String getFormattedDateEkram(String? timeStr,
      {Duration? subtractedDuration}) {
    String formattedTime = "";
    try {
      String biddingEndingTime = timeStr ?? "";
      DateTime tempTime =
          DateFormat("yyyy/M/dd H:mm:ss").parse(biddingEndingTime);
      String time = DateFormat("yyyy/M/dd").format(tempTime).toString();
      formattedTime = time;
    } catch (ex) {
      print(ex);
    }
    return replaceArabicNumberWithEnglish(formattedTime);
  }

  static String getFormattedDateEkramCard(String? timeStr,
      {Duration? subtractedDuration}) {
    String formattedTime = "";
    try {
      String biddingEndingTime = timeStr ?? "";
      DateTime tempTime =
          DateFormat("dd-M-yyyy H:mm:ss").parse(biddingEndingTime);
      String time = DateFormat("yyyy/M/dd").format(tempTime).toString();
      formattedTime = time;
    } catch (ex) {
      print(ex);
    }
    return replaceArabicNumberWithEnglish(formattedTime);
  }

  static String getDistance(LatLng? location, LatLng? currentLocation) {
    String distance = "-";
    if (currentLocation != null && location != null) {
      double dis = calculateDistance(location.latitude, location.longitude,
          currentLocation.latitude, currentLocation.longitude);

      if (dis >= 1000) {
        distance = ("distance_km")
            .tr()
            .replaceAll("-", (dis / 1000).toStringAsFixed(0));
      } else {
        distance = ("distance_meter").tr().replaceAll("-", (dis).toString());
      }
    }

    return distance;
  }

  static double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)) * 1000;
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

  static Future<void> openUber(double latitude, double longitude) async {
    final String url =
        'https://m.uber.com/ul/?action=setPickup&pickup=my_location&dropoff[latitude]=$latitude&dropoff[longitude]=$longitude';

    await externalLaunch(url);
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

  static Future<FileDataItem?> pickFile(BuildContext context,
      {bool imagesOnly = false, bool filesOnly = false}) async {
    final file = await BottomSheetDialog.showDraggableSheet(context,
        isFullHeight: false,
        height: 300,
        child: BottomSheetWithActions(
          title: imagesOnly ? ('uploadImage').tr() : ('uploadFile').tr(),
          body: UploadFileDialog(
              onConfirm: (FileDataItem file) {
                NavigationService.navigatorKey.currentState?.pop(file);
              },
              imagesOnly: imagesOnly,
              filesOnly: filesOnly),
        ));

    return Future.value(file is FileDataItem ? file : null);
  }

  static Future<TimeOfDay?> pickTime(BuildContext context) async {
    return await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (_, child) => Theme(
            data: ThemeData.light().copyWith(
              colorScheme: const ColorScheme.light(
                primary: AppColor.primary900Light,
                onSurface: AppColor.blackModern500Light,
              ),
            ),
            child: child ?? const SizedBox()));
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
    if (authorization) message += 'Bearer ${CommonProperties.token}';

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

  static String generateGUID() {
    try {
      String v1UUID = CommonProperties.uuidInstance.v1();
      String v5UUID =
          CommonProperties.uuidInstance.v5(v1UUID, CommonProperties.deviceId);

      if (v5UUID.isNotEmpty)
        return v5UUID.replaceAll("-", "");
      else if (v1UUID.isNotEmpty)
        return v1UUID.replaceAll("-", "");
      else
        return DateTime.now().millisecondsSinceEpoch.toString();
    } catch (ex) {
      return DateTime.now().millisecondsSinceEpoch.toString();
    }
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

  static String replaceArabicNumberWithEnglish(String value) {
    var newStr = "";

    for (int i = 0; i < value.length; i++) {
      switch (value[i]) {
        case "٠":
          newStr += "0";
          break;
        case "١":
          newStr += "1";
          break;
        case "٢":
          newStr += "2";
          break;
        case "٣":
          newStr += "3";
          break;
        case "٤":
          newStr += "4";
          break;
        case "٥":
          newStr += "5";
          break;
        case "٦":
          newStr += "6";
          break;
        case "٧":
          newStr += "7";
          break;
        case "٨":
          newStr += "8";
          break;
        case "٩":
          newStr += "9";
          break;
        default:
          newStr += value[i];
      }
    }
    return newStr.isEmpty ? value : newStr;
  }

  static String replaceEnglishNumberWithArabic(String value) {
    var newStr = "";

    for (int i = 0; i < value.length; i++) {
      switch (value[i]) {
        case "0":
          newStr += "٠";
          break;
        case "1":
          newStr += "١";
          break;
        case "2":
          newStr += "٢";
          break;
        case "3":
          newStr += "٣";
          break;
        case "4":
          newStr += "٤";
          break;
        case "5":
          newStr += "٥";
          break;
        case "6":
          newStr += "٦";
          break;
        case "7":
          newStr += "٧";
          break;
        case "8":
          newStr += "٨";
          break;
        case "9":
          newStr += "٩";
          break;
        default:
          newStr += value[i];
      }
    }
    return newStr.isEmpty ? value : newStr;
  }

  static String replaceArabicNumberWithEnglish2(String value) {
    var newStr = "";

    for (int i = 0; i < value.length; i++) {
      switch (value[i]) {
        case "٠":
          newStr += "0";
          break;
        case "١":
          newStr += "1";
          break;
        case "٢":
          newStr += "2";
          break;
        case "٣":
          newStr += "3";
          break;
        case "٤":
          newStr += "4";
          break;
        case "٥":
          newStr += "5";
          break;
        case "٦":
          newStr += "6";
          break;
        case "٧":
          newStr += "7";
          break;
        case "٨":
          newStr += "8";
          break;
        case "٩":
          newStr += "9";
          break;
        default:
          newStr = value[i] + newStr;
      }
    }
    return newStr.isEmpty ? value : newStr;
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

  static showSuccess(String msg) {
    if (msg.isNotEmpty) {
      try {
        BotToast.showSimpleNotification(
            title: msg,
            backgroundColor: AppColor.baladyDarkGreen2,
            titleStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
                fontSize: 16.0),
            hideCloseButton: true,
            duration: const Duration(seconds: 3));
      } catch (ex) {}
    }
  }

  static void openBaladyWebView(String? url,
      {bool isObjections = false}) async {
    print(url);
    EasyLoading.show();
    GetCookie getCookie = GetCookie(repository: sl());
    final failureOrSuccessForCookie = await getCookie(NoParams());
    EasyLoading.dismiss();
    failureOrSuccessForCookie.fold((l) {
      CommonFunctions.showError("server_error_1".tr());
    }, (r) async {
      Navigator.of(NavigationService.navigatorKey.currentContext!).pushNamed(
        RouteName.inappWebview,
        arguments: (requestNum: ''.tr(), url: url, isObjections: isObjections),
      );
    });
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
      } catch (ex) {}
    }
  }

  static Future<bool> checkLocationSettings(BuildContext context) async {
    ServiceStatus serviceStatus = await Permission.location.serviceStatus;
    if (serviceStatus != ServiceStatus.disabled) {
      var status = await Permission.location.request();

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

  static String convert24TimeTo12WithPeriod(String? time) {
    if (time != null) {
      int? hoursFrom = int.tryParse(time.split(":")[0]) != null
          ? int.parse(time.split(":")[0])
          : null;
      int? minuteFrom = int.tryParse(time.split(":")[1]) != null
          ? int.parse(time.split(":")[1])
          : null;

      TimeOfDay fromTime =
          TimeOfDay(hour: hoursFrom!, minute: minuteFrom!); // 3:00 PM

      int hoursFromAS12 = hoursFrom;

      if (hoursFrom == 0) hoursFromAS12 += 12;

      String minuteStr = minuteFrom < 10 ? "0$minuteFrom" : "$minuteFrom";

      if (hoursFrom >= 13 && hoursFrom <= 23) {
        hoursFromAS12 = hoursFromAS12 - 12;
      }

      if (fromTime.period == DayPeriod.pm) return "$hoursFromAS12:$minuteStr م";

      if (fromTime.period == DayPeriod.am) {
        return "$hoursFromAS12:$minuteStr ص";
      }
    }
    return "";
  }

  static String getFormattedTimeforQR(String? timeFrom, String? timeTo) {
    if (timeFrom != null && timeTo != null) {
      int? hoursFrom = int.tryParse(timeFrom.split(":")[0]) != null
          ? int.parse(timeFrom.split(":")[0])
          : null;
      int? hoursTo = int.tryParse(timeTo.split(":")[0]) != null
          ? int.parse(timeTo.split(":")[0])
          : null;

      int? minuteFrom = int.tryParse(timeFrom.split(":")[1]) != null
          ? int.parse(timeFrom.split(":")[1])
          : null;
      int? minuteTo = int.tryParse(timeTo.split(":")[1]) != null
          ? int.parse(timeTo.split(":")[1])
          : null;
      String minuteFromStr = minuteFrom! < 10 ? "0$minuteFrom" : "$minuteFrom";
      String minuteToStr = minuteTo! < 10 ? "0$minuteTo" : "$minuteTo";
      TimeOfDay fromTime =
          TimeOfDay(hour: hoursFrom!, minute: minuteFrom); // 3:00 PM
      TimeOfDay toTime = TimeOfDay(hour: hoursTo!, minute: minuteTo); // 5:00 AM

      int hoursFromAS12 = hoursFrom;
      int hoursToAS12 = hoursTo;

      if (hoursFrom == 0) hoursFromAS12 += 12;

      if (hoursTo == 0) hoursToAS12 += 12;

      if (hoursFrom >= 13 && hoursFrom <= 23) {
        hoursFromAS12 = hoursFromAS12 - 12;
      }

      if (hoursTo >= 13 && hoursTo <= 23) hoursToAS12 = hoursToAS12 - 12;

      String time = "";

      if (fromTime.period == DayPeriod.am && toTime.period == DayPeriod.am) {
        time = "$hoursFromAS12:$minuteFromStr - $hoursToAS12:$minuteToStr ص";
        return time;
      } else if (fromTime.period == DayPeriod.pm &&
          toTime.period == DayPeriod.pm) {
        time = "$hoursFromAS12:$minuteFromStr - $hoursToAS12:$minuteToStr م";
        return time;
      } else {
        String from = "";
        String to = "";
        if (fromTime.period == DayPeriod.pm) {
          from = "$hoursFromAS12:$minuteFromStr م";
        }

        if (fromTime.period == DayPeriod.am) {
          from = "$hoursFromAS12:$minuteFromStr ص";
        }

        if (toTime.period == DayPeriod.pm) to = "$hoursToAS12:$minuteToStr م";

        if (toTime.period == DayPeriod.am) to = "$hoursToAS12:$minuteToStr ص";

        return "$from - $to";
      }
    }
    return "";
  }

  static String padHijriDate(String? date) {
    if (date != null && date.isNotEmpty) {
      String d = mapARNumbersToENNumbers(date ?? "");

      List<String> data = d.split("/");
      return "${data[0]}/${data[1].padLeft(2, "0")}/${data[2].padLeft(2, "0")}";
    }
    return "";
  }

  static String getFormattedTime(String? timeStr,
      {Duration? subtractedDuration}) {
    String formattedTime = "";
    try {
      String biddingEndingTime = timeStr ?? "";
      DateTime tempTime = DateFormat("hh:mm").parse(biddingEndingTime);
      String time = DateFormat("h:mm a", isAppAR ? 'ar_SA' : 'en_US')
          .format(tempTime)
          .toString();
      if (isAppAR) {
        time = time.replaceAll("ص", ("am").tr()).replaceAll("م", ("pm").tr());
      }
      formattedTime = time;
    } catch (ex) {}
    return replaceArabicNumberWithEnglish(formattedTime);
  }

  static String getFormattedDate(String? dateStr) {
    String formattedDate = "";
    try {
      String bidEndDate = dateStr ?? "";
      DateTime tempDate = DateFormat("yyyy/MM/dd").parse(bidEndDate);
      formattedDate = DateFormat.yMMMMd(isAppAR ? 'ar_SA' : 'en_US')
          .format(tempDate)
          .toString();
    } catch (e) {}
    return replaceArabicNumberWithEnglish(formattedDate);
  }

  static void launchMap(LatLng? location) async {
    if (location != null) {
      final url =
          'https://www.google.com/maps/search/?api=1&query=${location.latitude},${location.longitude}';
      await CommonFunctions.externalLaunch(url);
    }
  }

  static externalLaunch(String? url) async {
    if (url == null) return;
    final Uri convertUrl = Uri.parse(url);
    if (!await launchUrl(convertUrl, mode: LaunchMode.externalApplication))
      throw 'Could not launch $convertUrl';
  }

  static openBaldyWithRefreshCookie(String? redirectUrl) async {
    if (redirectUrl == null) return;
    EasyLoading.show();
    GetCookie getCookie = GetCookie(repository: sl());
    final failureOrSuccessForCookie = await getCookie(NoParams());
    EasyLoading.dismiss();
    failureOrSuccessForCookie.fold((l) {
      CommonFunctions.showError("server_error_1".tr());
    }, (r) async {
      NavigationService.navigatorKey.currentState?.pushNamed(
        RouteName.inappWebview,
        arguments: (
          requestNum: 'request'.tr(),
          url: redirectUrl,
          isObjections: false
        ),
      );
    });
  }

  static String getCarPlateEnlgishLetters(String value) {
    var newStr = "";

    for (int i = 0; i < value.length; i++) {
      newStr += carPlateLetters[value[i]] ?? value[i];
    }

    return newStr.isEmpty ? value : newStr;
  }

  static String getCarPlateArabicLetters(String value) {
    var newStr = "";

    for (int i = 0; i < value.length; i++) {
      newStr += carEnPlateLetters[value[i]] ?? value[i];
    }

    return newStr.isEmpty ? value : newStr;
  }

  static sendEvent({DioError? dioError, Response? response, Exception? ex}) {
    try {
      SentryRequest request = SentryRequest(
        url: dioError?.requestOptions.path ?? response?.realUri.path,
        data: dioError?.requestOptions.data ?? response?.requestOptions.data,
        method:
            dioError?.requestOptions.method ?? response?.requestOptions.method,
        queryString: dioError?.requestOptions.queryParameters.toString() ??
            response?.requestOptions.queryParameters.toString(),
        headers: dioError?.requestOptions.headers.cast() ??
            response?.requestOptions.headers.cast(),
      );
      SentryMessage sentryMessage = SentryMessage(
        dioError?.response?.data.toString() ?? response?.data.toString() ?? "",
      );

      SentryUser sentryUser = SentryUser(
          id: CommonProperties.userInfo?.idNo,
          name: CommonProperties.userInfo?.arName,
          email: "");

      SentryEvent event = SentryEvent(
          user: sentryUser,
          request: request,
          message: sentryMessage,
          transaction:
              (dioError?.requestOptions.path ?? response?.realUri.path) ??
                  ex.toString(),
          environment: sl<EnvType>().name,
          exceptions: [
            SentryException(
                type: ex != null ? "Exception" : "APIError",
                value: ex.toString())
          ]);
      Sentry.captureEvent(event, withScope: (p) {
        //  p.addAttachment(attachment)
      });
    } catch (ex) {}
  }

  static sendUrbiMapLogs() async {
    try {
      final List<File> dGisFiles = [];

      var dir = await getExternalStorageDirectory();
      if (dir != null) {
        await for (var entity
            in dir.list(recursive: true, followLinks: false)) {
          if (entity is File && entity.path.contains("DGis")) {
            dGisFiles.add(entity);
          }
        }
      }

      for (int i = 0; i < dGisFiles.length; i++) {
        SentryUser sentryUser = SentryUser(
            id: CommonProperties.userInfo?.idNo,
            name: CommonProperties.userInfo?.arName,
            email: "");

        SentryEvent event = SentryEvent(
          user: sentryUser,
          transaction: "Map Logs",
          environment: sl<EnvType>().name,
        );

        Sentry.captureEvent(
          event,
          withScope: (p0) {
            p0.addAttachment(SentryAttachment.fromUint8List(
                dGisFiles[i].readAsBytesSync(), dGisFiles[i].path ?? ""));
          },
        ).then((value) {});
      }
    } catch (ex) {}
  }

  static void showApigeeFile(String fileUrl, String fileName) async {
    print(fileName);
    try {
      if (fileName.toLowerCase().contains(".png") ||
          fileName.toLowerCase().contains(".jpeg") ||
          fileName.toLowerCase().contains(".jpg")) {
        //MM
        print("HEETT");
        NavigationService.navigatorKey.currentState!
            .pushNamed(RouteName.apigeeImageFullScreen, arguments: fileUrl);
      } else {
        try {
          EasyLoading.show();
          File fileDownloaded = await createFileOfPdfUrl(fileUrl, fileName);
          EasyLoading.dismiss();

          /*  if (fileName.toLowerCase().contains(".pdf")) {
            Uint8List bytes = fileDownloaded.readAsBytesSync();

            Navigator.push(
                NavigationService.navigatorKey.currentContext!,
                MaterialPageRoute(
                    builder: (context) => PDFViewer(
                          file: bytes,
                          title: fileName,
                        )));
          } else {*/
          OpenFile.open(fileDownloaded.path);
          //  }
        } catch (ex) {
          EasyLoading.dismiss();

          print(ex);
        }
      }
    } catch (ex) {
      EasyLoading.dismiss();
    }
  }

  static Future<File> createFileOfPdfUrl(
      String fileUrl, String fileName) async {
    final url = fileUrl;
    Dio dio = Dio();
    dio.options.baseUrl = RemoteConfig.apigeeURL;
    dio.options.connectTimeout = const Duration(milliseconds: 60000);

    dio.options.receiveTimeout = const Duration(milliseconds: 60000);

    dio.options.sendTimeout = const Duration(milliseconds: 60000);
    dio.addSentry();

    dio.options.responseType = ResponseType.bytes;
    dio.interceptors.add(AppInterceptors());
    ;
    Response r = await WebService(dio: dio).dio.getUri(Uri.parse(url));
    String extension =
        r.headers["Content-Type"].toString().split("/")[1].replaceAll("]", "");
    print(r.headers["Content-Type"]);
    String dir = (await getTemporaryDirectory()).path;
    File file = new File('$dir/$fileName.$extension');
    await file.writeAsBytes(r.data);
    return file;
  }

  static void openSnapAndSend() async {
    await BottomSheetDialog.showDraggableSheet(
        NavigationService.navigatorKey.currentContext!,
        dialogKeyName: DialogName.vdTypesDialog,
        currentRouteName: "HomePage",
        child: BottomSheetWithActions(
          title: "choose_incident_type".tr(),
          body: VDAllTypesDialog(),
        ));
  }
}

class CommonProperties {
  static String appName = "Balady";
  static String? clientIP;
  static String? appVersion;
  static String? deviceId;
  static String? deviceName;
  static String? deviceOs;
  static String? sessionId;
  static String? fcmToken;

  static Uuid uuidInstance = Uuid();

  //static String get token =>
  //  "eyJhbGciOiJSUzI1NiIsImtpZCI6IjhFRDBCN0UzRjNDOTFBOEQwMUU3MEMxRUM4MTNGQTJBRjgxOEQ5MUZSUzI1NiIsIng1dCI6Imp0QzM0X1BKR28wQjV3d2V5QlA2S3ZnWTJSOCIsInR5cCI6ImF0K2p3dCJ9.eyJpc3MiOiJodHRwczovL3Nzb2FwcGRldi5tb21yYS5nb3Yuc2EiLCJuYmYiOjE2OTEzMTQxMTEsImlhdCI6MTY5MTMxNDExMSwiZXhwIjoxNjkyNTIzNzExLCJhdWQiOlsiRW1wbG95ZWVBZG1pbnN0cmF0aW9uLkFwaSIsImh0dHBzOi8vc3NvYXBwZGV2Lm1vbXJhLmdvdi5zYS9yZXNvdXJjZXMiXSwic2NvcGUiOlsib3BlbmlkIiwicHJvZmlsZSIsIkVtcGxveWVlQWRtaW5zdHJhdGlvbi5BcGkiLCJvZmZsaW5lX2FjY2VzcyJdLCJhbXIiOlsicHdkIl0sImNsaWVudF9pZCI6ImJhbGFkeV9tb2JpbGVfYXBwIiwic3ViIjoiN2MzNjY3NzgtYTAyMS00NzA3LTgyNDMtN2MzZGY1OWM3ZmY4IiwiYXV0aF90aW1lIjoxNjkxMzE0MTEwLCJpZHAiOiJsb2NhbCIsImVtYWlsIjoibS5haG1lZEBpbm5vc29mdC5tZXh4IiwicGhvbmVfbnVtYmVyIjoiNTkyODQyMjc1IiwibmFtZSI6IjIxMTE2OTI1OTIiLCJtYWlsIjoibS5haG1lZEBpbm5vc29mdC5tZXh4Iiwic2V4IjoiMSIsImRvYiI6IjMxLzA1LzE5OTUiLCJwaG9uZSI6IjA1OTI4NDIyNzUiLCJhcl9uYW1lIjoi2YXYrdmF2YjYryDZhdit2YXYr9io2YfYp9ih2KfZhNiv2YrZhiAg2KfYrdmF2K8iLCJlbl9uYW1lIjoiTUFITU9VRCBNT0hBTUVEQkFIQUVMREkgIEFITUVEIiwiaWRfbm8iOiIyMTExNjkyNTkyIiwibmlkIjoiMjA3IiwibmF0aW9uYWxpdHkiOiLZhdi12LEiLCJpZF90eXBlIjoiMiIsInNuYW1lIjoi2YXYrdmF2YjYryzZhdit2YXYr9io2YfYp9ih2KfZhNiv2YrZhiws2KfYrdmF2K8iLCJzaWQiOiI2REM4OEI1MDQ4NTRFNjE0Q0FFQUVENjJFODM4QTczRSIsImp0aSI6IjMxMDM4MjkxNEI1NzVDOUNFMzE5OUFBQUM1RjIwRjlFIn0.nQsrmyFoDuI9Qj1eRfAUAuqDIgvKIyZWRFanZChXQV0f-YZuMOlnYGRffegL0BhTSM2sRup57OicRhBQsEtAZHxaDmvjYp4cF0JSFTnIz5DWW5ZnCaoCVL-Jzzyyy5GC55oLiXrgrlWS_O0Y2SA-mkdzgGz-nTBjdiqYoY6BO7SWUiZb8RJLf7KJZEWALsqspEo1F836dvnCOPmKBT8Vr3iDxD5cbEL-u2R9Xt4VMXAO9B7ziXcW21kd6Si6mNPOSe29ga0HE4E5gRNMBUWQ3nLHfKrmNI0OYMdGGhclzEu8p1qaKJAIOPBbF6tuBXova0DpdjwZloM5ebSLF1FTBA";
  ///static bool get isLoggedIn => true;

  static String get token => sl<EntryPointCubit>().state.token?.token ?? "";
  static String get appCookie =>
      sl<EntryPointCubit>().state.token?.appCookie ?? "";

  static SsoUserInfo? get userInfo => sl<EntryPointCubit>().state.userInfo;
  static DelegatorEntity? get selectedDelegator =>
      sl<EntryPointCubit>().state.selectedDelegator;

  static AgentEntity? get selectedAgent =>
      sl<EntryPointCubit>().state.selectedAgent;

  static UserProfileEntity? getCurrentUserProfile() {
    if (selectedDelegator != null) {
      return UserProfileEntity(
          id: selectedDelegator?.crNumber,
          type: selectedDelegator?.crType,
          profileType: UserProfileType.Delegator,
          roleId: selectedDelegator?.roleId,
          roleName: selectedDelegator?.roleName,
          name: selectedDelegator?.entityName);
    } else if (selectedAgent != null) {
      return UserProfileEntity(
          id: selectedAgent?.requestId,
          type: selectedAgent?.grantorTypeId,
          profileType: UserProfileType.Agent,
          agencyRequestKey: selectedAgent?.requestId,
          roleName: selectedAgent?.agencyTypeName,
          name: selectedAgent?.grantorName);
    }
    return null;
  }

  static bool get isLoggedIn => sl<EntryPointCubit>().state.token != null;
  static GISParams? get userLocation => sl<LocationCubit>().state.gisParams;
  static GISResponse? get userLocationGIS =>
      sl<LocationCubit>().state.gisResponse;

  //static SsoUserInfo? userInfo = sl<EntryPointCubit>().state.userInfo;

  //static String token =
  //  "eyJhbGciOiJSUzI1NiIsImtpZCI6IjhFRDBCN0UzRjNDOTFBOEQwMUU3MEMxRUM4MTNGQTJBRjgxOEQ5MUZSUzI1NiIsIng1dCI6Imp0QzM0X1BKR28wQjV3d2V5QlA2S3ZnWTJSOCIsInR5cCI6ImF0K2p3dCJ9.eyJpc3MiOiJodHRwczovL3Nzb2FwcGRldi5tb21yYS5nb3Yuc2EiLCJuYmYiOjE2ODcwNjI0OTMsImlhdCI6MTY4NzA2MjQ5MywiZXhwIjoxNjg4MjcyMDkzLCJhdWQiOlsiRW1wbG95ZWVBZG1pbnN0cmF0aW9uLkFwaSIsImh0dHBzOi8vc3NvYXBwZGV2Lm1vbXJhLmdvdi5zYS9yZXNvdXJjZXMiXSwic2NvcGUiOlsib3BlbmlkIiwicHJvZmlsZSIsIkVtcGxveWVlQWRtaW5zdHJhdGlvbi5BcGkiLCJvZmZsaW5lX2FjY2VzcyJdLCJhbXIiOlsicHdkIl0sImNsaWVudF9pZCI6ImJhbGFkeV9tb2JpbGVfYXBwIiwic3ViIjoiMWVjZDY2NTYtMzlhMC00YmFkLTg2OWQtNjIxZGFmNWY4YmYyIiwiYXV0aF90aW1lIjoxNjg3MDYyNDkyLCJpZHAiOiJsb2NhbCIsInJvbGUiOlsiUm9sZV9MaWNlbnNlQWdlbmN5IiwiSW5zdGl0dXRlcyIsIkJhbGFkeV9BZG1pbl9Nb2JpbGUiLCJCYWxhZHlfT3RoZXIiLCJMaWNlbnNlU3RhbmRhcmRBY3Rpdml0eUFkbWluIiwiQ0FOX1NLSVBfQ09PS0lFX1ZBTElEQVRPUiIsIkxpY2Vuc2VTdGFuZGFyZEFjdGl2aXR5RGF0YUVudHJ5Il0sImVtYWlsIjoic3Vwcml5YS5qb25uYWR1bEBpbm92YXIuY29tIiwicGhvbmVfbnVtYmVyIjoiNTU3NjA5NzIyIiwibmFtZSI6IjEwMDU4MzAwODYiLCJ0aWQiOiIyMTMiLCJ0bm0iOiLYo9mF2KfZhtipINin2YTZhdiv2YrZhtipINin2YTZhdmG2YjYsdipIiwibWFpbCI6InN1cHJpeWEuam9ubmFkdWxAaW5vdmFyLmNvbSIsInNleCI6IjEiLCJkb2IiOiIwNy8wOC8xOTc2IiwicGhvbmUiOiIwNTU3NjA5NzIyIiwiYXJfbmFtZSI6Iti52KjYr9in2YTZhNmHINi02KfZgdmKINi52YLZitmEINin2YTYudmG2LLZiiIsImVuX25hbWUiOiJBQkRVTExBSCBTSEFGSSBBIEFMQU5BWkkiLCJpZF9ubyI6IjEwMDU4MzAwODYiLCJuaWQiOiIxMTMiLCJuYXRpb25hbGl0eSI6Itiz2LnZiNiv2YoiLCJpZF90eXBlIjoiMSIsInNuYW1lIjoi2LnYqNiv2KfZhNmE2Ycs2LTYp9mB2Yos2LnZgtmK2YQs2KfZhNi52YbYstmKIiwidGVuYW50cyI6Ilt7XCJUZW5hbnROYW1lXCI6XCLYp9mE2YbYt9in2YIg2KfZhNij2YjZhFwiLFwiVGVuYW50SWRcIjo2NDksXCJUZW5hbnRUeXBlXCI6XCJ0ZW5hbnRcIixcIkdvdklkXCI6bnVsbCxcIklzRGVmYXVsdFRlbmFudFwiOmZhbHNlfSx7XCJUZW5hbnROYW1lXCI6XCLYqNmE2K_ZitipINin2YTYtNix2KfYpti5INin2YTZgdix2LnZitipXCIsXCJUZW5hbnRJZFwiOjE3OSxcIlRlbmFudFR5cGVcIjpcInRlbmFudFwiLFwiR292SWRcIjpudWxsLFwiSXNEZWZhdWx0VGVuYW50XCI6ZmFsc2V9LHtcIlRlbmFudE5hbWVcIjpcItio2YTYr9mK2Kkg2KfZhNi52YXYsdipINin2YTZgdix2LnZitipXCIsXCJUZW5hbnRJZFwiOjE4MCxcIlRlbmFudFR5cGVcIjpcInRlbmFudFwiLFwiR292SWRcIjpudWxsLFwiSXNEZWZhdWx0VGVuYW50XCI6ZmFsc2V9LHtcIlRlbmFudE5hbWVcIjpcItio2YTYr9mK2Kkg2KfZhNi02YjZgtmK2Kkg2KfZhNmB2LHYudmK2KlcIixcIlRlbmFudElkXCI6MTg3LFwiVGVuYW50VHlwZVwiOlwidGVuYW50XCIsXCJHb3ZJZFwiOm51bGwsXCJJc0RlZmF1bHRUZW5hbnRcIjpmYWxzZX0se1wiVGVuYW50TmFtZVwiOlwi2KXYr9in2LHYqSDYp9mE2YXYtNin2LHZiti5INin2YTZg9io2LHZiSDZiNin2YTYrdmD2YjZhdmK2KlcIixcIlRlbmFudElkXCI6NjQ3LFwiVGVuYW50VHlwZVwiOlwidGVuYW50XCIsXCJHb3ZJZFwiOm51bGwsXCJJc0RlZmF1bHRUZW5hbnRcIjpmYWxzZX0se1wiVGVuYW50TmFtZVwiOlwi2KXYr9in2LHYqSDYp9mE2YXYtNin2LHZiti5INin2YTYqtis2KfYsdmK2Kkg2YjYp9mE2KfYs9iq2KvZhdin2LHZitipXCIsXCJUZW5hbnRJZFwiOjY0OCxcIlRlbmFudFR5cGVcIjpcInRlbmFudFwiLFwiR292SWRcIjpudWxsLFwiSXNEZWZhdWx0VGVuYW50XCI6ZmFsc2V9LHtcIlRlbmFudE5hbWVcIjpcItin2YTZhti32KfZgiDYp9mE2KvYp9mG2YpcIixcIlRlbmFudElkXCI6NjUwLFwiVGVuYW50VHlwZVwiOlwidGVuYW50XCIsXCJHb3ZJZFwiOm51bGwsXCJJc0RlZmF1bHRUZW5hbnRcIjpmYWxzZX0se1wiVGVuYW50TmFtZVwiOlwi2KfZhNmG2LfYp9mCINin2YTYq9in2YTYq1wiLFwiVGVuYW50SWRcIjo2NTEsXCJUZW5hbnRUeXBlXCI6XCJ0ZW5hbnRcIixcIkdvdklkXCI6bnVsbCxcIklzRGVmYXVsdFRlbmFudFwiOmZhbHNlfSx7XCJUZW5hbnROYW1lXCI6XCLZiNiy2KfYsdipINin2YTYtNim2YjZhiDYp9mE2KjZhNiv2YrYqSDZiNin2YTZgtix2YjZitipINmI2KfZhNin2LPZg9in2YZcIixcIlRlbmFudElkXCI6MTIxMixcIlRlbmFudFR5cGVcIjpcInRlbmFudFwiLFwiR292SWRcIjpudWxsLFwiSXNEZWZhdWx0VGVuYW50XCI6ZmFsc2V9LHtcIlRlbmFudE5hbWVcIjpcItij2YXYp9mG2Kkg2KfZhNmF2K_ZitmG2Kkg2KfZhNmF2YbZiNix2KlcIixcIlRlbmFudElkXCI6MjEzLFwiVGVuYW50VHlwZVwiOlwidGVuYW50XCIsXCJHb3ZJZFwiOm51bGwsXCJJc0RlZmF1bHRUZW5hbnRcIjp0cnVlfSx7XCJUZW5hbnROYW1lXCI6XCLYqNmE2K_ZitipINi62LHYqCDYudix2LnYsVwiLFwiVGVuYW50SWRcIjo1NTUsXCJUZW5hbnRUeXBlXCI6bnVsbCxcIkdvdklkXCI6bnVsbCxcIklzRGVmYXVsdFRlbmFudFwiOmZhbHNlfV0iLCJibWFpbCI6IiIsInNpZCI6IjQ2MkFENTM1Njc0NjREMzM0RkE0MkRENzBBMDhFQUJBIiwianRpIjoiRjQ3Mjc2Q0RCMTREREFGRUI5Rjc0RjAxQ0M3NkM2QzAifQ.OaiWru1BmWD_SbYYRNsmH7SWavSRrckOoMpBfVExBvUHWWgIh4vsUYPC2Xupw2z6F0s7Tuo2te27GVloPaVAQBJpMwZNYiu-rbPbEJ7x_EclxBXsXqIzL55ygqr8E0f332BDX6BDaNMDo_yt5oHfHE38FjHYP7E5tan0KA75bW9JI1psus9E2POoDKVea1MR3w_XNagHZsCyOY7QTJDrC9WFv3cRRTWDpHns9sxcliq7jgz28jeJnQ4Yv5wdgvKL5yUiPkVYzaVlCf5WTdt7N2xZckzR5a3PJ7ogmsosT19ZyQKlXhqAeZd1AEXUZCW4FNNGXdacfb1h6uocN92YnQ";
  static LatLng defaultLocation =
      const LatLng(24.76836756001484, 46.720988751704304);
}

/*const _fakeUser = SsoUserInfo(
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
);*/
