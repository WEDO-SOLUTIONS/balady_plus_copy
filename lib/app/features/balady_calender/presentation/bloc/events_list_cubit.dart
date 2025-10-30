import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/features/balady_calender/data/models/events_count_in_months/months_events_count.dart';
import 'package:balady_plus/app/features/balady_calender/data/models/events_details/calendar_event_item.dart';
import 'package:balady_plus/app/features/balady_calender/data/models/events_details/list_events_details.dart';
import 'package:balady_plus/app/features/balady_calender/domain/entities/events_details_params.dart';
import 'package:balady_plus/app/features/balady_calender/domain/repositories/balady_calendar_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

part 'events_list_state.dart';

class EventsListCubit extends Cubit<EventsListState> {
  final BaladyCalendarRepository baladyCalendarRepository;
  final List<MonthsEventsCount> listMonths;
  final EventsDetailsParams params;

  EventsListCubit({
    required this.baladyCalendarRepository,
    required this.listMonths,
    required this.params,
  }) : super(InitialEventsListState()) {
    getCommercialLicenseDetailsById(params);
  }

  Future<void> getCommercialLicenseDetailsById(
    EventsDetailsParams params,
  ) async {
    EventsListState stateType = state;
    if (stateType is InitialEventsListState ||
        stateType is SucceedWithPaginationEventsListState ||
        stateType is FailureEventsListState) {
      if (stateType is! SucceedWithPaginationEventsListState) {
        emit(LoadingEventsListState());
      }

      Either<Failure, EventsDetails> failureOrSuccess =
          await baladyCalendarRepository.getEventsDetails(
        params: params,
      );
      failureOrSuccess.fold(
        (failure) {
          if (failure is NoDataFoundException) {
            emit(FailureEventsListState(filerMessage: "no_data_shown".tr()));
          } else if (failure is ServerFailure) {
            emit(FailureEventsListState(filerMessage: failure.errorMessage));
          }
        },
        (newEvents) {
          Map<int, List<CalendarEventItem>> newMapEvents = {};
          if (stateType is SucceedWithPaginationEventsListState) {
            newMapEvents = stateType.event;
          }
          newEvents.calendarEvents?.forEach(
            (element) {
              int month = params.commonParams.commonParams.hijri
                  ? element.monthHijri
                  : element.month;
              if (newMapEvents[month] != null) {
                newMapEvents[month]?.add(element);
              } else {
                newMapEvents[month] = [element];
              }
            },
          );
          if ((newEvents.totalPageCount - 1) == params.page) {
            emit(
              SucceedEventsListState(
                event: newMapEvents,
                listMonths: listMonths,
              ),
            );
          } else {
            emit(
              SucceedWithPaginationEventsListState(
                page: params.page,
                event: newMapEvents,
                listMonths: listMonths,
              ),
            );
          }
          params.page++;
        },
      );
    }
  }
}
