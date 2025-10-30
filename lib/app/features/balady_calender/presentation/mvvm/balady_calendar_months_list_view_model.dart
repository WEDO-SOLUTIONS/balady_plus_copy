import 'dart:async';

import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/features/balady_calender/data/models/events_count_in_months/months_events_count.dart';
import 'package:balady_plus/app/features/balady_calender/domain/entities/events_count_in_months_params.dart';
import 'package:balady_plus/app/features/balady_calender/domain/repositories/balady_calendar_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../core/errors/failures.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class BaladyCalendarMonthsListViewModel extends BaseViewModel {
  final BaladyCalendarRepository repository;
  BaladyCalendarMonthsListViewModel({
    required this.repository,
    required this.paramsMonths,
  }) {
    getEventsCountInMonths(paramsMonths: paramsMonths);
  }
  ////////////////////////// For Months
  late final EventsCountInMonthsParams paramsMonths;
  List<MonthsEventsCount>? monthsList;

  Future<int?> getEventsCountInMonths(
      {required EventsCountInMonthsParams paramsMonths}) async {
    Either<Failure, List<MonthsEventsCount>> response;
    try {
      monthsList = null;
      isLoading = true;
      notifyListeners();
      response = await repository.getEventsCountInMonths(
        params: paramsMonths,
      );
      response.fold(
        (failure) {
          if (failure is NoDataFoundException) {
            errorMessage = "no_data_shown".tr();
          } else if (failure is ServerFailure) {
            errorMessage = failure.errorMessage;
          }
          notifyListeners();
        },
        (monthsList) {
          this.monthsList = monthsList;
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
}
