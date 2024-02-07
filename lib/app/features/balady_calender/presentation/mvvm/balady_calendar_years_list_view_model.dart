import 'dart:async';

import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/features/balady_calender/data/models/events_count_in_years/events_count_in_years_response.dart';
import 'package:balady_plus/app/features/balady_calender/data/models/filter/filter_response.dart';
import 'package:balady_plus/app/features/balady_calender/domain/entities/events_count_in_years_params.dart';
import 'package:balady_plus/app/features/balady_calender/domain/repositories/balady_calendar_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/errors/failures.dart';

class BaladyCalendarYearsListViewModel extends BaseViewModel {
  final BaladyCalendarRepository webService;

  BaladyCalendarYearsListViewModel({required this.webService}) {
    showEventsCountInYears();
    fetchFilterList();
  }
  var yearsList;
  var filterList;

  Future showEventsCountInYears() async {
    Either<Failure, EventsCountInYears> response;
    try {
      isLoading = true;
      notifyListeners();
      response = await webService.getEventsCountInYears(
          params: EventsCountInyearsParams(hijri: false));
      response.fold(
        (failure) {},
        (yearsList) {
          this.yearsList = yearsList.eventsCountInYearsItem;
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

  Future fetchFilterList() async {
    Either<Failure, Filter> response;
    try {
      isLoading = true;
      notifyListeners();
      response = await webService.getFilteredEvents();
      response.fold(
        (failure) {},
        (filterList) {
          this.filterList = filterList.filterItem;
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
