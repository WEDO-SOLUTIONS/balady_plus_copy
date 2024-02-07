import 'dart:async';

import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/features/balady_calender/data/models/events_count_in_months/events_count_in_months.dart';
import 'package:balady_plus/app/features/balady_calender/data/models/events_count_in_months/months_events_count.dart';
import 'package:balady_plus/app/features/balady_calender/data/models/events_count_in_years/events_count_in_years_item.dart';
import 'package:balady_plus/app/features/balady_calender/data/models/events_count_in_years/events_count_in_years_response.dart';
import 'package:balady_plus/app/features/balady_calender/domain/entities/events_common_params.dart';
import 'package:balady_plus/app/features/balady_calender/domain/entities/events_details_params.dart';
import 'package:balady_plus/app/features/balady_calender/data/models/filter/filter_response.dart';
import 'package:balady_plus/app/features/balady_calender/domain/entities/events_count_in_years_params.dart';
import 'package:balady_plus/app/features/balady_calender/domain/repositories/balady_calendar_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/errors/failures.dart';

class BaladyCalendarYearsListViewModel extends BaseViewModel {
  final BaladyCalendarRepository repository;
  final EventsDetailsParams params;

  BaladyCalendarYearsListViewModel({
    required this.repository,
    required this.params,
  }) {
    fetchFilterList();
    getEventsCountInYears();
  }
  var yearList ;

  ////////////////////////// For Years
  late List<EventsCountInYearsItem> yearList;
  EventsCountInYearsItem? selectedYear;

  Future<int?> getEventsCountInYears() async {
    Either<Failure, EventsCountInYears> response;
    try {
      isLoading = true;
      notifyListeners();
      response = await repository.getEventsCountInYears(params: params);
      response.fold(
            (failure) {},
            (yearsList) {
          yearList = yearsList.eventsCountInYearsItem;
          //
          if (yearList.isNotEmpty) {
            // fund carent year in list and selected
            selectedYear = yearList.firstWhere(
                  (element) => element.year == DateTime.now().year,
            );
            getEventsCountInM();
          }
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

  void selectYear(EventsCountInYearsItem year) {
    selectedYear = year;
    notifyListeners();
    getEventsCountInM();
  }

  ////////////////////////// For Months
  List<MonthsEventsCount>? monthsList;

  Future<int?> getEventsCountInM() async {
    Either<Failure, EventsCountInMonths> response;
    try {
      monthsList = null;
      isLoading = true;
      notifyListeners();
      response = await repository.getEventsCountInMonths(params: params);
      response.fold(
            (failure) {
          showError(failure.toString());
        },
            (monthsList) {
          this.monthsList = monthsList.monthsEventsCount;
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

  // Filter
  var filterList;

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
