import 'dart:async';

import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/features/balady_calender/data/models/events_count_in_years/events_count_in_years_response.dart';
import 'package:balady_plus/app/features/balady_calender/data/repositories/balady_calendar_repository.dart';
import 'package:balady_plus/app/features/balady_calender/domain/entities/events_count_in_years_params.dart';
import 'package:balady_plus/app/features/balady_calender/domain/repositories/balady_calendar_repository.dart';
import 'package:balady_plus/app/features/commercial_license_cancel/data/models/submit_response.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/errors/failures.dart';

class BaladyCalendarYearsListViewModel extends BaseViewModel {
  final BaladyCalendarRepository webService;

  BaladyCalendarYearsListViewModel({required this.webService}){
    showEventsCountInYears();
  }
  var yearList ;

  Future<int?> showEventsCountInYears(
    // String unifiedNationalNumber,
    // int relationTypeId,
    // String filterationEntity,
    // int agencyNumber,
    // int ownerTypeId,
    // bool hijri,
  ) async {
    Either<Failure, EventsCountInYears> response;
    try {
      isLoading = true;
      notifyListeners();
      response = await webService.getEventsCountInYears(params:EventsCountInyearsParams(hijri: false));
response.fold(
        (failure) {
        },
        (yearsList) {
          yearList = yearsList.eventsCountInYearsItem ;
                notifyListeners();
        },
      );
    } on Exception catch (exception) {
      CommonFunctions.sendEvent(
        dioError: exception is DioException ? exception : null,
        // response: response,
        ex: exception,
      );
      showError(exception.toString());
    } catch (exception) {
      CommonFunctions.sendEvent(
        dioError: null,
        // response: response,
        ex: Exception(exception.toString()),
      );
      showError(exception.toString());
    }
    isLoading = false;
    notifyListeners();
    return null;
  }
}
