import 'package:balady_plus/app/core/errors/errors_exports.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/dependency_injection/injection_container.dart';
import '../../../events/domain/entities/events_category/events_category_params.dart';
import '../../domain/entities/search_calendar/search_calendar_item.dart';
import '../../domain/entities/search_calendar/search_calendar_params.dart';
import '../../domain/usecase/get_category_event.dart';
import '../../domain/usecase/get_search_events.dart';
import 'calendar_event.dart';
import 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final GetSearchEvents _getSearchEvents;
  final GetCategory _getCategory;
  CalendarBloc()
      : _getSearchEvents = GetSearchEvents(repository: sl()),
        _getCategory = GetCategory(repository: sl()),
        super(CalendarState(
          searchItems: [],
          searchedParams: SearchCalendarParams(),
          status: BlocStatus.initial,
        )) {
    on<CalendarEvent>(
      (event, emit) {
        emit(state);
      },
    );
    on<GetSearchEvent>(_getSearchEventsHandler);

    on<GetSeasonsEvent>(_getSesonsEventsHandler);

    on<UpdateSearchParamsEvent>(_updateSearchParamsHandler);

    on<GetMoreSearchEvent>(_getMoreSearchEventsHandler);
  }
  Future<void> _getSearchEventsHandler(
      GetSearchEvent e, Emitter emitter) async {
    emitter(state.copyWith(
        status: BlocStatus.loading,
        searchedParams: e.params != null
            ? e.params!.copyWith(page: 1, size: 10)
            : SearchCalendarParams(page: 1, size: 10)));
    final failureOrSuccess = await _getSearchEvents(e.params != null
        ? e.params!.copyWith(page: 1, size: 10)
        : SearchCalendarParams(page: 1, size: 10));

    failureOrSuccess.fold((l) {
      if (l == NoDataFoundFailure())
        emitter(state.copyWith(status: BlocStatus.success, searchItems: []));
      else {
        emitter(
          state.copyWith(
              status: BlocStatus.failure,
              errorMessage: (l as ServerFailure).errorMessage),
        );
      }
    }, (r) {
      emitter(state.copyWith(
        status: BlocStatus.success,
        searchItems: r.items,
        errorMessage: "",
      ));
    });
  }

  Future<void> _getMoreSearchEventsHandler(
      GetMoreSearchEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      status: BlocStatus.loadMore,
    ));
    final failureOrSuccess = await _getSearchEvents(state.searchedParams);

    failureOrSuccess.fold((l) {
      if (l == NoDataFoundFailure())
        emitter(
          state.copyWith(status: BlocStatus.failure, errorMessage: ""),
        );
      else {
        emitter(
          state.copyWith(
              status: BlocStatus.failure,
              errorMessage: (l as ServerFailure).errorMessage),
        );
      }
    }, (r) {
      List<SearchCalendarItem>? items = state.searchItems ?? [];
      items.addAll(r.items ?? []);
      emitter(state.copyWith(
        status: BlocStatus.success,
        searchItems: items,
        searchedParams: state.searchedParams
            .copyWith(page: (state.searchedParams.page ?? 1) + 1),
        errorMessage: "",
      ));
      print("search items ${items.length}");
    });
  }

  Future<void> _getSesonsEventsHandler(
      GetSeasonsEvent e, Emitter emitter) async {
    if (state.seasonList?.isNotEmpty ?? false) return;

    emitter(state.copyWith(
      seasonStatus: BlocRequestStatus.submissionGetLoading,
    ));
    final failureOrSuccess = await _getCategory(EventsCategoryParams(key: 13));
    failureOrSuccess.fold((l) {
      emitter(
        state.copyWith(
          seasonStatus: BlocRequestStatus.submissionGetFailure,
        ),
      );
    }, (r) {
      emitter(state.copyWith(
        seasonStatus: BlocRequestStatus.submissionGetSuccess,
        seasonList: r.items,
        errorMessage: "",
      ));
    });
  }

  Future<void> _updateSearchParamsHandler(
      UpdateSearchParamsEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      fromDate: e.fromDate,
      toDate: e.toDate,
      searchKeyword: e.searchKeyword,
      selectedSeason: e.selectedSeason,
    ));
  }
}
