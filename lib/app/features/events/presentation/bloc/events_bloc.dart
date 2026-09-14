import 'package:balady_plus/app/core/errors/errors_exports.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/events/domain/entities/events_category/events_category_params.dart';
import 'package:balady_plus/app/features/events/domain/entities/events_details/event_details_item.dart';
import 'package:balady_plus/app/features/events/domain/entities/events_details/event_details_params.dart';
import 'package:balady_plus/app/features/events/domain/entities/search_events/search_events_params.dart';
import 'package:balady_plus/app/features/events/domain/usecase/get_search_events.dart';
import 'package:balady_plus/app/features/events/domain/usecase/grt_event_details.dart';
import 'package:balady_plus/app/features/events/presentation/bloc/events_event.dart';
import 'package:balady_plus/app/features/events/presentation/bloc/events_state.dart';
import 'package:bloc/bloc.dart';

import '../../../../core/dependency_injection/injection_container.dart';
import '../../domain/entities/search_events/search_events_item.dart';
import '../../domain/usecase/get_category_event.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final GetSearchEvents _getSearchEvents;
  final GetEventDetails _getEventDetails;
  final GetCategory _getCategory;
  EventsBloc()
    : _getSearchEvents = GetSearchEvents(repository: sl()),
      _getEventDetails = GetEventDetails(repository: sl()),
      _getCategory = GetCategory(repository: sl()),
      super(
        EventsState(
          eventDetails: EventDetailsResponse(),
          searchItems: [],
          searchedParams: SearchEventsParams(),
          status: BlocStatus.initial,
        ),
      ) {
    on<EventsEvent>((event, emit) {
      emit(state);
    });
    on<GetSearchEvent>(_getSearchEventsHandler);
    on<GetEventsDetails>(_getEventsDetailsHandler);
    on<GetCitiesEvent>(_getCitiesEventsHandler);
    on<GetCategoriesEvent>(_getCategoriesEventsHandler);

    on<GetAudienceEvent>(_getAudinceEventsHandler);
    on<GetSeasonsEvent>(_getSesonsEventsHandler);
    on<GetFeesEvent>(_getFeesEventsHandler);

    on<UpdateSearchParamsEvent>(_updateSearchParamsHandler);

    on<GetMoreSearchEvent>(_getMoreSearchEventsHandler);
  }
  Future<void> _getSearchEventsHandler(GetSearchEvent e, Emitter emitter) async {
    emitter(
      state.copyWith(
        status: BlocStatus.loading,
        searchedParams: e.params != null
            ? e.params!.copyWith(page: 1, size: 10)
            : SearchEventsParams(page: 1, size: 10),
      ),
    );
    final failureOrSuccess = await _getSearchEvents(
      e.params != null ? e.params!.copyWith(page: 1, size: 10) : SearchEventsParams(page: 1, size: 10),
    );

    failureOrSuccess.fold(
      (l) {
        if (l == NoDataFoundFailure()) {
          emitter(state.copyWith(status: BlocStatus.success, searchItems: []));
        } else {
          emitter(state.copyWith(status: BlocStatus.retry, errorMessage: (l as ServerFailure).errorMessage));
        }
      },
      (r) {
        emitter(
          state.copyWith(
            status: BlocStatus.success,
            searchItems: r.items,
            searchedParams: state.searchedParams.copyWith(page: (state.searchedParams.page ?? 1) + 1),
            errorMessage: "",
          ),
        );
      },
    );
  }

  Future<void> _getMoreSearchEventsHandler(GetMoreSearchEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loadMore));
    final failureOrSuccess = await _getSearchEvents(state.searchedParams);

    failureOrSuccess.fold(
      (l) {
        if (l == NoDataFoundFailure()) {
          emitter(state.copyWith(status: BlocStatus.failure, errorMessage: ""));
        } else {
          emitter(state.copyWith(status: BlocStatus.failure, errorMessage: (l as ServerFailure).errorMessage));
        }
      },
      (r) {
        List<SearchEventsItem>? items = state.searchItems;
        items.addAll(r.items ?? []);
        emitter(
          state.copyWith(
            status: BlocStatus.success,
            searchItems: items,
            searchedParams: state.searchedParams.copyWith(page: (state.searchedParams.page ?? 1) + 1),
            errorMessage: "",
          ),
        );
      },
    );
  }

  Future<void> _getEventsDetailsHandler(GetEventsDetails e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    final failureOrSuccess = await _getEventDetails(EventDetailsParams(key: e.id));
    failureOrSuccess.fold(
      (l) {
        emitter(state.copyWith(status: BlocStatus.failure));
      },
      (r) {
        emitter(state.copyWith(status: BlocStatus.success, eventDetails: r, errorMessage: ""));
      },
    );
  }

  Future<void> _getCitiesEventsHandler(GetCitiesEvent e, Emitter emitter) async {
    if (state.citiesList?.isNotEmpty ?? false) return;

    emitter(state.copyWith(cityStatus: BlocRequestStatus.submissionGetLoading));
    final failureOrSuccess = await _getCategory(EventsCategoryParams(key: 3));
    failureOrSuccess.fold(
      (l) {
        emitter(
          state.copyWith(
            cityStatus: (l as ServerFailure).errorCode == "2"
                ? BlocRequestStatus.submissionGetSuccess
                : BlocRequestStatus.submissionGetFailure,
            citiesList: [],
          ),
        );
      },
      (r) {
        emitter(
          state.copyWith(cityStatus: BlocRequestStatus.submissionGetSuccess, citiesList: r.items, errorMessage: ""),
        );
      },
    );
  }

  Future<void> _getSesonsEventsHandler(GetSeasonsEvent e, Emitter emitter) async {
    if (state.seasonList?.isNotEmpty ?? false) return;

    emitter(state.copyWith(seasonStatus: BlocRequestStatus.submissionGetLoading));
    final failureOrSuccess = await _getCategory(EventsCategoryParams(key: 1));
    failureOrSuccess.fold(
      (l) {
        emitter(
          state.copyWith(
            seasonStatus: (l as ServerFailure).errorCode == "2"
                ? BlocRequestStatus.submissionGetSuccess
                : BlocRequestStatus.submissionGetFailure,
            seasonList: [],
          ),
        );
      },
      (r) {
        emitter(
          state.copyWith(seasonStatus: BlocRequestStatus.submissionGetSuccess, seasonList: r.items, errorMessage: ""),
        );
      },
    );
  }

  Future<void> _getFeesEventsHandler(GetFeesEvent e, Emitter emitter) async {
    if (state.feesList?.isNotEmpty ?? false) return;

    emitter(state.copyWith(feesStatus: BlocRequestStatus.submissionGetLoading));
    final failureOrSuccess = await _getCategory(EventsCategoryParams(key: 6));
    failureOrSuccess.fold(
      (l) {
        emitter(
          state.copyWith(
            feesStatus: (l as ServerFailure).errorCode == "2"
                ? BlocRequestStatus.submissionGetSuccess
                : BlocRequestStatus.submissionGetFailure,
            feesList: [],
          ),
        );
      },
      (r) {
        emitter(
          state.copyWith(feesStatus: BlocRequestStatus.submissionGetSuccess, feesList: r.items, errorMessage: ""),
        );
      },
    );
  }

  Future<void> _getAudinceEventsHandler(GetAudienceEvent e, Emitter emitter) async {
    if (state.audinceList?.isNotEmpty ?? false) return;

    emitter(state.copyWith(audinceStatus: BlocRequestStatus.submissionGetLoading));
    final failureOrSuccess = await _getCategory(EventsCategoryParams(key: 5));
    failureOrSuccess.fold(
      (l) {
        emitter(
          state.copyWith(
            audinceStatus: (l as ServerFailure).errorCode == "2"
                ? BlocRequestStatus.submissionGetSuccess
                : BlocRequestStatus.submissionGetFailure,
            audinceList: [],
          ),
        );
      },
      (r) {
        emitter(
          state.copyWith(audinceStatus: BlocRequestStatus.submissionGetSuccess, audinceList: r.items, errorMessage: ""),
        );
      },
    );
  }

  Future<void> _getCategoriesEventsHandler(GetCategoriesEvent e, Emitter emitter) async {
    if (state.categoryList?.isNotEmpty ?? false) return;
    emitter(state.copyWith(categoryStatus: BlocRequestStatus.submissionGetLoading));
    final failureOrSuccess = await _getCategory(EventsCategoryParams(key: 2));
    failureOrSuccess.fold(
      (l) {
        emitter(
          state.copyWith(
            categoryStatus: (l as ServerFailure).errorCode == "2"
                ? BlocRequestStatus.submissionGetSuccess
                : BlocRequestStatus.submissionGetFailure,
            categoryList: [],
          ),
        );
      },
      (r) {
        emitter(
          state.copyWith(
            categoryStatus: BlocRequestStatus.submissionGetSuccess,
            categoryList: r.items,
            errorMessage: "",
          ),
        );
      },
    );
  }

  Future<void> _updateSearchParamsHandler(UpdateSearchParamsEvent e, Emitter emitter) async {
    emitter(
      state.copyWith(
        fromDate: e.fromDate,
        toDate: e.toDate,
        searchKeyword: e.searchKeyword,
        selectedAudince: e.selectedAudince,
        selectedCategory: e.selectedCategory,
        selectedCity: e.selectedCity,
        selectedSeason: e.selectedSeason,
        sortBy: e.sortBy,
      ),
    );
  }
}
