import 'dart:async';
import 'dart:convert' show base64, base64Decode, base64Encode, jsonDecode, utf8;
import 'dart:io' show File, Platform;
import 'dart:math' show asin, cos, sqrt;
import 'dart:typed_data' show Uint8List;

import 'package:balady_authorization/src/authentication/bloc/authentication_bloc.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/constants/remote_config.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/need_login_dialog.dart';
import 'package:balady_plus/app/features/delegators/domain/entities/agent_entity.dart';
import 'package:balady_plus/app/features/delegators/domain/entities/delegator_entity.dart';
import 'package:balady_plus/app/features/delegators/presentation/delegators_cubit/delegators_cubit.dart';
import 'package:balady_plus/app/features/location/domain/entities/gis/gis_params.dart';
import 'package:balady_plus/app/features/location/domain/entities/gis/gis_response.dart';
import 'package:balady_plus/app/features/location/presentation/bloc/location_bloc.dart';
import 'package:balady_plus/app/features/notifications/data/model/notification_request.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/presentation/cubit/new_mini_app_logic_cubit.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/mini_apps_list_pages.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:crypto/crypto.dart';
import 'package:dgis_map/library.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart' show PlatformFile;
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show EventTransformer;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hms_gms_availability/flutter_hms_gms_availability.dart';
import 'package:geolocator/geolocator.dart' as geo_locator;
import 'package:hijri/hijri_calendar.dart';
import 'package:http/http.dart' as http;
import 'package:huawei_location/huawei_location.dart' as hms;
import 'package:intl/intl.dart' show DateFormat;
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mapness/export/mapness_functions.dart';
import 'package:mime/mime.dart' as mime;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart' show getExternalStorageDirectory, getTemporaryDirectory;
import 'package:permission_handler/permission_handler.dart';
import 'package:sentry_dio/sentry_dio.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stream_transform/stream_transform.dart' show RateLimit, Switch;
import 'package:url_launcher/url_launcher.dart' show LaunchMode, launchUrl;
import 'package:uuid/uuid.dart';

import '../../app.dart';
import '../../features/_shared_feature_/data/entities/device_details.dart';
import '../../features/_shared_feature_/data/entities/file_data_item.dart';
import '../../features/_shared_feature_/data/entities/package_details.dart';
import '../../features/_shared_feature_/presentation/dialogs/camera_permission_dialog.dart';
import '../../features/_shared_feature_/presentation/dialogs/location_backgorund_consent.dart';
import '../../features/_shared_feature_/presentation/dialogs/location_permission_dialog.dart';
import '../../features/_shared_feature_/presentation/dialogs/location_service_dialog.dart';
import '../../features/_shared_feature_/presentation/dialogs/upload_file_dialog.dart';
import '../../features/_shared_feature_/presentation/widgets/custom_popups_widgets.dart';
import '../../features/_shared_feature_/shared_feature_exports.dart'
    show AuthData, BottomSheetDialog, BottomSheetWithActions, BridgeParams, BuildingRequirementsDialog, FileInfo;
import '../../features/entry_point/domain/entities/sso_user_info.dart' show SsoUserInfo;
import '../../features/entry_point/domain/entities/sso_user_info.dart';
import '../../features/entry_point/domain/use_cases/get_cookie.dart';
import '../../features/entry_point/presentation/cubit/auth_cubit.dart';
import '../../features/notifications/manager/notification_manager.dart';
import '../dependency_injection/dependency_injection_exports.dart' show sl;
import './utils_exports.dart' show AppColor, AppLanguage, EnvType, GeneralKey, MimeType, RouteName, UIHelper, WithDelay;
import 'constants/analytics_events.dart';
import 'constants/dialog_names.dart';

FirebaseAnalytics fbAnalytics = FirebaseAnalytics.instance;

var carPlateLettersList = ["أ", "ب", "ح", "د", "ر", "س", "ص", "ط", "ع", "ق", "ك", "ل", "م", "ن", "هـ", "و", "ي"];

var carPlateLettersListEn = ["A", "B", "J", "D", "R", "S", "X", "T", "E", "G", "K", "L", "Z", "N", "H", "U", "V"];

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
  static void updateNotificationSettings(String fcm) async {
    NotificationManager manager = sl();

    DeviceDetails details = sl();
    Device device = Device();
    device.typeId = GeneralKey.typeId;
    device.id = details.deviceId;
    device.osTypeId = details.deviceOs;

    PackageDetails info = sl();
    NotificationRequest request = NotificationRequest();
    request.fcmToken = fcm;
    request.FCMTokenSource = await isHuaweiDevice() ? "HUAWEI" : "FIREBASE";
    request.appId = GeneralKey.appId;
    request.device = device;
    request.appVersion = info.version;
    manager.updateNotificationSettings(request);
  }

  String? guessMimeTypeFromBase64(String base64String) {
    // Compute the minimum length of the base64 string we need to decode
    // [mime.defaultMagicNumbersMaxLength] bytes.  base64 encodes 3 bytes of
    // binary data to 4 characters.
    var minimumBase64Length = (mime.defaultMagicNumbersMaxLength / 3).ceil() * 4;
    return mime.lookupMimeType('', headerBytes: base64.decode(base64String.substring(0, minimumBase64Length)));
  }

  static EventTransformer<Event> debounce<Event>([Duration? duration]) =>
      (events, mapper) => events.debounce(duration ?? UIHelper.duration).switchMap(mapper);

  static void signOut() {
    final params = sl<BridgeParams>().copyWith(isAuthenticated: false);

    final entryPointBridge = sl<EntryPointBridge>();
    entryPointBridge(params);
  }

  //! Come here please
  static void openVolunteerProfileScreen() {
    NavigationService.navigatorKey.currentState!.pushNamed(RouteName.VolunteerProfile);
    /*
  NavigationService.navigatorKey.currentState!.push(
                        MaterialPageRoute(
                          builder: (_) => NotificationsSettings(
                            notificationsList:
                                cubit.notificationsSettingsList.categories!,
                          ),
                        ),
                      );
    */
  }

  static Future<bool> isHuaweiDevice() async {
    return await FlutterHmsGmsAvailability.isHmsAvailable;
  }

  static final locationService = hms.FusedLocationProviderClient();

  static Future<bool> isGmsAvailable() async {
    return await FlutterHmsGmsAvailability.isGmsAvailable;
  }

  static Stream<hms.Location>? listenToHMSStream() {
    return locationService.onLocationData;
  }

  static Future<geo_locator.Position?> getLastLocationHuawei() async {
    await locationService.initFusedLocationService();
    final location = await locationService.getLastLocation();
    if (location.latitude != null && location.longitude != null) {
      return geo_locator.Position(
        longitude: location.longitude!,
        latitude: location.latitude!,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: location.altitude ?? 0,
        altitudeAccuracy: 0,
        heading: location.bearing ?? 0,
        headingAccuracy: location.bearingAccuracyDegrees ?? 0,
        speed: location.speed ?? 0,
        speedAccuracy: location.speedAccuracyMetersPerSecond ?? 0,
      );
    }

    return null;
  }

  static Future<LatLng?> getCurrentLocationHuawei() async {
    try {
      await locationService.initFusedLocationService();
      final request = hms.LocationRequest();
      request.priority = hms.LocationRequest.PRIORITY_HIGH_ACCURACY;
      request.interval = 13000;

      final settings = hms.LocationSettingsRequest(requests: [request], needBle: true, alwaysShow: true);
      try {
        await locationService.checkLocationSettings(settings);
      } catch (e) {
        debugPrint('catch ${e.toString()}');
      }

      final location = await locationService.getLastLocation();

      if (location.latitude != null && location.longitude != null) {
        return LatLng(latitude: location.latitude!, longitude: location.longitude!);
      } else {
        await locationService.requestLocationUpdates(request);
      }
    } catch (error, stackTrace) {
      return handelLocationCatch(true, error, stackTrace);
    }
    return null;
  }

  static void openMiniApp({required String serviceKey, String? path}) {
    sl<NewMiniAppLogicCubit>().openMiniAppByServiceKey(serviceKey: serviceKey, path: path);
  }

  static void openMiniAppGroupId({required String groupId}) {
    servicesNavigatorKey.currentState?.pushNamed('/group', arguments: {'groupId': groupId});
  }

  static Future<LatLng?> handelLocationCatch(bool isHuawei, error, stackTrace) async {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
    try {
      if (isHuawei) {
        final position = await locationService.getLastLocation();
        if (position.latitude != null && position.longitude != null) {
          return LatLng(latitude: position.latitude!, longitude: position.longitude!);
        }
      } else {
        geo_locator.Position? position;
        position = await geo_locator.Geolocator.getLastKnownPosition();
        if (position?.latitude != null && position?.longitude != null) {
          return LatLng(latitude: position!.latitude, longitude: position.longitude);
        }
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
    return null;
  }

  static String fileMimeType(String extension) {
    extension = extension.toLowerCase();
    return MimeType.values.byName(extension).mime;
  }

  static Uint8List dataFromBase64String(String base64String) => Uri.parse(base64String).data!.contentAsBytes();

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
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
  }

  static Future<String> fileToBase64(String filePath, {String? mimeType}) async {
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
    return dateStr != null ? DateFormat('dd-MM-yyyy').format(dateStr.add(duration ?? const Duration())) : '';
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

  static Future<void> createOpenTempFile(String fileName, String content) async {
    // create Temporary File
    final tempDir = await getTemporaryDirectory();
    final tempDocumentPath = '${tempDir.path}/$fileName';
    final file = await File(tempDocumentPath).create(recursive: true);
    Uint8List bytes = base64Decode(content);
    file.writeAsBytesSync(bytes);

    // Open File From file path
    OpenFilex.open(tempDocumentPath);
  }

  static Future<void> createOpenTempBytesFile(String fileName, Uint8List bytes) async {
    // create Temporary File
    final tempDir = await getTemporaryDirectory();
    final tempDocumentPath = '${tempDir.path}/$fileName';
    final file = await File(tempDocumentPath).create(recursive: true);
    file.writeAsBytesSync(bytes);

    // Open File From file path
    OpenFilex.open(tempDocumentPath);
  }

  static Future<void> openFile(File file) async {
    final url = file.path;

    await OpenFilex.open(url);
  }

  static String getDayName(String? dateStr) {
    String dayName = "";
    try {
      String bidEndDate = dateStr ?? "";
      DateTime tempDate = DateFormat("dd-MM-yyyy").parse(bidEndDate);
      dayName = DateFormat('EEEE', CommonFunctions.isAppAR ? 'ar_SA' : 'en_US').format(tempDate).toString();
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
    return dayName;
  }

  static String getDate(String? dateStr) {
    String formattedDate = "";
    try {
      String bidEndDate = dateStr ?? "";
      DateTime tempDate = DateFormat("dd-MM-yyyy").parse(bidEndDate);
      formattedDate = DateFormat('dd', CommonFunctions.isAppAR ? 'ar_SA' : 'en_US').format(tempDate).toString();
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
    return replaceArabicNumberWithEnglish(formattedDate);
  }

  static String getDateNoDash(String? dateStr) {
    String year = dateStr?.substring(0, 4) ?? "";
    String month = dateStr?.substring(4, 6) ?? "";
    String day = dateStr?.substring(6, 8) ?? "";

    return "$year/$month/$day";
  }

  static String getMonthName(String? dateStr) {
    String monthName = "";
    try {
      String bidEndDate = dateStr ?? "";
      DateTime tempDate = DateFormat("dd-MM-yyyy").parse(bidEndDate);
      monthName = DateFormat('MMMM', CommonFunctions.isAppAR ? 'ar_SA' : 'en_US').format(tempDate).toString();
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
    return monthName;
  }

  static int getDifferenceBetweenDays(String? dateStr) {
    int difference = 0;
    try {
      String bidEndDate = dateStr ?? "";
      DateTime tempDate = DateFormat("yyyy/MM/dd").parse(bidEndDate);
      final date = DateTime.now();
      difference = tempDate.difference(date).inDays;
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
    return difference;
  }

  static String getFormattedTimeEkram(String? timeStr, {Duration? subtractedDuration}) {
    String formattedTime = "";
    debugPrint(timeStr.toString());
    try {
      String biddingEndingTime = timeStr ?? "";
      DateTime tempTime = DateFormat("yyyy/M/dd hh:mm").parse(biddingEndingTime);
      String time = DateFormat("h:mm a", isAppAR ? 'ar_SA' : 'en_US').format(tempTime).toString();
      formattedTime = time;
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      debugPrint(error.toString());
    }
    return replaceArabicNumberWithEnglish(formattedTime);
  }

  static String getFormattedDateEkram(String? timeStr, {Duration? subtractedDuration}) {
    String formattedTime = "";
    try {
      String biddingEndingTime = timeStr ?? "";
      DateTime tempTime = DateFormat("yyyy/M/dd H:mm").parse(biddingEndingTime);
      String time = DateFormat("yyyy/M/dd").format(tempTime).toString();
      formattedTime = time;
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      debugPrint(error.toString());
    }
    return replaceArabicNumberWithEnglish(formattedTime);
  }

  static String getFormattedDateEkramCard(String? timeStr, {Duration? subtractedDuration}) {
    String formattedTime = "";
    try {
      String biddingEndingTime = timeStr ?? "";
      DateTime tempTime = DateFormat("yyyy/m/dd H:mm:ss").parse(biddingEndingTime);
      String time = DateFormat("yyyy/M/dd").format(tempTime).toString();
      formattedTime = time;
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      debugPrint(error.toString());
    }
    return replaceArabicNumberWithEnglish(formattedTime);
  }

  static String getDistance(LatLng? location, LatLng? currentLocation) {
    String distance = "-";
    if (currentLocation != null && location != null) {
      double dis = calculateDistance(
        location.latitude,
        location.longitude,
        currentLocation.latitude,
        currentLocation.longitude,
      );

      if (dis >= 1000) {
        distance = ("distance_km").tr().replaceAll("-", (dis / 1000).toStringAsFixed(0));
      } else {
        distance = ("distance_meter").tr().replaceAll("-", (dis).toString());
      }
    }

    return distance;
  }

  static double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)) * 1000;
  }

  static Future<void> openMap(double latitude, double longitude) async {
    launchMap(LatLng(latitude: latitude, longitude: longitude));
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
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return DateTime.now().millisecondsSinceEpoch.toString();
    }
  }

  static Future<FileDataItem?> pickFile(BuildContext context, {bool imagesOnly = false, bool filesOnly = false}) async {
    final file = await BottomSheetDialog.showDraggableSheet(
      context,
      isFullHeight: false,
      height: 300,
      child: BottomSheetWithActions(
        title: imagesOnly ? ('uploadImage').tr() : ('uploadFile').tr(),
        body: UploadFileDialog(
          onConfirm: (FileDataItem file) {
            NavigationService.navigatorKey.currentState?.pop(file);
          },
          imagesOnly: imagesOnly,
          filesOnly: filesOnly,
        ),
      ),
    );

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
        child: child ?? const SizedBox(),
      ),
    );
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
      String v5UUID = CommonProperties.uuidInstance.v5(v1UUID, CommonProperties.deviceId);

      if (v5UUID.isNotEmpty) {
        return v5UUID.replaceAll("-", "");
      } else if (v1UUID.isNotEmpty) {
        return v1UUID.replaceAll("-", "");
      } else {
        return DateTime.now().millisecondsSinceEpoch.toString();
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return DateTime.now().millisecondsSinceEpoch.toString();
    }
  }

  static bool get isAuthed => sl.isRegistered<AuthData>();

  static bool get isAppAR => translator.activeLanguageCode == AppLanguage.ar.name;

  // add isMunicipality to check if the user is access municipality services
  // or life style services, make teh default value is false for life style services
  static Future<bool> onLogin({bool isMunicipality = false, String? mainPage}) async =>
      await sl<EntryPointCubit>().onLogin(isMunicipality: isMunicipality, mainPage: mainPage);

  static bool doesContainsLettrs(String str) {
    RegExp r = RegExp(r"[a-zA-Z\u0621-\u064A]");
    return r.allMatches(str).length >= 15;
  }

  static bool hasArabicCharacters(String str) {
    RegExp r = RegExp(r"[\u0621-\u064A0-9\s*]");
    return r.allMatches(str).length == str.length;
  }

  static bool hasArabicAndEnglishCharacters(String str) {
    RegExp r = RegExp(r"[\u0621-\u064A0-9a-zA-Z\s*]");
    return r.allMatches(str).length == str.length;
  }

  static bool hasArabicOrEnglishCharacters(String str) {
    RegExp r = RegExp(r"[\u0621-\u064Aa-zA-Z\s]");
    return r.allMatches(str).length == str.length;
  }

  static void changeLanguage({required String lang}) async {
    await translator.setNewLanguage(NavigationService.navigatorKey.currentContext!, newLanguage: lang);
    translator.applyChanges(NavigationService.navigatorKey.currentContext!);
    HijriCalendar.setLocal(lang);

    materialAppKey.currentState?.setState(() {});

    refreshHomePage();
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

  static bool checkForVDExpectedForINC({String? adminMunicipalityId, String? municipalityName, bool? isVDExcepted}) {
    /* if (adminMunicipalityId == "003" && municipalityName == "العلا") {
      try {
        String error = ("ola_incident_error").tr(); //MMTr;
        showError(error);
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

      return true;
    } else {*/
    if (isVDExcepted ?? false) {
      String error = ("inc_vd_excepted").tr();

      showError(error);
      return true;
    }
    // }

    return false;
  }

  static void showSuccess(String msg) {
    if (msg.isNotEmpty) {
      try {
        BotToast.showSimpleNotification(
          title: msg,
          backgroundColor: AppColor.baladyDarkGreen2,
          titleStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.normal,
            fontSize: 16.0,
          ),
          hideCloseButton: true,
          duration: const Duration(seconds: 3),
        );
      } catch (error, stackTrace) {
        LogsViewModel().sendEventFromModel(
          event: ErrorExceptionModel(
            nameEvent: EventsName.handledException,
            message: error.toString(),
            stackTrace: stackTrace.toString(),
          ),
        );
      }
    }
  }

  static Future<dynamic> openBaladyWebView(
    String? url, {
    bool isObjections = false,
    bool needLogin = true,
    List<String>? callbackUrls,
  }) async {
    if (needLogin == false) {
      return await Navigator.of(NavigationService.navigatorKey.currentContext!).pushNamed(
        RouteName.inappWebview,
        arguments: (requestNum: ''.tr(), url: url, isObjections: isObjections, callbackUrls: callbackUrls),
      );
    } else {
      if (CommonProperties.isLoggedIn) {
        EasyLoading.show();
        GetCookie getCookie = GetCookie(repository: sl());
        final failureOrSuccessForCookie = await getCookie(true);
        EasyLoading.dismiss();
        return await failureOrSuccessForCookie.fold(
          (l) {
            CommonFunctions.showError("server_error_1".tr());
            return null;
          },
          (r) async {
            return await Navigator.of(NavigationService.navigatorKey.currentContext!).pushNamed(
              RouteName.inappWebview,
              arguments: (requestNum: ''.tr(), url: url, isObjections: isObjections, callbackUrls: callbackUrls),
            );
          },
        );
      } else {
        dynamic result;
        await showDialog(
          context: NavigationService.navigatorKey.currentContext!,
          builder: (ctx) => NeedLoginDialog(
            onSuccessLogin: (bool? isSuccess) async {
              if (isSuccess ?? false) {
                result = await openBaladyWebView(
                  url,
                  isObjections: isObjections,
                  needLogin: needLogin,
                  callbackUrls: callbackUrls,
                );
              }
            },
          ),
        );
        return result;
      }
    }
  }

  static void showError(String error, [bool? isHtml]) {
    if (error.isNotEmpty) {
      if (error.contains("https") || error.toLowerCase().contains("momra.gov.sa")) {
        CustomPopUpsWidgets.showHTMLErrorMessageDialog(
          NavigationService.navigatorKey.currentContext!,
          error,
          isHtml ?? false,
        );
      } else {
        try {
          BotToast.showSimpleNotification(
            title: error,
            backgroundColor: const Color.fromARGB(255, 204, 51, 51),
            titleStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
              fontSize: 16.0,
            ),
            hideCloseButton: true,
            duration: const Duration(seconds: 3),
          );
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
      }
    }
  }

  static bool locationDialogShowed = false;

  static Future<bool> checkLocationSettings(BuildContext context) async {
    ServiceStatus serviceStatus = await Permission.location.serviceStatus;

    if (serviceStatus != ServiceStatus.disabled) {
      var status = await Permission.location.request();
      if (!context.mounted) {
        return false;
      }

      if (status == PermissionStatus.permanentlyDenied) {
        if (!locationDialogShowed) {
          locationDialogShowed = true;
          showDialog(
            context: context,
            builder: (ctx) => const LocationPermissionDialog(),
          ).then((value) => locationDialogShowed = false);
        }
        return false;
      } else if (status != PermissionStatus.granted) {
        Permission.location.request();
        return false;
      } else {
        return true;
      }
    } else {
      if (!context.mounted) {
        return false;
      }
      if (!locationDialogShowed) {
        showDialog(
          context: context,
          builder: (ctx) => const LocationServiceDialog(),
        ).then((value) => locationDialogShowed = false);
      }

      return false;
    }
  }

  static Future<bool> checkCameraSettings(BuildContext context) async {
    var status = await Permission.camera.request();
    if (!context.mounted) {
      return false;
    }
    if (status == PermissionStatus.permanentlyDenied) {
      showDialog(context: context, builder: (ctx) => const CameraPermissionDialog());
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
      int? hoursFrom = int.tryParse(time.split(":")[0]) != null ? int.parse(time.split(":")[0]) : null;
      int? minuteFrom = int.tryParse(time.split(":")[1]) != null ? int.parse(time.split(":")[1]) : null;

      TimeOfDay fromTime = TimeOfDay(hour: hoursFrom!, minute: minuteFrom!); // 3:00 PM
      int hoursFromAS12 = hoursFrom;

      if (hoursFrom == 0) hoursFromAS12 += 12;

      String minuteStr = minuteFrom < 10 ? "0$minuteFrom" : "$minuteFrom";

      if (hoursFrom >= 13 && hoursFrom <= 23) {
        hoursFromAS12 = hoursFromAS12 - 12;
      }

      if (fromTime.period == DayPeriod.pm) return "$hoursFromAS12:$minuteStr ${"pm".tr()}";

      if (fromTime.period == DayPeriod.am) {
        if (isAppAR == false) {
          return "$hoursFromAS12:$minuteStr ص".replaceAll("ص", ("am").tr()).replaceAll("م", ("pm").tr());
        } else {
          return "$hoursFromAS12:$minuteStr ص";
        }
      }
    }
    return "";
  }

  static String getFormattedTimeforQR(String? timeFrom, String? timeTo) {
    if (timeFrom != null && timeTo != null) {
      int? hoursFrom = int.tryParse(timeFrom.split(":")[0]) != null ? int.parse(timeFrom.split(":")[0]) : null;
      int? hoursTo = int.tryParse(timeTo.split(":")[0]) != null ? int.parse(timeTo.split(":")[0]) : null;

      int? minuteFrom = int.tryParse(timeFrom.split(":")[1]) != null ? int.parse(timeFrom.split(":")[1]) : null;
      int? minuteTo = int.tryParse(timeTo.split(":")[1]) != null ? int.parse(timeTo.split(":")[1]) : null;
      String minuteFromStr = minuteFrom! < 10 ? "0$minuteFrom" : "$minuteFrom";
      String minuteToStr = minuteTo! < 10 ? "0$minuteTo" : "$minuteTo";
      TimeOfDay fromTime = TimeOfDay(hour: hoursFrom!, minute: minuteFrom); // 3:00 PM
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
      } else if (fromTime.period == DayPeriod.pm && toTime.period == DayPeriod.pm) {
        time = "$hoursFromAS12:$minuteFromStr - $hoursToAS12:$minuteToStr م";

        if (isAppAR == false) {
          time = time.replaceAll("ص", ("am").tr()).replaceAll("م", ("pm").tr());
        }
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

        if (isAppAR == false) {
          from = from.replaceAll("ص", ("am").tr()).replaceAll("م", ("pm").tr());
          to = to.replaceAll("ص", ("am").tr()).replaceAll("م", ("pm").tr());
        }

        return "$from - $to";
      }
    }
    return "";
  }

  static String padHijriDate(String? date) {
    if (date != null && date.isNotEmpty) {
      String d = mapARNumbersToENNumbers(date);

      List<String> data = d.split("/");
      return "${data[0]}/${data[1].padLeft(2, "0")}/${data[2].padLeft(2, "0")}";
    }
    return "";
  }

  static String getFormattedTime(String? timeStr, {Duration? subtractedDuration}) {
    String formattedTime = "";
    try {
      String biddingEndingTime = timeStr ?? "";
      DateTime tempTime = DateFormat("hh:mm").parse(biddingEndingTime);
      String time = DateFormat("h:mm a", isAppAR ? 'ar_SA' : 'en_US').format(tempTime).toString();
      if (isAppAR) {
        time = time.replaceAll("ص", ("am").tr()).replaceAll("م", ("pm").tr());
      }
      formattedTime = time;
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
    return replaceArabicNumberWithEnglish(formattedTime);
  }

  static String getFormattedDate(String? dateStr) {
    String formattedDate = "";
    try {
      String bidEndDate = dateStr ?? "";
      DateTime tempDate = DateFormat("yyyy/MM/dd").parse(bidEndDate);
      formattedDate = DateFormat.yMMMMd(isAppAR ? 'ar_SA' : 'en_US').format(tempDate).toString();
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
    return replaceArabicNumberWithEnglish(formattedDate);
  }

  static void launchMap(LatLng? location) async {
    if (location != null) {
      // final url = 'https://www.google.com/maps/search/?api=1&query=${location.latitude},${location.longitude}';
      MapnessFunctions.openRoutesScreen(
        finishPoint: MapnessRoutePoint(latitude: location.latitude, longitude: location.longitude, label: ''),
      );
      // await CommonFunctions.externalLaunch(url);
    }
  }

  static Future<void> externalLaunch(String? url) async {
    if (url == null) return;
    final Uri convertUrl = Uri.parse(url);
    if (!await launchUrl(convertUrl, mode: LaunchMode.externalApplication)) throw 'Could not launch $convertUrl';
  }

  static Future<void> openBaldyWithRefreshCookie(String? redirectUrl, {bool pushReplacement = false}) async {
    if (redirectUrl == null) return;
    EasyLoading.show();
    GetCookie getCookie = GetCookie(repository: sl());
    final failureOrSuccessForCookie = await getCookie(true);
    EasyLoading.dismiss();
    failureOrSuccessForCookie.fold(
      (l) {
        CommonFunctions.showError("server_error_1".tr());
      },
      (r) async {
        if (!pushReplacement) {
          NavigationService.navigatorKey.currentState?.pushNamed(
            RouteName.inappWebview,
            arguments: (requestNum: 'request'.tr(), url: redirectUrl, isObjections: false),
          );
        } else {
          NavigationService.navigatorKey.currentState?.pushReplacementNamed(
            RouteName.inappWebview,
            arguments: (requestNum: 'request'.tr(), url: redirectUrl, isObjections: false),
          );
        }
      },
    );
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

  static void sendEvent({DioException? dioError, Response? response, Exception? ex, String? errorMessage}) {
    try {
      SentryRequest request = SentryRequest(
        url: dioError?.requestOptions.path ?? response?.realUri.path,
        data: dioError?.requestOptions.data ?? response?.requestOptions.data,
        method: dioError?.requestOptions.method ?? response?.requestOptions.method,
        queryString:
            dioError?.requestOptions.queryParameters.toString() ?? response?.requestOptions.queryParameters.toString(),
        headers: dioError?.requestOptions.headers.cast() ?? response?.requestOptions.headers.cast(),
      );
      String message =
          (dioError?.response?.data.toString() ?? response?.data.toString()) ?? (errorMessage ?? ex.toString());

      message = message.isEmpty ? (errorMessage ?? ex.toString()) : message;
      SentryMessage sentryMessage = SentryMessage(message);

      SentryUser sentryUser = SentryUser(
        id: CommonProperties.userInfo?.idNo,
        name: CommonProperties.userInfo?.arName,
        email: "",
      );

      SentryEvent event = SentryEvent(
        user: sentryUser,
        request: request,
        message: sentryMessage,
        transaction: (dioError?.requestOptions.path ?? response?.realUri.path) ?? ex.toString(),
        environment: sl<EnvType>().name,
        exceptions: [SentryException(type: ex != null ? "Exception" : "APIError", value: ex.toString())],
      );
      Sentry.captureEvent(
        event,
        withScope: (p) {
          //  p.addAttachment(attachment)
        },
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      debugPrint(error.toString());
    }
  }

  static Future<void> sendUrbiMapLogs() async {
    try {
      final List<File> dGisFiles = [];

      var dir = await getExternalStorageDirectory();
      if (dir != null) {
        await for (var entity in dir.list(recursive: true, followLinks: false)) {
          if (entity is File && entity.path.contains("DGis")) {
            dGisFiles.add(entity);
          }
        }
      }

      for (int i = 0; i < dGisFiles.length; i++) {
        SentryUser sentryUser = SentryUser(
          id: CommonProperties.userInfo?.idNo,
          name: CommonProperties.userInfo?.arName,
          email: "",
        );

        SentryEvent event = SentryEvent(user: sentryUser, transaction: "Map Logs", environment: sl<EnvType>().name);

        Sentry.captureEvent(
          event,
          withScope: (p0) {
            p0.addAttachment(SentryAttachment.fromUint8List(dGisFiles[i].readAsBytesSync(), dGisFiles[i].path));
          },
        ).then((value) {});
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
  }

  static void showApigeeFile(String fileUrl, String fileName, {int? serviceId}) async {
    debugPrint(fileName.toString());
    try {
      if (fileName.toLowerCase().contains(".png") ||
          fileName.toLowerCase().contains(".jpeg") ||
          fileName.toLowerCase().contains(".jpg")) {
        if (serviceId == 2) {
          NavigationService.navigatorKey.currentState!.pushNamed(RouteName.dmsImageFullScreen, arguments: fileUrl);
        } else {
          NavigationService.navigatorKey.currentState!.pushNamed(RouteName.apigeeImageFullScreen, arguments: fileUrl);
        }
      } else {
        try {
          EasyLoading.show();
          File fileDownloaded = await createFileOfPdfUrl(fileUrl, fileName, serviceId: serviceId);
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
          OpenFilex.open(fileDownloaded.path);
          //  }
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
          EasyLoading.dismiss();

          debugPrint(error.toString());
        }
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      EasyLoading.dismiss();
    }
  }

  static Future<File> createFileOfPdfUrl(String fileUrl, String fileName, {int? serviceId}) async {
    final url = fileUrl;
    Dio dio = Dio();
    dio.options.baseUrl = RemoteConfig.apigeeURL;
    dio.options.connectTimeout = const Duration(milliseconds: 60000);

    dio.options.receiveTimeout = const Duration(milliseconds: 60000);

    dio.options.sendTimeout = const Duration(milliseconds: 60000);
    dio.addSentry();
    dio.options.responseType = ResponseType.bytes;
    dio.interceptors.add(AppInterceptors());
    debugPrint("SERVCE $serviceId");

    Response r = await WebService(
      dio: dio,
    ).dio.getUri(Uri.parse(url), options: Options(headers: {"X-Service-Id": ?serviceId}));
    String extension = r.headers["Content-Type"].toString().split("/")[1].replaceAll("]", "");

    String dir = (await getTemporaryDirectory()).path;
    File file = File('$dir/$fileName.$extension');

    await file.writeAsBytes(r.data);
    return file;
  }

  static void logout() {
    sl<EntryPointCubit>().autoLogout();
  }

  static void openJodService() {
    NavigationService.navigatorKey.currentState!.pushNamed(RouteName.jodDonationPage);
  }

  static void openSnapAndSend() async {
    CommonFunctions.sendAnalyticsEvent(AnalyticsEvents.SnapAndSend_Open_From_Home_Event);

    NavigationService.navigatorKey.currentState!.pushNamed(RouteName.vDAllTypesScreen);
  }

  static void openCreateCompliance() {
    //أصدر الشهادة

    if (CommonProperties.isLoggedInMunicipality) {
      NavigationService.navigatorKey.currentState!.pushNamed(RouteName.createCompliancePage);
    } else {
      showDialog(
        context: NavigationService.navigatorKey.currentContext!,
        builder: (ctx) => NeedLoginDialog(
          onSuccessLogin: (bool? isSuccess) async {
            if (isSuccess ?? false) {
              NavigationService.navigatorKey.currentState!.pushNamed(RouteName.createCompliancePage);
            }
          },
        ),
      );
    }
  }

  static void openRatingBuilding() {
    //قيم مبناك
    NavigationService.navigatorKey.currentState!.pushNamed(RouteName.selfRatingMainPage);
  }

  static void openComplianceFaq(String serviceID) {
    //اطلع على الاسئلة الشائعة
    NavigationService.navigatorKey.currentState!.pushNamed(RouteName.QAPage, arguments: serviceID);
  }

  static void openComplianceTerms() async {
    // استعرض الاشتراطات

    await BottomSheetDialog.showDraggableSheet(
      NavigationService.navigatorKey.currentContext!,
      dialogKeyName: DialogName.buildingComplianceDialog,
      currentRouteName: "HomePage",
      child: const BuildingRequirementsDialog(),
    );
  }

  static void refreshHomePage() async {
    // Add This Line to When change lang app lade new data with the lang.

    // Trigger load only if not already loaded or in progress
    await sl<NewMiniAppLogicCubit>().loadMiniApps(forceRefresh: true);
    // sl<CalendarBloc>().add(const calendar.GetSearchEvent());
    // BlocProvider.of<DashboardBloc>(
    //         NavigationService.navigatorKey.currentContext!)
    //     .add(DashboardEventInitial());
  }

  static void sendAnalyticsEvent(String event) {
    try {
      Sentry.addBreadcrumb(Breadcrumb(message: event));
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
  }

  static Future<void> showBackGroundLocationConsent() async {
    //if (Platform.isAndroid) {
    bool? consetnt = sharedPrefs.getLocationConsent();
    if (consetnt != null) return;
    await Future.delayed(const Duration(seconds: 10));

    showDialog(
      context: NavigationService.navigatorKey.currentContext!,
      builder: (ctx) => const LocationBackgroundConsentDialog(),
    );
    //  }
  }

  static String getIssueCrWarning1() {
    if (CommonFunctions.isAppAR) {
      return '<blockquote >عزيزي المستٝيد.. يرجى اختيار النشاط المطابق للنشاط الٝعلي للمحل حيث أنه لا يمكن تعديل نشاط الرخصة بعد إصدارها</p><p >عزيزي المستٝيد... يمكنك الاستعلام عن تٝاصيل الأنشطة واشتراطاتها من خلال زيارتك للرابط التالي: <a href="https://apps.balady.gov.sa//LicenseStandard/Default" target="_blank">الأنشطة التجارية واشتراطاتها</a></p></blockquote>';
    } else {
      return '<blockquote >Dear beneficiary, please select the activity corresponding to the actual activity of the store, as the license activity cannot be modified after issuance.</p><p >Dear beneficiary, you can inquire about the details of the activities and their requirements by visiting the following link: <a href="https://apps.balady.gov.sa//LicenseStandard/Default" target="_blank"> Details </a></p></blockquote>';
    }
  }

  static String getIssueCrWarning2() {
    if (CommonFunctions.isAppAR) {
      return '<span class="ui-messages-detail ng-tns-c1-19 ng-star-inserted">عزيزي المستٝيد.. يمكنك معرٝة الوسطاء العقاريون المعتمدين ٝي شبكة ايجار من خلال الرابط <a target="_balnk" href="https://www.ejar.sa/ar/certified-offices"> اضغط هنا</a> أو تحميل تطبيق وسطاء عقاريون <a target="_balnk" href="https://apps.apple.com/us/app/%D9%88%D8%B3%D8%B7%D8%A7%D8%A1-%D8%B9%D9%82%D8%A7%D8%B1%D9%8A%D9%88%D9%86/id1306579731"> IOS </a> أو <a target="_balnk" href="https://play.google.com/store/apps/details?id=sa.ejar.waset"> Android </a></span>';
    } else {
      return '<span class="ui-messages-detail ng-tns-c1-19 ng-star-inserted">Dear beneficiary, you can find out the accredited real estate brokers in the Ejar network through the following link <a target="_balnk" href="https://www.ejar.sa/ar/certified-offices"> Click Here </a> Or download the Real Estate Brokers application<a target="_balnk" href="https://apps.apple.com/us/app/%D9%88%D8%B3%D8%B7%D8%A7%D8%A1-%D8%B9%D9%82%D8%A7%D8%B1%D9%8A%D9%88%D9%86/id1306579731"> IOS </a> Or <a target="_balnk" href="https://play.google.com/store/apps/details?id=sa.ejar.waset"> Android </a></span>';
    }
  }

  static String getIssueCrWarning3() {
    if (CommonFunctions.isAppAR) {
      return '<p class="m-0 ng-star-inserted">عزيزي المستٝيد... يمكنك الاطلاع على لائحة استيٝاء اشتراطات اللوحات التجارية من خلال زيارة الرابط التالي: <a target="_balnk" href="https://balady.gov.sa/Services/DownloadUserGuide/218">لائحة استيٝاء اشتراطات اللوحات التجارية</a></p>';
    } else {
      return '<p class="m-0 ng-star-inserted">Dear beneficiary, you can review the compliance requirements list for commercial signs by visiting the following link<a target="_balnk" href="https://balady.gov.sa/Services/DownloadUserGuide/218"> Compliance requirements list for commercial signs</a></p>';
    }
  }

  static String getDMSUrl(String id) {
    return "${RemoteConfig.apigeeURL}/v1/dms-mobile/files/$id";
  }

  // List of special dates or date ranges
  static List<DateTimeRange> get _specialDateRanges {
    final today = DateTime.now();
    return [
      // Single day - Example: National Day (September 23rd)
      DateTimeRange(start: DateTime(today.year, 9, 18), end: DateTime(today.year, 9, 27, 23, 59, 59)),

      /// Date range - Example: Festival (September 20th to September 30th)
      // DateTimeRange(
      //   start: DateTime(DateTime.now().year, 9, 20),
      //   end: DateTime(DateTime.now().year, 9, 30),
      // ),
    ];
  }

  /// Returns true if [now] (default: today) is inside any of the given ranges.
  static bool get isTodayInRanges {
    final today = DateTime.now();

    // Normalize `today` to midnight to ignore time of day
    final normalized = DateTime(today.year, today.month, today.day);

    for (final range in _specialDateRanges) {
      if (normalized.isAfter(range.start.subtract(const Duration(seconds: 1))) &&
          normalized.isBefore(range.end.add(const Duration(seconds: 1)))) {
        return true;
      }
    }
    return false;
  }

  static void openMovingViolations(Uri? uri) {
    // NavigationService.navigatorKey.currentState!.pushNamed(
    //     RouteName.vdCameraPage,
    //     arguments: CameraParamsPage(
    //         selectedCategory:
    //             CategoryItem(categoryId: RemoteConfig.movingVeichleCategoryKey),
    //         /*isFromHome: true*/));
  }

  static bool isFoundationDay() {
    return false;
    DateTime today = DateTime.now();

    int todayDay = today.day;
    int todayMonth = today.month;
    int todayYear = today.year;
    var allowedDays = [20, 21, 22, 23, 24, 25];
    if (allowedDays.contains(todayDay) && todayMonth == 2 && todayYear == 2024) return true;
    return false;
  }

  static String? hijriToGregorian(String? hijriDate) {
    try {
      if (hijriDate != null && hijriDate.isNotEmpty) {
        List<int> dateSplitted = CommonFunctions.replaceArabicNumberWithEnglish(
          hijriDate,
        ).split("/").map((e) => int.parse(e)).toList();
        var gDate = HijriCalendar();
        DateTime gorgianDate = gDate.hijriToGregorian(dateSplitted[0], dateSplitted[1], dateSplitted[2]);
        String? gorgian = DateFormat('yyyy/MM/dd').format(gorgianDate);

        return CommonFunctions.padHijriDate(gorgian);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /////////////
  static Future<DateTime?> fetchOnlineDateTimeForKSA() async {
    try {
      // World Time API URL for Saudi Arabia (Asia/Riyadh)
      final url = Uri.parse('http://worldtimeapi.org/api/timezone/Asia/Riyadh');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final dateTimeString = data['datetime']; // Example: "2023-12-30T18:45:32.123456+03:00"
        return DateTime.parse(dateTimeString);
      } else {
        debugPrint('Failed to fetch time: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching KSA date and time: $e');
      return null;
    }
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
  static String? currentLocalServerDirectory;

  // static String? serverRootPath;

  static bool showEkramDriver = false;

  static Uuid uuidInstance = const Uuid();
  static List<String> allowedSHAFingerprints = [
    "67:3C:D5:53:27:AF:82:86:9A:19:23:83:09:EB:4A:C9:AA:E6:71:E8:37:EA:DC:60:C3:2E:99:73:3A:BD:73:15",
    "DC:79:FD:7B:6E:64:E5:16:04:A6:05:D1:D5:A9:D9:AC:21:CB:97:88:7A:65:58:69:85:9F:29:ED:0A:6A:AB:6D",
    "4B:A6:13:C4:D7:E8:B0:C7:6A:4F:FE:B7:88:CC:28:B8:10:EC:FA:51:5B:A5:07:CD:83:CF:24:ED:1D:15:62:30",
  ];

  //static String get token =>
  //  "eyJhbGciOiJSUzI1NiIsImtpZCI6IjhFRDBCN0UzRjNDOTFBOEQwMUU3MEMxRUM4MTNGQTJBRjgxOEQ5MUZSUzI1NiIsIng1dCI6Imp0QzM0X1BKR28wQjV3d2V5QlA2S3ZnWTJSOCIsInR5cCI6ImF0K2p3dCJ9.eyJpc3MiOiJodHRwczovL3Nzb2FwcGRldi5tb21yYS5nb3Yuc2EiLCJuYmYiOjE2OTEzMTQxMTEsImlhdCI6MTY5MTMxNDExMSwiZXhwIjoxNjkyNTIzNzExLCJhdWQiOlsiRW1wbG95ZWVBZG1pbnN0cmF0aW9uLkFwaSIsImh0dHBzOi8vc3NvYXBwZGV2Lm1vbXJhLmdvdi5zYS9yZXNvdXJjZXMiXSwic2NvcGUiOlsib3BlbmlkIiwicHJvZmlsZSIsIkVtcGxveWVlQWRtaW5zdHJhdGlvbi5BcGkiLCJvZmZsaW5lX2FjY2VzcyJdLCJhbXIiOlsicHdkIl0sImNsaWVudF9pZCI6ImJhbGFkeV9tb2JpbGVfYXBwIiwic3ViIjoiN2MzNjY3NzgtYTAyMS00NzA3LTgyNDMtN2MzZGY1OWM3ZmY4IiwiYXV0aF90aW1lIjoxNjkxMzE0MTEwLCJpZHAiOiJsb2NhbCIsImVtYWlsIjoibS5haG1lZEBpbm5vc29mdC5tZXh4IiwicGhvbmVfbnVtYmVyIjoiNTkyODQyMjc1IiwibmFtZSI6IjIxMTE2OTI1OTIiLCJtYWlsIjoibS5haG1lZEBpbm5vc29mdC5tZXh4Iiwic2V4IjoiMSIsImRvYiI6IjMxLzA1LzE5OTUiLCJwaG9uZSI6IjA1OTI4NDIyNzUiLCJhcl9uYW1lIjoi2YXYrdmF2YjYryDZhdit2YXYr9io2YfYp9ih2KfZhNiv2YrZhiAg2KfYrdmF2K8iLCJlbl9uYW1lIjoiTUFITU9VRCBNT0hBTUVEQkFIQUVMREkgIEFITUVEIiwiaWRfbm8iOiIyMTExNjkyNTkyIiwibmlkIjoiMjA3IiwibmF0aW9uYWxpdHkiOiLZhdi12LEiLCJpZF90eXBlIjoiMiIsInNuYW1lIjoi2YXYrdmF2YjYryzZhdit2YXYr9io2YfYp9ih2KfZhNiv2YrZhiws2KfYrdmF2K8iLCJzaWQiOiI2REM4OEI1MDQ4NTRFNjE0Q0FFQUVENjJFODM4QTczRSIsImp0aSI6IjMxMDM4MjkxNEI1NzVDOUNFMzE5OUFBQUM1RjIwRjlFIn0.nQsrmyFoDuI9Qj1eRfAUAuqDIgvKIyZWRFanZChXQV0f-YZuMOlnYGRffegL0BhTSM2sRup57OicRhBQsEtAZHxaDmvjYp4cF0JSFTnIz5DWW5ZnCaoCVL-Jzzyyy5GC55oLiXrgrlWS_O0Y2SA-mkdzgGz-nTBjdiqYoY6BO7SWUiZb8RJLf7KJZEWALsqspEo1F836dvnCOPmKBT8Vr3iDxD5cbEL-u2R9Xt4VMXAO9B7ziXcW21kd6Si6mNPOSe29ga0HE4E5gRNMBUWQ3nLHfKrmNI0OYMdGGhclzEu8p1qaKJAIOPBbF6tuBXova0DpdjwZloM5ebSLF1FTBA";
  ///static bool get isLoggedIn => true;

  static String get token => sl<EntryPointCubit>().state.token?.token ?? "";

  // static String get token =>
  //    "eyJhbGciOiJSUzI1NiIsImtpZCI6IjhFRDBCN0UzRjNDOTFBOEQwMUU3MEMxRUM4MTNGQTJBRjgxOEQ5MUZSUzI1NiIsIng1dCI6Imp0QzM0X1BKR28wQjV3d2V5QlA2S3ZnWTJSOCIsInR5cCI6ImF0K2p3dCJ9.eyJpc3MiOiJodHRwczovL3Nzb2FwcGRldi5tb21yYS5nb3Yuc2EiLCJuYmYiOjE3MDE4NTQ4OTUsImlhdCI6MTcwMTg1NDg5NSwiZXhwIjoxNzMxODU0ODk1LCJhdWQiOiJodHRwczovL3Nzb2FwcGRldi5tb21yYS5nb3Yuc2EvcmVzb3VyY2VzIiwic2NvcGUiOlsib3BlbmlkIiwicHJvZmlsZSIsIm9mZmxpbmVfYWNjZXNzIl0sImFtciI6WyJwd2QiXSwiY2xpZW50X2lkIjoiYmFsYWR5X21vYmlsZV9hcHBfaW50ZWciLCJzdWIiOiIxZWNkNjY1Ni0zOWEwLTRiYWQtODY5ZC02MjFkYWY1ZjhiZjIiLCJhdXRoX3RpbWUiOjE3MDE4NTQ4OTQsImlkcCI6ImxvY2FsIiwidGlkIjoiNTU1IiwidG5tIjoi2KjZhNiv2YrYqSDYutix2Kgg2LnYsdi52LEiLCJuYW1lIjoiMTAwNTgzMDA4NiIsInJvbGUiOlsiUm9sZV9MaWNlbnNlQWdlbmN5IiwiSW5zdGl0dXRlcyIsIkJhbGFkeV9BZG1pbl9Nb2JpbGUiLCJCYWxhZHlfT3RoZXIiLCJMaWNlbnNlU3RhbmRhcmRBY3Rpdml0eUFkbWluIiwiQ0FOX1NLSVBfQ09PS0lFX1ZBTElEQVRPUiIsIkxpY2Vuc2VTdGFuZGFyZEFjdGl2aXR5RGF0YUVudHJ5Il0sIm1haWwiOiJtYWlsQG1vbXJhaC5nb3Yuc2EiLCJzZXgiOiIxIiwiZG9iIjoiMDcvMDgvMTk3NiIsInBob25lIjoiMDU0MjAwMjE4MCIsImFyX25hbWUiOiLYudio2K_Yp9mE2YTZhyDYtNin2YHZiiDYudmC2YrZhCDYp9mE2LnZhtiy2YoiLCJlbl9uYW1lIjoiQUJEVUxMQUggU0hBRkkgQSBBTEFOQVpJIiwiaWRfbm8iOiIxMDA1ODMwMDg2IiwibmlkIjoiMTEzIiwibmF0aW9uYWxpdHkiOiLYs9i52YjYr9mKIiwiaWRfdHlwZSI6IjEiLCJzbmFtZSI6Iti52KjYr9in2YTZhNmHLNi02KfZgdmKLNi52YLZitmELNin2YTYudmG2LLZiiIsInRlbmFudHMiOiJbe1wiVGVuYW50TmFtZVwiOlwi2YjYstin2LHYqSDYp9mE2LTYptmI2YYg2KfZhNio2YTYr9mK2Kkg2YjYp9mE2YLYsdmI2YrYqSDZiNin2YTYp9iz2YPYp9mGXCIsXCJUZW5hbnRJZFwiOjEyMTIsXCJUZW5hbnRUeXBlXCI6XCJ0ZW5hbnRcIixcIkdvdklkXCI6bnVsbCxcIklzRGVmYXVsdFRlbmFudFwiOmZhbHNlfSx7XCJUZW5hbnROYW1lXCI6XCLYo9mF2KfZhtipINin2YTZhdiv2YrZhtipINin2YTZhdmG2YjYsdipXCIsXCJUZW5hbnRJZFwiOjIxMyxcIlRlbmFudFR5cGVcIjpcInRlbmFudFwiLFwiR292SWRcIjpudWxsLFwiSXNEZWZhdWx0VGVuYW50XCI6ZmFsc2V9LHtcIlRlbmFudE5hbWVcIjpcItio2YTYr9mK2Kkg2LrYsdioINi52LHYudixXCIsXCJUZW5hbnRJZFwiOjU1NSxcIlRlbmFudFR5cGVcIjpudWxsLFwiR292SWRcIjpudWxsLFwiSXNEZWZhdWx0VGVuYW50XCI6dHJ1ZX0se1wiVGVuYW50TmFtZVwiOlwi2KPZhdin2YbYqSDYp9mE2K3Yr9mI2K8g2KfZhNi02YXYp9mE2YrYqVwiLFwiVGVuYW50SWRcIjoxLFwiVGVuYW50VHlwZVwiOm51bGwsXCJHb3ZJZFwiOm51bGwsXCJJc0RlZmF1bHRUZW5hbnRcIjpmYWxzZX1dIiwiYm1haWwiOiIiLCJzaWQiOiI4OUI2MDgxMEM0MTM4OERCNTFGN0FFQ0JBQ0ZDNjA3QyIsImp0aSI6IjI5QkU3QjdBOEE2QUY1ODIwRjE4Nzk5NTFCM0I2MUIwIn0.TDtmtlfFOFEFKDjcNmyf0-d-F4fXbCSlKwmp6EZC4xs-FBkZ55pOccrQipk4_MV1CHehd7XX3oN_zv937iANQcQUDapgpgl1KHQxvrvOoMyqA47jOK2Lh8AmEQcOiORcmYqfJQ9kuo4SqPc_86Z9eYp4dzAeRMfUtCqzOz7feZ4bfgm7qS3S6XIkTFsGLkRY60bybnjzQUDirUsUo-aVnEEx-7VmqB0nhgcI3v-mMtmlWwDyjHjbQmnF5Zg5MOQJ8RTjeOvlfXGwz2tMxoTSMA2_-qzc_yUm67nxgQ9hFoGhebZ7St6kaxELVGOLaIrOsTj67D84bVpKvnTxDU-ykQ";
  static String get appCookie => sl<EntryPointCubit>().state.token?.appCookie ?? "";

  static SsoUserInfo? get userInfo => sl<EntryPointCubit>().state.userInfo;

  static DelegatorEntity? get selectedDelegator => sl<DelegatorsCubit>().state.selectedDelegate;

  static AgentEntity? get selectedAgent => sl<DelegatorsCubit>().state.selectedAgent;

  // static UserProfileEntity? getCurrentUserProfile() {
  //   if (selectedDelegator != null) {
  //     return UserProfileEntity(
  //         id: selectedDelegator?.crNumber,
  //         type: selectedDelegator?.crType,
  //         profileType: UserProfileType.Delegator,
  //         roleId: selectedDelegator?.roleId,
  //         roleName: selectedDelegator?.roleName,
  //         name: selectedDelegator?.entityName);
  //   } else if (selectedAgent != null) {
  //     return UserProfileEntity(
  //         id: selectedAgent?.requestId,
  //         type: selectedAgent?.grantorTypeId,
  //         profileType: UserProfileType.Agent,
  //         agencyRequestKey: selectedAgent?.requestId,
  //         roleName: selectedAgent?.agencyTypeName,
  //         name: selectedAgent?.grantorName);
  //   }
  //   return null;
  // }

  static bool get isLoggedInMunicipality => sl<AuthenticationBloc>().state is AuthenticatedMunicipalityState;

  static bool get isLoggedIn => sl<AuthenticationBloc>().state is AuthenticatedState;

  /// Waits until the cold-start auth check finishes before reading [isLoggedIn].
  static Future<void> waitForAuthSessionReady({Duration timeout = const Duration(seconds: 15)}) async {
    final bloc = sl<AuthenticationBloc>();
    if (bloc.state is! AuthenticationUnknownState) {
      return;
    }
    try {
      await bloc.stream.firstWhere((state) => state is! AuthenticationUnknownState).timeout(timeout);
    } catch (_) {
      // Proceed with the current auth state if restoration times out.
    }
  }

  static GISParams? get userLocation => sl<LocationCubit>().state.gisParams;

  static GISResponse? get userLocationGIS => sl<LocationCubit>().state.gisResponse;

  //static SsoUserInfo? userInfo = sl<EntryPointCubit>().state.userInfo;

  static Stream<EntryPointState> get userStateStream => sl<EntryPointCubit>().stream;

  //static String token =
  //  "eyJhbGciOiJSUzI1NiIsImtpZCI6IjhFRDBCN0UzRjNDOTFBOEQwMUU3MEMxRUM4MTNGQTJBRjgxOEQ5MUZSUzI1NiIsIng1dCI6Imp0QzM0X1BKR28wQjV3d2V5QlA2S3ZnWTJSOCIsInR5cCI6ImF0K2p3dCJ9.eyJpc3MiOiJodHRwczovL3Nzb2FwcGRldi5tb21yYS5nb3Yuc2EiLCJuYmYiOjE2ODcwNjI0OTMsImlhdCI6MTY4NzA2MjQ5MywiZXhwIjoxNjg4MjcyMDkzLCJhdWQiOlsiRW1wbG95ZWVBZG1pbnN0cmF0aW9uLkFwaSIsImh0dHBzOi8vc3NvYXBwZGV2Lm1vbXJhLmdvdi5zYS9yZXNvdXJjZXMiXSwic2NvcGUiOlsib3BlbmlkIiwicHJvZmlsZSIsIkVtcGxveWVlQWRtaW5zdHJhdGlvbi5BcGkiLCJvZmZsaW5lX2FjY2VzcyJdLCJhbXIiOlsicHdkIl0sImNsaWVudF9pZCI6ImJhbGFkeV9tb2JpbGVfYXBwIiwic3ViIjoiMWVjZDY2NTYtMzlhMC00YmFkLTg2OWQtNjIxZGFmNWY4YmYyIiwiYXV0aF90aW1lIjoxNjg3MDYyNDkyLCJpZHAiOiJsb2NhbCIsInJvbGUiOlsiUm9sZV9MaWNlbnNlQWdlbmN5IiwiSW5zdGl0dXRlcyIsIkJhbGFkeV9BZG1pbl9Nb2JpbGUiLCJCYWxhZHlfT3RoZXIiLCJMaWNlbnNlU3RhbmRhcmRBY3Rpdml0eUFkbWluIiwiQ0FOX1NLSVBfQ09PS0lFX1ZBTElEQVRPUiIsIkxpY2Vuc2VTdGFuZGFyZEFjdGl2aXR5RGF0YUVudHJ5Il0sImVtYWlsIjoic3Vwcml5YS5qb25uYWR1bEBpbm92YXIuY29tIiwicGhvbmVfbnVtYmVyIjoiNTU3NjA5NzIyIiwibmFtZSI6IjEwMDU4MzAwODYiLCJ0aWQiOiIyMTMiLCJ0bm0iOiLYo9mF2KfZhtipINin2YTZhdiv2YrZhtipINin2YTZhdmG2YjYsdipIiwibWFpbCI6InN1cHJpeWEuam9ubmFkdWxAaW5vdmFyLmNvbSIsInNleCI6IjEiLCJkb2IiOiIwNy8wOC8xOTc2IiwicGhvbmUiOiIwNTU3NjA5NzIyIiwiYXJfbmFtZSI6Iti52KjYr9in2YTZhNmHINi02KfZgdmKINi52YLZitmEINin2YTYudmG2LLZiiIsImVuX25hbWUiOiJBQkRVTExBSCBTSEFGSSBBIEFMQU5BWkkiLCJpZF9ubyI6IjEwMDU4MzAwODYiLCJuaWQiOiIxMTMiLCJuYXRpb25hbGl0eSI6Itiz2LnZiNiv2YoiLCJpZF90eXBlIjoiMSIsInNuYW1lIjoi2LnYqNiv2KfZhNmE2Ycs2LTYp9mB2Yos2LnZgtmK2YQs2KfZhNi52YbYstmKIiwidGVuYW50cyI6Ilt7XCJUZW5hbnROYW1lXCI6XCLYp9mE2YbYt9in2YIg2KfZhNij2YjZhFwiLFwiVGVuYW50SWRcIjo2NDksXCJUZW5hbnRUeXBlXCI6XCJ0ZW5hbnRcIixcIkdvdklkXCI6bnVsbCxcIklzRGVmYXVsdFRlbmFudFwiOmZhbHNlfSx7XCJUZW5hbnROYW1lXCI6XCLYqNmE2K_ZitipINin2YTYtNix2KfYpti5INin2YTZgdix2LnZitipXCIsXCJUZW5hbnRJZFwiOjE3OSxcIlRlbmFudFR5cGVcIjpcInRlbmFudFwiLFwiR292SWRcIjpudWxsLFwiSXNEZWZhdWx0VGVuYW50XCI6ZmFsc2V9LHtcIlRlbmFudE5hbWVcIjpcItio2YTYr9mK2Kkg2KfZhNi52YXYsdipINin2YTZgdix2LnZitipXCIsXCJUZW5hbnRJZFwiOjE4MCxcIlRlbmFudFR5cGVcIjpcInRlbmFudFwiLFwiR292SWRcIjpudWxsLFwiSXNEZWZhdWx0VGVuYW50XCI6ZmFsc2V9LHtcIlRlbmFudE5hbWVcIjpcItio2YTYr9mK2Kkg2KfZhNi02YjZgtmK2Kkg2KfZhNmB2LHYudmK2KlcIixcIlRlbmFudElkXCI6MTg3LFwiVGVuYW50VHlwZVwiOlwidGVuYW50XCIsXCJHb3ZJZFwiOm51bGwsXCJJc0RlZmF1bHRUZW5hbnRcIjpmYWxzZX0se1wiVGVuYW50TmFtZVwiOlwi2KXYr9in2LHYqSDYp9mE2YXYtNin2LHZiti5INin2YTZg9io2LHZiSDZiNin2YTYrdmD2YjZhdmK2KlcIixcIlRlbmFudElkXCI6NjQ3LFwiVGVuYW50VHlwZVwiOlwidGVuYW50XCIsXCJHb3ZJZFwiOm51bGwsXCJJc0RlZmF1bHRUZW5hbnRcIjpmYWxzZX0se1wiVGVuYW50TmFtZVwiOlwi2KXYr9in2LHYqSDYp9mE2YXYtNin2LHZiti5INin2YTYqtis2KfYsdmK2Kkg2YjYp9mE2KfYs9iq2KvZhdin2LHZitipXCIsXCJUZW5hbnRJZFwiOjY0OCxcIlRlbmFudFR5cGVcIjpcInRlbmFudFwiLFwiR292SWRcIjpudWxsLFwiSXNEZWZhdWx0VGVuYW50XCI6ZmFsc2V9LHtcIlRlbmFudE5hbWVcIjpcItin2YTZhti32KfZgiDYp9mE2KvYp9mG2YpcIixcIlRlbmFudElkXCI6NjUwLFwiVGVuYW50VHlwZVwiOlwidGVuYW50XCIsXCJHb3ZJZFwiOm51bGwsXCJJc0RlZmF1bHRUZW5hbnRcIjpmYWxzZX0se1wiVGVuYW50TmFtZVwiOlwi2KfZhNmG2LfYp9mCINin2YTYq9in2YTYq1wiLFwiVGVuYW50SWRcIjo2NTEsXCJUZW5hbnRUeXBlXCI6XCJ0ZW5hbnRcIixcIkdvdklkXCI6bnVsbCxcIklzRGVmYXVsdFRlbmFudFwiOmZhbHNlfSx7XCJUZW5hbnROYW1lXCI6XCLZiNiy2KfYsdipINin2YTYtNim2YjZhiDYp9mE2KjZhNiv2YrYqSDZiNin2YTZgtix2YjZitipINmI2KfZhNin2LPZg9in2YZcIixcIlRlbmFudElkXCI6MTIxMixcIlRlbmFudFR5cGVcIjpcInRlbmFudFwiLFwiR292SWRcIjpudWxsLFwiSXNEZWZhdWx0VGVuYW50XCI6ZmFsc2V9LHtcIlRlbmFudE5hbWVcIjpcItij2YXYp9mG2Kkg2KfZhNmF2K_ZitmG2Kkg2KfZhNmF2YbZiNix2KlcIixcIlRlbmFudElkXCI6MjEzLFwiVGVuYW50VHlwZVwiOlwidGVuYW50XCIsXCJHb3ZJZFwiOm51bGwsXCJJc0RlZmF1bHRUZW5hbnRcIjp0cnVlfSx7XCJUZW5hbnROYW1lXCI6XCLYqNmE2K_ZitipINi62LHYqCDYudix2LnYsVwiLFwiVGVuYW50SWRcIjo1NTUsXCJUZW5hbnRUeXBlXCI6bnVsbCxcIkdvdklkXCI6bnVsbCxcIklzRGVmYXVsdFRlbmFudFwiOmZhbHNlfV0iLCJibWFpbCI6IiIsInNpZCI6IjQ2MkFENTM1Njc0NjREMzM0RkE0MkRENzBBMDhFQUJBIiwianRpIjoiRjQ3Mjc2Q0RCMTREREFGRUI5Rjc0RjAxQ0M3NkM2QzAifQ.OaiWru1BmWD_SbYYRNsmH7SWavSRrckOoMpBfVExBvUHWWgIh4vsUYPC2Xupw2z6F0s7Tuo2te27GVloPaVAQBJpMwZNYiu-rbPbEJ7x_EclxBXsXqIzL55ygqr8E0f332BDX6BDaNMDo_yt5oHfHE38FjHYP7E5tan0KA75bW9JI1psus9E2POoDKVea1MR3w_XNagHZsCyOY7QTJDrC9WFv3cRRTWDpHns9sxcliq7jgz28jeJnQ4Yv5wdgvKL5yUiPkVYzaVlCf5WTdt7N2xZckzR5a3PJ7ogmsosT19ZyQKlXhqAeZd1AEXUZCW4FNNGXdacfb1h6uocN92YnQ";
  static LatLng defaultLocation = const LatLng(latitude: 24.76836756001484, longitude: 46.720988751704304);
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

/// Safely shares text content, handling iOS sharePositionOrigin requirement
///
/// This function wraps Share.share() and handles the iOS requirement for
/// sharePositionOrigin. It requires a BuildContext to determine the position
/// origin for the share sheet.
///
/// [text] - The text content to share
/// [context] - Required BuildContext to determine share position origin
Future<void> safeShareText(String text, {required BuildContext context}) async {
  try {
    if (Platform.isIOS) {
      // Try to get the RenderBox from the context to determine position
      final RenderBox? box = context.findRenderObject() as RenderBox?;
      if (box != null && box.hasSize && box.size.width > 0 && box.size.height > 0) {
        final size = box.size;
        final position = box.localToGlobal(Offset.zero);
        final rect = Rect.fromLTWH(position.dx, position.dy, size.width, size.height);
        // Only use position origin if it's valid (non-zero size)
        if (rect.width > 0 && rect.height > 0) {
          await Share.share(text, sharePositionOrigin: rect);
          return;
        }
      }
    }
    // Fallback: share without position origin
    // This works on Android and iOS contexts where position cannot be determined
    await Share.share(text);
  } catch (e) {
    // If sharing with position origin fails, retry without it
    // This handles cases where position origin is invalid
    if (e.toString().contains('sharePositionOrigin')) {
      try {
        await Share.share(text);
      } catch (_) {
        rethrow;
      }
    } else {
      rethrow;
    }
  }
}
