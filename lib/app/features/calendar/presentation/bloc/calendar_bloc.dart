import 'package:bloc/bloc.dart';

import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/errors/errors_exports.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/calendar/domain/entities/search_calendar/search_calendar_item.dart';
import 'package:balady_plus/app/features/calendar/domain/entities/search_calendar/search_calendar_params.dart';
import 'package:balady_plus/app/features/calendar/domain/usecase/get_category_event.dart';
import 'package:balady_plus/app/features/calendar/domain/usecase/get_search_events.dart';
import 'package:balady_plus/app/features/calendar/domain/usecase/grt_calendar_details.dart';
import 'package:balady_plus/app/features/calendar/presentation/bloc/calendar_event.dart';
import 'package:balady_plus/app/features/calendar/presentation/bloc/calendar_state.dart';
import 'package:balady_plus/app/features/events/domain/entities/events_category/events_category_params.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final GetSearchEvents _getSearchEvents;
  final GetCategory _getCategory;
  final GetCalendarDetails _getCalendarDetails;
  CalendarBloc()
      : _getSearchEvents = GetSearchEvents(repository: sl()),
        _getCategory = GetCategory(repository: sl()),
        _getCalendarDetails = GetCalendarDetails(repository: sl()),
        super(CalendarState(
          searchItems: const [],
          searchedParams: SearchCalendarParams(page: 1, size: 10),
          status: BlocStatus.initial,
        )) {
    on<CalendarEvent>(
      (event, emit) {
        emit(state);
      },
    );
    on<GetSearchEvent>(_getSearchEventsHandler);

    on<GetSeasonsEvent>(_getSesonsEventsHandler);
    on<GetCalendarDetailsEvent>(_getCalendarDetailsHandler);

    on<UpdateSearchParamsEvent>(_updateSearchParamsHandler);

    on<GetMoreSearchEvent>(_getMoreSearchEventsHandler);
  }
  Future<void> _getSearchEventsHandler(GetSearchEvent e, Emitter emitter) async {
    emitter(state.copyWith(
        status: BlocStatus.loading,
        searchedParams: e.update
            ? (e.params != null ? e.params!.copyWith(page: 1, size: 10) : SearchCalendarParams(page: 1, size: 10))
            : null));
    final failureOrSuccess =
        await _getSearchEvents(e.params != null ? e.params! : SearchCalendarParams(page: 1, size: 10));

    failureOrSuccess.fold((l) {
      if (l == NoDataFoundFailure()) {
        emitter(state.copyWith(status: BlocStatus.success, searchItems: []));
      } else {
        emitter(
          state.copyWith(status: BlocStatus.retry, errorMessage: (l as ServerFailure).errorMessage),
        );
      }
    }, (r) {
      emitter(state.copyWith(
        status: BlocStatus.success,
        searchItems: r.items,
        searchedParams: e.update ? state.searchedParams.copyWith(page: (state.searchedParams.page ?? 1) + 1) : null,
        errorMessage: '',
      ));
    });
  }

  Future<void> _getMoreSearchEventsHandler(GetMoreSearchEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      status: BlocStatus.loadMore,
    ));
    final failureOrSuccess = await _getSearchEvents(state.searchedParams);

    failureOrSuccess.fold((l) {
      if (l == NoDataFoundFailure()) {
        emitter(
          state.copyWith(status: BlocStatus.failure, errorMessage: ''),
        );
      } else {
        emitter(
          state.copyWith(status: BlocStatus.failure, errorMessage: (l as ServerFailure).errorMessage),
        );
      }
    }, (r) {
      List<SearchCalendarItem>? items = state.searchItems;
      items.addAll(r.items ?? []);
      emitter(state.copyWith(
        status: BlocStatus.success,
        searchItems: items,
        searchedParams: state.searchedParams.copyWith(page: (state.searchedParams.page ?? 1) + 1),
        errorMessage: '',
      ));
    });
  }

  Future<void> _getSesonsEventsHandler(GetSeasonsEvent e, Emitter emitter) async {
    if (state.seasonList?.isNotEmpty ?? false) return;

    emitter(state.copyWith(
      seasonStatus: BlocRequestStatus.submissionGetLoading,
    ));
    final failureOrSuccess = await _getCategory(EventsCategoryParams(key: 4));
    failureOrSuccess.fold((l) {
      emitter(
        state.copyWith(
          seasonStatus: (l as ServerFailure).errorCode == '2'
              ? BlocRequestStatus.submissionGetSuccess
              : BlocRequestStatus.submissionGetFailure,
          seasonList: [],
        ),
      );
    }, (r) {
      emitter(state.copyWith(
        seasonStatus: BlocRequestStatus.submissionGetSuccess,
        seasonList: r.items,
        errorMessage: '',
      ));
    });
  }

  Future<void> _updateSearchParamsHandler(UpdateSearchParamsEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      fromDate: e.fromDate,
      toDate: e.toDate,
      searchKeyword: e.searchKeyword,
      selectedSeason: e.selectedSeason,
    ));
  }

  Future<void> _getCalendarDetailsHandler(GetCalendarDetailsEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      status: BlocStatus.loading,
    ));
    final failureOrSuccess = await _getCalendarDetails(e.id);
    failureOrSuccess.fold((l) {
      emitter(
        state.copyWith(
          status: BlocStatus.failure,
        ),
      );
    }, (r) {
      emitter(state.copyWith(
        status: BlocStatus.success,
        details: r,
        errorMessage: '',
      ));
    });
  }
}
