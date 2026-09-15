import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/balady_features/model/investment_details_response.dart';
import 'package:balady_plus/app/features/_shared_feature_/balady_features/model/rental_details_response.dart';
import 'package:balady_plus/app/features/events/domain/entities/search_events/search_events_item.dart';
import 'package:balady_plus/app/features/events/domain/entities/search_events/search_events_params.dart';
import 'package:balady_plus/app/features/events/domain/usecase/get_search_events.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/dependency_injection/injection_container.dart';
import '../../../entry_point/presentation/cubit/auth_cubit.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

import '../../presentation/dialogs/need_login_dialog.dart';

class BaladyServices {
  final WebService webService;

  BaladyServices({required this.webService});

  Future<InvestmentDetailsResponse?> getInvestmentDetails(String id, String type) async {
    EasyLoading.show();

    await sl<EntryPointCubit>().refreshAPIGeeToken();
    InvestmentDetailsResponse? investmentDetailsResponse;
    try {
      final response = await webService.dio.get(
        "${sl<EnvType>().domain}v1/ims/investment-details",
        queryParameters: {'Type': type, 'RFPID': id},
        options: Options(headers: {'Authorization': "Bearer ${sl<EntryPointCubit>().state.apigeeToken?.accessToken}"}),
      );

      investmentDetailsResponse = InvestmentDetailsResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }

    EasyLoading.dismiss();

    if (investmentDetailsResponse != null) {
      NavigationService.navigatorKey.currentState!.pushNamed(
        RouteName.investmentPage,
        arguments: investmentDetailsResponse,
      );
    }
    return investmentDetailsResponse;
  }

  Future<InvestmentDetailsResponse?> getDirectRentalDetails(String id) async {
    EasyLoading.show();

    await sl<EntryPointCubit>().refreshAPIGeeToken();
    InvestmentDetailsResponse? investmentDetailsResponse;
    try {
      final response = await webService.dio.get(
        "${sl<EnvType>().domain}v1/ims/direct-rental-opportunities/$id",
        options: Options(headers: {'Authorization': "Bearer ${sl<EntryPointCubit>().state.apigeeToken?.accessToken}"}),
      );

      investmentDetailsResponse = InvestmentDetailsResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }

    EasyLoading.dismiss();

    if (investmentDetailsResponse != null) {
      NavigationService.navigatorKey.currentState!.pushNamed(
        RouteName.directRentalPage,
        arguments: investmentDetailsResponse,
      );
    }
    return investmentDetailsResponse;
  }

  Future<RentalDetailsResponse?> getTempRentalDetails(String id, String type) async {
    EasyLoading.show();

    await sl<EntryPointCubit>().refreshAPIGeeToken();
    RentalDetailsResponse? investmentDetailsResponse;
    try {
      final response = await webService.dio.get(
        "${sl<EnvType>().domain}v1/ims/temp-rental-details",
        queryParameters: {'Type': type, 'RFPID': id},
        options: Options(headers: {'Authorization': "Bearer ${sl<EntryPointCubit>().state.apigeeToken?.accessToken}"}),
      );

      investmentDetailsResponse = RentalDetailsResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
    EasyLoading.dismiss();
    if (investmentDetailsResponse != null) {
      NavigationService.navigatorKey.currentState!.pushNamed(
        RouteName.tempRentalPage,
        arguments: investmentDetailsResponse,
      );
    }
    return investmentDetailsResponse;
  }

  /// To Retrieve the list of events
  Future<List<SearchEventsItem>?> getEvents() async {
    final searchEvents = GetSearchEvents(repository: sl());
    final getEventsFailureOrSuccess = await searchEvents(SearchEventsParams(size: 1000, page: 1));

    return await getEventsFailureOrSuccess.fold(
      (l) {
        return null;
      },
      (r) async {
        return r.items;
      },
    );
  }

  static String getSearchText() =>
      CommonProperties.userLocationGIS != null &&
          CommonProperties.userLocationGIS!.cityName != null &&
          CommonProperties.userLocationGIS!.cityName!.isNotEmpty
      ? "search_map_text".tr().replaceAll("{}", CommonProperties.userLocationGIS!.cityName!)
      : "search_map_text".tr();

  // static enableLocationTracking(bool check) {
  //   sharedPrefs.setLocationConsent(check);
  //
  //   if (check == true) {
  //     sl<WeatherAlertsCubit>().startTracking();
  //   } else {
  //     sl<WeatherAlertsCubit>().stopTracking();
  //   }
  // }

  static bool getLocationTrackingStatus() {
    return sharedPrefs.getLocationConsent() ?? false;
  }

  Future<String?> getHijtiDate(String date) async {
    try {
      var url = "${sl<EnvType>().domain}v1/kacst/hijri-date?sDate=$date";
      final response = await webService.dio.get(
        url,
        options: Options(headers: {'verifyingKEY': CommonFunctions.hashRequest(url, "GET")}),
      );

      String d = response.data["data"]["result"];

      List<String> dd = d.split("/");
      int? year = int.tryParse(dd[2]);
      int? month = int.tryParse(dd[1]);
      int? day = int.tryParse(dd[0]);

      return "$year/${month.toString().padLeft(2, "0")}/${day.toString().padLeft(2, "0")}";
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

  Future<String?> getGorgianDate(String date) async {
    try {
      var url = "${sl<EnvType>().domain}v1/kacst/gregorian-date?sDate=$date";
      final response = await webService.dio.get(
        url,
        options: Options(headers: {'verifyingKEY': CommonFunctions.hashRequest(url, "GET")}),
      );

      String d = response.data["data"]["result"];

      List<String> dd = d.split("/");
      int? year = int.tryParse(dd[2]);
      int? month = int.tryParse(dd[1]);
      int? day = int.tryParse(dd[0]);

      return "$year/${month.toString().padLeft(2, "0")}/${day.toString().padLeft(2, "0")}";
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

  static Future<bool> checkLocationSettings(BuildContext context) {
    return CommonFunctions.checkLocationSettings(context);
  }

  // static Future<String> getBuildingCompliance(
  //     BuildContext context, double lat, double lon) async {
  //   try {
  //     var r = await GetBuildingCompliance(sl()).call(GISParams(x: lon, y: lat));
  //
  //     return r.getRight?.first.stageno ?? "";
  //   } catch (ex) {
  //     return "";
  //   }
  // }

  ////
  ///
  ///

  static bool isLoggedIn() {
    return CommonProperties.isLoggedInMunicipality;
  }

  static void openIssueLicense() {
    // NavigationService.navigatorKey.currentState
    //   ?.pushNamed(CommercialRouteName.commercialLicensePage);

    launchUrl(
      Uri.parse(
        "https://balady.gov.sa/ar/services/%D8%A5%D8%B5%D8%AF%D8%A7%D8%B1-%D8%B1%D8%AE%D8%B5%D8%A9-%D8%AA%D8%AC%D8%A7%D8%B1%D9%8A%D8%A9",
      ),
    );
  }

  static void openChatGPT() {
    if (CommonProperties.isLoggedInMunicipality) {
      NavigationService.navigatorKey.currentState?.pushNamed(RouteName.chatbot);
    } else {
      showDialog(
        context: NavigationService.navigatorKey.currentContext!,
        builder: (ctx) => NeedLoginDialog(
          onSuccessLogin: (bool? isSuccess) async {
            if (isSuccess ?? false) {
              NavigationService.navigatorKey.currentState?.pushNamed(RouteName.chatbot);
            }
          },
        ),
      );
    }
  }

  static Future<bool> login() async {
    if (CommonProperties.isLoggedInMunicipality) {
      return Future.value(true);
    } else {
      return await showDialog(
        context: NavigationService.navigatorKey.currentContext!,
        builder: (ctx) => NeedLoginDialog(
          onSuccessLogin: (bool? isSuccess) async {
            if (isSuccess ?? false) {
              return Future.value(true);
            }
            return Future.value(false);
          },
        ),
      );
    }
  }

  static String get token => CommonProperties.token;
  static String get userId => CommonProperties.userInfo?.idNo ?? "";

  static void navigateToLicenseMangments() {
    if (CommonProperties.isLoggedInMunicipality) {
      NavigationService.navigatorKey.currentState?.pushNamed(RouteName.requests);
    } else {
      showDialog(
        context: NavigationService.navigatorKey.currentContext!,
        builder: (ctx) => NeedLoginDialog(
          onSuccessLogin: (bool? isSuccess) async {
            if (isSuccess ?? false) {
              NavigationService.navigatorKey.currentState?.pushNamed(RouteName.requests);
            }
          },
        ),
      );
    }
  }

  static void navigateToLicense() {
    if (CommonProperties.isLoggedInMunicipality) {
      NavigationService.navigatorKey.currentState?.pushNamed(RouteName.licenses);
    } else {
      showDialog(
        context: NavigationService.navigatorKey.currentContext!,
        builder: (ctx) => NeedLoginDialog(
          onSuccessLogin: (bool? isSuccess) async {
            if (isSuccess ?? false) {
              NavigationService.navigatorKey.currentState?.pushNamed(RouteName.licenses);
            }
          },
        ),
      );
    }
  }
}
