import 'dart:async';

import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/features/balady_calender/data/models/events_count_in_years/events_count_in_years_item.dart';
import 'package:balady_plus/app/features/balady_calender/data/models/events_count_in_months/months_events_count.dart';
import 'package:balady_plus/app/features/balady_calender/data/models/events_count_in_years/events_count_in_years_response.dart';
import 'package:balady_plus/app/features/balady_calender/data/models/filter/filter_response.dart';
import 'package:balady_plus/app/features/balady_calender/domain/entities/checkbox_entity.dart';
import 'package:balady_plus/app/features/balady_calender/domain/entities/events_common_params.dart';
import 'package:balady_plus/app/features/balady_calender/domain/entities/events_count_in_months_params.dart';
import 'package:balady_plus/app/features/balady_calender/domain/repositories/balady_calendar_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../core/errors/failures.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class BaladyCalendarYearsListViewModel extends BaseViewModel {
  final BaladyCalendarRepository repository;

  BaladyCalendarYearsListViewModel({
    required this.repository,
    required this.params,
  }) {
    getEventsCountInYears();
    fetchFilterList();
  }

  ////////////////////////// For Years
  final EventsCommonParams params;
  List<EventsCountInYearsItem> yearList = [];
  EventsCountInYearsItem? selectedYear;

  Future<int?> getEventsCountInYears() async {
    Either<Failure, EventsCountInYears> response;
    try {
      isLoading = true;
      notifyListeners();
      errorMessage = null;
      response = await repository.getEventsCountInYears(params: params);
      response.fold(
        (failure) {
          yearList = [];
          if (failure is NoDataFoundException) {
            errorMessage = "no_data_shown".tr();
          } else if (failure is ServerFailure) {
            errorMessage = failure.errorMessage;
          }
          notifyListeners();
        },
        (yearsList) async {
          yearList = yearsList.eventsCountInYearsItem;
          // check if not have selected year and not list empty to select
          // deufilt years
          if (yearList.isNotEmpty && selectedYear == null) {
            // fund carent year in list and selected
            selectedYear = yearList.firstWhere(
              (element) =>
                  element.year ==
                  (params.hijri
                      ? HijriCalendar.fromDate(DateTime.now()).hYear
                      : DateTime.now().year),
            );
          }
          if (selectedYear != null) {
            await selectYear(selectedYear!);
          }
          notifyListeners();
        },
      );
    } on Exception catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      errorMessage = error.toString();
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      errorMessage = error.toString();
    }
    isLoading = false;
    notifyListeners();
    return null;
  }

  selectYear(EventsCountInYearsItem year) async {
    selectedYear = year;
    // paramsMonths.year = selectedYear!.year;
    // paramsMonths.commonParams = params;
    // await getEventsCountInM(
    //   paramsMonths: paramsMonths.copyWith(
    //     commonParams: params,
    //     year: selectedYear!.year,
    //   ),
    // );
    notifyListeners();
  }

  // Filter
  var filterList;

  List<CheckboxListTileEntity> checkboListTileEntityList = [];
  List<String> idsSelected = [];
  Future fetchFilterList() async {
    Either<Failure, Filter> response;
    try {
      isLoading = true;
      notifyListeners();
      response = await repository.getFilteredEvents();
      response.fold(
        (failure) {
          if (failure is NoDataFoundException) {
            errorMessage = "no_data_shown".tr();
          } else if (failure is ServerFailure) {
            errorMessage = failure.errorMessage;
          }
          notifyListeners();
        },
        (filterList) {
          checkboListTileEntityList = List<CheckboxListTileEntity>.generate(
            filterList.filterItem!.length,
            (index) => CheckboxListTileEntity(
              id: filterList.filterItem![index].id!,
              name: filterList.filterItem![index].name!,
              isChecked: false,
            ),
          );
          notifyListeners();
        },
      );
    } on Exception catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      errorMessage = error.toString();
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      errorMessage = error.toString();
    }
    isLoading = false;
    notifyListeners();
    return null;
  }
  //
  // ////////////////////////// For Months
  // late final EventsCountInMonthsParams paramsMonths;
  // List<MonthsEventsCount>? monthsList;
  //
  // Future<int?> getEventsCountInM(
  //     {required EventsCountInMonthsParams paramsMonths}) async {
  //   if (selectedYear?.eventsCount != 0) {
  //     Either<Failure, List<MonthsEventsCount>> response;
  //     try {
  //       monthsList = null;
  //       isLoading = true;
  //       notifyListeners();
  //       response = await repository.getEventsCountInMonths(
  //         params: paramsMonths,
  //       );
  //       response.fold(
  //         (failure) {
  //           errorMessage = failure.toString();
  //           notifyListeners();
  //         },
  //         (monthsList) {
  //           this.monthsList = monthsList;
  //           notifyListeners();
  //         },
  //       );
  //     } on Exception catch (exception) {
  //       CommonFunctions.sendEvent(
  //         dioError: exception is DioException ? exception : null,
  //         // response: response,
  //         ex: exception,
  //       );
  //       errorMessage = error.toString();
  //     } catch (exception) {
  //       CommonFunctions.sendEvent(
  //         dioError: null,
  //         // response: response,
  //         ex: Exception(error.toString()),
  //       );
  //       errorMessage = error.toString();
  //     }
  //     isLoading = false;
  //     notifyListeners();
  //   }
  //   return null;
  // }

  selectFilterOption(int index, bool isChecked) {
    if (isChecked) {
      idsSelected.add(checkboListTileEntityList[index].id);
    } else {
      idsSelected.remove(checkboListTileEntityList[index].id);
    }
    notifyListeners();
  }
}
