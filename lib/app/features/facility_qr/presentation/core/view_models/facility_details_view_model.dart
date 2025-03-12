import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/features/facility_qr/data/license_ratings_items.dart';
import 'package:balady_plus/app/features/facility_qr/data/qr_details_response.dart';
import 'package:balady_plus/app/features/facility_qr/presentation/core/repository/facility_qr_repository.dart';

import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:tuple/tuple.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/base/base_view_model.dart';
import '../../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../data/qr_photo.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class FacilityQRDetailsViewModel extends BaseViewModel {
  QrDetailsResponse? facilityRespoonse;
  List<RatingItem> ratingItems = [];
  List<QRPhoto> entityPhotos = [];
  String coverPhoto = "";
  FacilityQRDetailsViewModel({this.facilityRespoonse}) {}

  LatLng _userLocation = const LatLng(latitude:24.694203971954554, longitude:46.81549530431028);
  bool isOpenNow = true;
  final _repositry = FacilityQRRepository();
  String qrCode = "";

  String? getLicenceFromBarcode(String qr) {
    if (qr != null && qr.contains("qrcode/qr/exp")) {
      int lastIndex = qr.lastIndexOf("/");
      if (lastIndex != -1) {
        CommonFunctions.sendUXCamEvent(
            UXCamEvents.YourFeedback_Scan_Correct_QR_Event);
        String licenseId = qr.substring(lastIndex + 1);
        qrCode = qr;
        return licenseId;
      } else {
        // showError("error2");
        showError(("wrong_qr_code").tr());
        CommonFunctions.sendUXCamEvent(
            UXCamEvents.YourFeedback_Scan_Wrong_QR_Event);
      }
    } else {
      showError(("wrong_qr_code").tr());
      CommonFunctions.sendUXCamEvent(
          UXCamEvents.YourFeedback_Scan_Wrong_QR_Event);
    }
  }

  Future<bool> getFacilityData(String licenseId,
      {bool showLoader = true}) async {
    if (showLoader) showLoading();
    ratingItems = [];
    final QrDetailsResponse? response =
        await _repositry.getEntityDetails(licenseId);
    if (showLoader) hideLoading();
    facilityRespoonse = response;
    if (response != null) {
      if (response.data?.responseCode == 1) {
        isOpenNow = checkIsOpenNow();
        notifyListeners();
        getRatingsData();
        setEntityPhotos();
        CommonFunctions.sendUXCamEvent(
            UXCamEvents.YourFeedback_Retrive_License_Data_Event);
        return true;
      } else {
        String error =
            response.data?.responseMessage ?? ("errors_server_error_1").tr();
        showError(error);
        return false;
      }
    } else {
      // show Error
      // showError("error3");
      return false;
    }
  }

  Future<bool> getRatingsData() async {
    if (ratingItems.isNotEmpty) return true;

    final Tuple3<bool?, String?, LicenseRatingItems?> response =
        await _repositry.getLicenseRatingitems();

    if (response.item3 != null && response.item1 == true) {
      // ratingsData = response;
      ratingItems = response.item3?.data?.result ?? [];
      // setPreviousRatings();
      notifyListeners();
      return true;
    } else {
      // show Error
      showError(response.item2 ?? "");
      return false;
    }
  }

  String getFacilityName() {
    if (facilityRespoonse != null) {
      return facilityRespoonse
              ?.data?.result?.comLicenseInfo?.shopInfo?.shopName ??
          "";
    }
    return "";
  }

  double getFacilityAvrageRating() {
    if (facilityRespoonse != null) {
      String avrage =
          facilityRespoonse?.data?.result?.ratingInfo?.average.toString() ??
              "0";
      return double.tryParse(avrage) ?? 0;
    }
    return 0;
  }

  int getFacilityTotalRatingCount() {
    if (facilityRespoonse != null) {
      String count = "";
      count = facilityRespoonse?.data?.result?.ratingInfo?.totalRatingCount
              .toString() ??
          "";

      return int.tryParse(count) ?? 0;
    }
    return 0;
  }

  String getCity() {
    if (facilityRespoonse != null) {
      return facilityRespoonse
              ?.data?.result?.comLicenseInfo?.locationInfo?.regionName
              ?.trim() ??
          "";
    }
    return "";
  }

  String getStreet() {
    if (facilityRespoonse != null) {
      return facilityRespoonse
              ?.data?.result?.comLicenseInfo?.locationInfo?.streetName
              ?.trim() ??
          "";
    }
    return "";
  }

  String getCityAndStreet() {
    if (facilityRespoonse != null) {
      String address = "";
      String streetName = facilityRespoonse
              ?.data?.result?.comLicenseInfo?.locationInfo?.streetName ??
          "";
      String cityName = facilityRespoonse
              ?.data?.result?.comLicenseInfo?.locationInfo?.regionName ??
          "";
      if (streetName.isNotEmpty) address += streetName + "، ";
      address += cityName;
      return address.trim();
    }
    return "";
  }

  List<RatingItemAverage> ratingItemAverages() {
    if (facilityRespoonse == null) {
      return [];
    }
    return facilityRespoonse?.data?.result?.ratingInfo?.ratingItemAverages ??
        [];
  }

  FACILITY_STATUS getFacilityStatus() {
    if (getIsLicenseCancelled()) return FACILITY_STATUS.cancel;
    return isOpenNow ? FACILITY_STATUS.open : FACILITY_STATUS.close;
  }

  String getCoverPhotoUrl() {
    if (facilityRespoonse != null &&
        facilityRespoonse?.data?.result?.attachments != null) {
      return facilityRespoonse!.data!.result!.attachments!
              .firstWhereOrNull((element) => element.typeId == 413)
              ?.code ??
          facilityRespoonse?.data?.result?.attachments?[0].code ??
          "";
    }
    return "";
  }

  bool getIsLicenseCancelled() {
    bool isCancelled = false;
    if (facilityRespoonse != null) {
      if (facilityRespoonse?.data?.result?.comLicenseInfo?.licenseStatusId ==
          3) {
        isCancelled = true;
      }
    }
    return isCancelled;
  }

  String getTodayWorkingHours() {
    WorkTimes? workTimes = facilityRespoonse?.data?.result?.workTimes;

    if (workTimes == null) return "";

    if (workTimes.getToday() != null) {
      if (workTimes.getToday()?.openShiftOption == "OPEN_24HOUR") {
        return "";
      }
      DateTime todayDate = DateTime.now();
      String? firstFromTime = workTimes.getToday()?.firstFromTime;
      String? firstToTime = workTimes.getToday()?.firstToTime;

      int? firstFromHour;
      int? firstFromMinute;
      int? firstToHour;
      int? firstToMinute;

      String? secondFromTime = workTimes.getToday()?.secondFromTime;
      String? secondToTime = workTimes.getToday()?.secondToTime;

      int? secondFromHour;
      int? secondFromMinute;
      int? secondToHour;
      int? secondToMinute;
      if (firstFromTime != null) {
        firstFromHour = int.tryParse(firstFromTime.split(":")[0]);

        firstFromMinute = int.tryParse(firstFromTime.split(":")[1]);
      }
      if (firstToTime != null) {
        firstToHour = int.tryParse(firstToTime.split(":")[0]);
        firstToMinute = int.tryParse(firstToTime.split(":")[1]);
      }

      if (secondFromTime != null) {
        secondFromHour = int.tryParse(secondFromTime.split(":")[0]);

        secondFromMinute = int.tryParse(secondFromTime.split(":")[1]);
      }
      if (secondToTime != null) {
        secondToHour = int.tryParse(secondToTime.split(":")[0]);
        secondToMinute = int.tryParse(secondToTime.split(":")[1]);
      }

      if (isOpenNow && workTimes.getToday()?.openShiftOption == "SHIFTED") {
        if (firstFromHour != null &&
            firstFromMinute != null &&
            firstToHour != null &&
            firstToMinute != null) {
          DateTime date = DateTime.now();
          final startTime = DateTime(
              date.year, date.month, date.day, firstFromHour, firstFromMinute);

          // To handle 12 AM to Case
          var firstToHourTmp = firstToHour;
          var firstToMinuteTmp = firstToMinute;
          if (firstToHour == 0 && firstToMinute == 0) {
            firstToHourTmp = 23;
            firstToMinuteTmp = 59;
          }

          final endTime = DateTime(date.year, date.month, date.day,
              firstToHourTmp, firstToMinuteTmp);
          final currentTime = DateTime.now();
          if (currentTime.isAfter(startTime) && currentTime.isBefore(endTime)) {
            return "qr_closes_at".tr() +
                CommonFunctions.convert24TimeTo12WithPeriod(
                    workTimes.getToday()?.firstToTime);
          }
        }
        if (secondFromHour != null &&
            secondFromMinute != null &&
            secondToHour != null &&
            secondToMinute != null) {
          DateTime date = DateTime.now();

          final startTime = DateTime(date.year, date.month, date.day,
              secondFromHour, secondFromMinute);
          // To handle 12 AM to Case
          var secondToHourTmp = secondToHour;
          var secondToMinuteTmp = secondToMinute;
          if (secondToHour == 0 && secondToMinute == 0) {
            secondToHourTmp = 23;
            secondToMinuteTmp = 59;
          }
          final endTime = DateTime(date.year, date.month, date.day,
              secondToHourTmp, secondToMinuteTmp);
          final currentTime = DateTime.now();
          if (currentTime.isAfter(startTime) && currentTime.isBefore(endTime)) {
            return "qr_closes_at".tr() +
                CommonFunctions.convert24TimeTo12WithPeriod(
                    workTimes.getToday()?.secondToTime);
          }
        }
      } else if (!isOpenNow &&
          workTimes.getToday()?.openShiftOption == "SHIFTED") {
        if (firstFromHour != null && firstFromMinute != null) {
          DateTime date = DateTime.now();
          final startTime = DateTime(
              date.year, date.month, date.day, firstFromHour, firstFromMinute);
          final currentTime = DateTime.now();
          if (currentTime.isBefore(startTime)) {
            return "qr_opens".tr() +
                CommonFunctions.convert24TimeTo12WithPeriod(
                    workTimes.getToday()?.firstFromTime);
          }
        }

        if (secondFromHour != null && secondFromMinute != null) {
          DateTime date = DateTime.now();
          final startTime = DateTime(date.year, date.month, date.day,
              secondFromHour, secondFromMinute);
          final currentTime = DateTime.now();
          if (currentTime.isBefore(startTime)) {
            return "qr_opens".tr() +
                CommonFunctions.convert24TimeTo12WithPeriod(
                    workTimes.getToday()?.secondFromTime);
          }
        }
      }
      if (!isOpenNow) {
        String strWhenClosed = "";
        int nextDayWeekDay = workTimes.getToday()?.weekDay == DateTime.sunday
            ? DateTime.monday
            : workTimes.getToday()!.weekDay! + 1;

        for (int i = 0; i < workTimes.workingTimes!.length; i++) {
          int nextDay = workTimes.workingTimes!
              .indexWhere((element) => element.weekDay == nextDayWeekDay);

          if (nextDay != -1) {
            WorkingTime day = workTimes.workingTimes![nextDay];
            if (day.openShiftOption == "OPEN_24HOUR") {
              if (i == 0) {
                strWhenClosed = "qr_opens_tommorow".tr();
              } else {
                strWhenClosed = " ${"qr_opens".tr()} ${day.dayName}";
              }
              return strWhenClosed;
            } else if (day.openShiftOption == "SHIFTED") {
              strWhenClosed =
                  "${"qr_opens".tr()} ${day.dayName} ${CommonFunctions.convert24TimeTo12WithPeriod(day.firstFromTime!)}";
              return strWhenClosed;
            } else if (day.openShiftOption == "CLOSED") {
              nextDayWeekDay = nextDayWeekDay == DateTime.sunday
                  ? DateTime.monday
                  : nextDay + 1;
            }
          }
        }

        return strWhenClosed;
      }

      return " . " +
          CommonFunctions.getFormattedTimeforQR(
              workTimes.getToday()?.firstFromTime,
              workTimes.getToday()?.firstToTime);
    }
    return "";
  }

  bool checkIsOpenNow() {
    bool isOpenedNow = false;
    DateTime date = DateTime.now();
    WorkTimes? workTimes = facilityRespoonse?.data?.result?.workTimes;
    WorkingTime? today = workTimes?.getToday();

    if (today == null) return isOpenedNow;
    if (today.openShiftOption == "OPEN_24HOUR") {
      isOpenedNow = true;
    } else if (today.openShiftOption == "SHIFTED" &&
        today.firstFromTime != null &&
        today.firstToTime != null) {
      int? firstFromHour;
      int? firstFromMinute;
      int? firstToHour;
      int? firstToMinute;

      if (today.firstFromTime != null) {
        firstFromHour = int.tryParse(today.firstFromTime!.split(":")[0]);

        firstFromMinute = int.tryParse(today.firstFromTime!.split(":")[1]);
      }
      if (today.firstToTime != null) {
        firstToHour = int.tryParse(today.firstToTime!.split(":")[0]);
        firstToMinute = int.tryParse(today.firstToTime!.split(":")[1]);
      }

      if (firstFromHour != null &&
          firstFromMinute != null &&
          firstToHour != null &&
          firstToMinute != null) {
        final startTime = DateTime(
            date.year, date.month, date.day, firstFromHour, firstFromMinute);
        // To handle 12 AM to Case
        var firstToHourTmp = firstToHour;
        var firstToMinuteTmp = firstToMinute;
        if (firstToHour == 0 && firstToMinute == 0) {
          firstToHourTmp = 23;
          firstToMinuteTmp = 59;
        }
        final endTime = DateTime(
            date.year, date.month, date.day, firstToHourTmp, firstToMinuteTmp);
        final currentTime = DateTime.now();
        if (currentTime.isAfter(startTime) && currentTime.isBefore(endTime)) {
          isOpenedNow = true;
        }
      }
    }
    if (!isOpenedNow &&
        today.openShiftOption == "SHIFTED" &&
        today.secondFromTime != null &&
        today.secondToTime != null) {
      int? secondFromHour;
      int? secondFromMinute;
      int? secondToHour;
      int? secondToMinute;

      if (today.secondFromTime != null) {
        secondFromHour = int.tryParse(today.secondFromTime!.split(":")[0]);

        secondFromMinute = int.tryParse(today.secondFromTime!.split(":")[1]);
      }
      if (today.secondToTime != null) {
        secondToHour = int.tryParse(today.secondToTime!.split(":")[0]);
        secondToMinute = int.tryParse(today.secondToTime!.split(":")[1]);
      }

      if (secondFromHour != null &&
          secondFromMinute != null &&
          secondToHour != null &&
          secondToMinute != null) {
        final startTime = DateTime(
            date.year, date.month, date.day, secondFromHour, secondFromMinute);

        // To handle 12 AM to Case
        var secondToHourTmp = secondToHour;
        var secondToMinuteTmp = secondToMinute;
        if (secondToHour == 0 && secondToMinute == 0) {
          secondToHourTmp = 23;
          secondToMinuteTmp = 59;
        }

        final endTime = DateTime(date.year, date.month, date.day,
            secondToHourTmp, secondToMinuteTmp);
        final currentTime = DateTime.now();
        if (currentTime.isAfter(startTime) && currentTime.isBefore(endTime)) {
          isOpenedNow = true;
        }
      }
    }
    return isOpenedNow;
  }

  LatLng? getMapLocation() {
    if (facilityRespoonse != null) {
      double? lat = facilityRespoonse
          ?.data?.result?.comLicenseInfo?.locationInfo?.latitude;
      double? long = facilityRespoonse
          ?.data?.result?.comLicenseInfo?.locationInfo?.longitude;
      if (lat != null && long != null) {
        return LatLng(latitude:lat, longitude:long);
      }
    }

    return null;
  }

  void launchMapsUrl(LatLng _location) async {
    if (_location != null) {
      // final url =
      //     'https://www.google.com/maps/search/?api=1&query=${_location.latitude},${_location.longitude}';
      CommonFunctions.openMap(_location.latitude, _location.longitude);
    }
  }

  String getFacilityClassification() {
    return facilityRespoonse
            ?.data?.result?.comLicenseInfo?.facilityClassification ??
        ("qr_no_classification_details").tr();
  }

  String getFacilityClassificationImg() {
    if (facilityRespoonse != null &&
        facilityRespoonse?.data?.result?.comLicenseInfo != null &&
        facilityRespoonse
                ?.data?.result?.comLicenseInfo?.facilityClassificationId !=
            null) {
      switch (facilityRespoonse
          ?.data?.result?.comLicenseInfo?.facilityClassificationId) {
        case 251:
          return IconPath.qrAIcon;
        case 252:
          return IconPath.qrBIcon;
        case 253:
          return IconPath.qrCIcon;
        case 254:
          return IconPath.qrDIcon;

        case 255:
          return IconPath.qrLockIcon;

        default:
          return "";
      }
    } else {
      return "";
    }
  }

  bool showContactInfo() {
    if (facilityRespoonse?.data?.result?.enterpriseInfo?.contactInfo != null) {
      return true;
    }
    return false;
  }

  String twitterContact() {
    String? twitterUrl =
        facilityRespoonse?.data?.result?.enterpriseInfo?.contactInfo?.twitter;
    return twitterUrl ?? "";
  }

  String facebookContact() {
    String? facebookUrl =
        facilityRespoonse?.data?.result?.enterpriseInfo?.contactInfo?.facebook;
    return facebookUrl ?? "";
  }

  String instegramContact() {
    String? instegramUrl =
        facilityRespoonse?.data?.result?.enterpriseInfo?.contactInfo?.instegram;
    return instegramUrl ?? "";
  }

  String snapchatContact() {
    String? snapchatUrl =
        facilityRespoonse?.data?.result?.enterpriseInfo?.contactInfo?.snapchat;

    return snapchatUrl ?? "";
  }

  String webSiteContact() {
    String? websiteUrl =
        facilityRespoonse?.data?.result?.enterpriseInfo?.contactInfo?.website;
    return websiteUrl ?? "";
  }

  String whatsUpContact() {
    String? whatsApp =
        facilityRespoonse?.data?.result?.enterpriseInfo?.contactInfo?.whatsApp;
    return whatsApp ?? "";
  }

  void launchURL(String url) async {
    try {
      await launch(url);
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

  String getWhatsUpNumber() {
    String number = "";
    String whatsApp = whatsUpContact();
    try {
      if (whatsApp.isNotEmpty) {
        String n = whatsApp;
        if (n.length == 10 && n.startsWith("0")) {
          number = "966" + n.substring(1, n.length);
        } else if (n.length == 9 && n.startsWith("5")) {
          number = "966" + n;
        } else if (n.startsWith("966")) {
          number = n;
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

    return number;
  }

  String getEnterpriseUniqueCode() {
    String number = "";
    try {
      number = facilityRespoonse
              ?.data?.result?.enterpriseInfo?.contactInfo?.enterpriseUniqueCode
              ?.toString() ??
          "";
    } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

    return number;
  }

  String getWebUrl() {
    String? url =
        facilityRespoonse?.data?.result?.enterpriseInfo?.contactInfo?.website;
    return url ?? "";
  }

  String getLicenseUuid() {
    return facilityRespoonse?.data?.result?.comLicenseInfo?.licenseUuid ?? "";
  }

  String getShareUrl() {
    return qrCode;
  }

  String getEntityAddress() {
    String address = "";
    try {
      String shopName = getFacilityName();
      String streetName = facilityRespoonse
              ?.data?.result?.comLicenseInfo?.locationInfo?.streetName ??
          "";
      String regionName = facilityRespoonse
              ?.data?.result?.comLicenseInfo?.locationInfo?.regionName ??
          "";
      return shopName + "، " + streetName + "، " + regionName;
    } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
    return address;
  }

  bool hasParking() {
    return facilityRespoonse?.data?.result?.qrCodeAdditionalInfo?.hasParking ??
        false;
  }

  bool hasVehicleParking() {
    return facilityRespoonse
            ?.data?.result?.qrCodeAdditionalInfo?.hasVehicleParking ==
        "YES";
  }

  bool hasDelivery() {
    return facilityRespoonse?.data?.result?.qrCodeAdditionalInfo?.hasDelivery ==
        "YES";
  }

  bool serveDisabledPersons() {
    return facilityRespoonse
            ?.data?.result?.qrCodeAdditionalInfo?.serveDisabledPersons ==
        true;
  }

  void setEntityPhotos() {
    entityPhotos.clear();
    if (facilityRespoonse?.data != null &&
        facilityRespoonse?.data?.result?.attachments != null) {
      QRPhoto allPhotos =
          new QRPhoto(typeId: 0, typeName: "جميع الصور", url: []);
      facilityRespoonse?.data?.result?.attachments?.forEach((element) {
        // Setting Covevr Photo as Banner(413)
        if (element.typeId == 413 && element.code != null)
          coverPhoto = element.code ?? "";

        int typeIndex =
            entityPhotos.indexWhere((photo) => element.typeId == photo.typeId);
        if (typeIndex == -1) {
          List<String> urls = [];
          urls.add(element.code ?? "");
          entityPhotos.add(new QRPhoto(
              typeId: element.typeId, typeName: element.typeName, url: urls));
        } else {
          entityPhotos[typeIndex].url.add(element.code ?? "");
        }
        allPhotos.url.add(element.code ?? "");
      });

      // Setting cover photo to take first Photo incase no banner exists:
      if (coverPhoto.isEmpty &&
          (facilityRespoonse?.data?.result?.attachments?.isNotEmpty ?? false))
        coverPhoto =
            facilityRespoonse?.data?.result?.attachments?[0].code != null
                ? facilityRespoonse?.data?.result?.attachments![0].code ?? ""
                : "";
    }
  }

/*
  void navigateToCreateIncident({required PAGE_TYPE fromScreen}) async {
    double? lat =
        facilityRespoonse?.data?.result?.comLicenseInfo?.locationInfo?.latitude;
    double? long = facilityRespoonse
        ?.data?.result?.comLicenseInfo?.locationInfo?.longitude;

    if (lat != null && long != null) {
      locator<NewIncdietViewModel>().selectedLocation = SelectedLocation(
        selectedLocationAddress: getEntityAddress(),
        selectedLocation: getMapLocation(),
      );
      locator<NewIncdietViewModel>().type =
          CustomerVoiceReportTypeModel.getListOfReportTypesFromListOfJsons(
              defaultConfiguration["CustomerVoiceReportTypes"])[1];

      locator<NewIncdietViewModel>().fromScreen = fromScreen;

      bool isSucceess = await locator<NewIncdietViewModel>().getMapGISInfo(
          mapLocaton:
              locator<NewIncdietViewModel>().selectedLocation.selectedLocation!,
          select: false,
          facility: true);
      // locator<NewIncdietViewModel>().getPrimaryZones();
      if (isSucceess) {
        NavigationService.navigatorKey.currentState!
            .pushNamed(RoutesNames.facilityIncidentRoute);
      }
    } else {
      showError(Helpers.translatingWord("no_store_location_qr"));
    }
  }

*/
}
