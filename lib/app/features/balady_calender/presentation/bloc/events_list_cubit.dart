import 'package:balady_plus/app/features/balady_calender/data/models/events_count_in_months/months_events_count.dart';
import 'package:balady_plus/app/features/balady_calender/data/models/events_details/calendar_event_item.dart';
import 'package:balady_plus/app/features/balady_calender/data/repositories/balady_calendar_repository.dart';
import 'package:balady_plus/app/features/balady_calender/domain/entities/events_details_params.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'events_list_state.dart';

class EventsListCubit extends Cubit<EventsListState> {
  final BaladyCalendarRepositoryImpl baladyCalendarRepositoryImpl;
  final List<MonthsEventsCount> listMonths;
  final EventsDetailsParams params;

  EventsListCubit({
    required this.baladyCalendarRepositoryImpl,
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
        stateType is SucceedWithPaginationEventsListState) {
      if (stateType is! SucceedWithPaginationEventsListState) {
        emit(LoadingEventsListState());
      }

      final failureOrSuccess =
          await baladyCalendarRepositoryImpl.getEventsDetails(params: params);
      failureOrSuccess.fold(
        (failure) {
          emit(FailureEventsListState(filerMessage: failure.toString()));
        },
        (newEvents) {
          // Map<int, List<CalendarEventItem>> newMapEvents = {};
          // if (stateType is SucceedWithPaginationEventsListState) {
          //   newMapEvents = stateType.event;
          // }
          // newEvents.calendarEvents?.forEach(
          //   (element) {
          //     if (newMapEvents[element.year ?? 0] != null) {
          //       newMapEvents[element.year]?.add(element);
          //     } else {
          //       newMapEvents[element.year ?? 0] = [element];
          //     }
          //   },
          // );
          //
          // if (newEvents.totalPages == params.page) {
          //   emit(
          //     SucceedEventsListState(
          //       event: newMapEvents,
          //       listMonths: listMonths,
          //     ),
          //   );
          // } else {
          //   emit(
          //     SucceedWithPaginationEventsListState(
          //       event: newMapEvents,
          //       listMonths: listMonths,
          //     ),
          //   );
          // }
        },
      );
    }
  }
}
