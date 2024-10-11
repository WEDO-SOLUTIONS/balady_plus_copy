import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/events/domain/entities/search_events/search_events_item.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/services/global/web_service.dart';
import '../../../../core/utils/constants/apis/env_types.dart';
import '../../../entry_point/presentation/cubit/auth_cubit.dart';
import '../../../events/domain/entities/search_events/search_events_params.dart';
import '../../../events/domain/usecase/get_search_events.dart';
import '../../../map_page/data/model/investment_details_response.dart';
import '../../../map_page/data/model/rental_details_response.dart';
import '../../../weather_alerts/presentation/bloc/weather_alerts_cubit.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class BaladyServices {
  final WebService webService;

  BaladyServices({required this.webService});

  Future<InvestmentDetailsResponse?> getInvestmentDetails(
      String id, String type) async {
    EasyLoading.show();

    bool isSuccess = await sl<EntryPointCubit>().refreshAPIGeeToken();
    InvestmentDetailsResponse? investmentDetailsResponse;
    try {
      final response = await webService.dio.get(
        sl<EnvType>().domain + "v1/ims/investment-details",
        queryParameters: {
          'Type': type,
          'RFPID': id,
        },
        options: Options(headers: {
          'Authorization':
              "Bearer ${sl<EntryPointCubit>().state.apigeeToken?.accessToken}",
        }),
      );

      investmentDetailsResponse =
          InvestmentDetailsResponse.fromJson(response.data);
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
          arguments: investmentDetailsResponse);
    }
    return investmentDetailsResponse;
  }

  Future<InvestmentDetailsResponse?> getDirectRentalDetails(String id) async {
    EasyLoading.show();

    bool isSuccess = await sl<EntryPointCubit>().refreshAPIGeeToken();
    InvestmentDetailsResponse? investmentDetailsResponse;
    try {
      final response = await webService.dio.get(
        sl<EnvType>().domain + "v1/ims/direct-rental-opportunities" + "/$id",
        options: Options(headers: {
          'Authorization':
              "Bearer ${sl<EntryPointCubit>().state.apigeeToken?.accessToken}",
        }),
      );

      investmentDetailsResponse =
          InvestmentDetailsResponse.fromJson(response.data);
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
          RouteName.DirectRentalPage,
          arguments: investmentDetailsResponse);
    }
    return investmentDetailsResponse;
  }

  Future<RentalDetailsResponse?> getTempRentalDetails(
      String id, String type) async {
    EasyLoading.show();

    bool isSuccess = await sl<EntryPointCubit>().refreshAPIGeeToken();
    RentalDetailsResponse? investmentDetailsResponse;
    try {
      final response = await webService.dio.get(
        sl<EnvType>().domain + "v1/ims/temp-rental-details",
        queryParameters: {
          'Type': type,
          'RFPID': id,
        },
        options: Options(headers: {
          'Authorization':
              "Bearer ${sl<EntryPointCubit>().state.apigeeToken?.accessToken}",
        }),
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
          arguments: investmentDetailsResponse);
    }
    return investmentDetailsResponse;
  }

  /// To Retrieve the list of events
  Future<List<SearchEventsItem>?> getEvents() async {
    final searchEvents = GetSearchEvents(repository: sl());
    final getEventsFailureOrSuccess =
        await searchEvents(SearchEventsParams(size: 1000, page: 1));

    return await getEventsFailureOrSuccess.fold((l) {
      return null;
    }, (r) async {
      return r.items;
    });
  }

  static String getSearchText() => CommonProperties.userLocationGIS != null &&
          CommonProperties.userLocationGIS!.cityName != null &&
          CommonProperties.userLocationGIS!.cityName!.isNotEmpty
      ? "search_map_text"
          .tr()
          .replaceAll("{}", CommonProperties.userLocationGIS!.cityName!)
      : "search_map_text".tr();

  static enableLocationTracking(bool check) {
    sharedPrefs.setLocationConsent(check);

    if (check == true) {
      sl<WeatherAlertsCubit>().startTracking();
    } else {
      sl<WeatherAlertsCubit>().stopTracking();
    }
  }

  static bool getLocationTrackingStatus() {
    return sharedPrefs.getLocationConsent() ?? false;
  }

  Future<String?> getHijtiDate(String date) async {
    try {
      var url = sl<EnvType>().domain + "v1/kacst/hijri-date?sDate=$date";
      final response = await webService.dio.get(
        url,
        options: Options(headers: {
          'verifyingKEY': CommonFunctions.hashRequest(url, "GET"),
        }),
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
      var url = sl<EnvType>().domain + "v1/kacst/gregorian-date?sDate=$date";
      final response = await webService.dio.get(
        url,
        options: Options(headers: {
          'verifyingKEY': CommonFunctions.hashRequest(url, "GET"),
        }),
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
}
