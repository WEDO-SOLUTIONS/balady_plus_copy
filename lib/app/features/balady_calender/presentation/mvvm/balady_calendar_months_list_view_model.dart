import 'dart:async';

import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/features/balady_calender/data/models/events_count_in_months/months_events_count.dart';
import 'package:balady_plus/app/features/balady_calender/domain/entities/events_count_in_months_params.dart';
import 'package:balady_plus/app/features/balady_calender/domain/repositories/balady_calendar_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';

class BaladyCalendarMonthsListViewModel extends BaseViewModel {
  final BaladyCalendarRepository repository;
  BaladyCalendarMonthsListViewModel({
    required this.repository,
    required this.paramsMonths,
  }) {
    getEventsCountInMonths(paramsMonths:paramsMonths);
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
            errorMessage = failure.toString();
            // showError(failure.toString());
          },
          (monthsList) {
            this.monthsList = monthsList;
            notifyListeners();
          },
        );
      } on Exception catch (exception) {
        CommonFunctions.sendEvent(
          dioError: exception is DioException ? exception : null,
          // response: response,
          ex: exception,
        );
        errorMessage = exception.toString();
        // showError(exception.toString());
      } catch (exception) {
        CommonFunctions.sendEvent(
          dioError: null,
          // response: response,
          ex: Exception(exception.toString()),
        );
        errorMessage = exception.toString();
        // showError(exception.toString());
      }
      isLoading = false;
      notifyListeners();
    return null;
  }

}
