import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/features/events/domain/entities/events_details/event_details_item.dart';
import 'package:balady_plus/app/features/events/domain/entities/search_events/search_events_item.dart';
import 'package:balady_plus/app/features/events/domain/entities/events_category/events_category_item.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/search_events/search_events_params.dart';

class EventsState extends Equatable {
  final List<SearchEventsItem> searchItems;

  final EventDetailsResponse eventDetails;
  final BlocStatus status;
  final String? errorMessage;

  final BlocRequestStatus cityStatus;
  final BlocRequestStatus seasonStatus;
  final BlocRequestStatus categoryStatus;
  final BlocRequestStatus audinceStatus;
  final BlocRequestStatus feesStatus;
  final List<EventCategoryItem>? citiesList;
  final List<EventCategoryItem>? seasonList;
  final List<EventCategoryItem>? categoryList;
  final List<EventCategoryItem>? audinceList;
  final List<EventCategoryItem>? feesList;
  final String? searchKeyword;

  final EventCategoryItem? selectedCity;
  final EventCategoryItem? selectedSeason;
  final EventCategoryItem? selectedCategory;
  final EventCategoryItem? selectedAudince;
  final EventCategoryItem? selectedFees;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String? sortBy;

  final SearchEventsParams searchedParams;

  const EventsState({
    this.errorMessage,
    required this.eventDetails,
    this.status = BlocStatus.initial,
    this.cityStatus = BlocRequestStatus.initial,
    this.seasonStatus = BlocRequestStatus.initial,
    this.categoryStatus = BlocRequestStatus.initial,
    this.audinceStatus = BlocRequestStatus.initial,
    this.feesStatus = BlocRequestStatus.initial,
    required this.searchedParams,
    this.citiesList,
    this.seasonList,
    this.categoryList,
    this.audinceList,
    this.feesList,
    this.searchKeyword,
    this.selectedCity,
    this.selectedSeason,
    this.selectedCategory,
    this.selectedAudince,
    this.selectedFees,
    this.fromDate,
    this.toDate,
    required this.searchItems,
    this.sortBy,
  });

  EventsState copyWith(
      {final BlocStatus? status,
      final BlocRequestStatus? cityStatus,
      final BlocRequestStatus? seasonStatus,
      final BlocRequestStatus? categoryStatus,
      final BlocRequestStatus? audinceStatus,
      final BlocRequestStatus? feesStatus,
      final SearchEventsParams? searchedParams,
      final List<SearchEventsItem>? searchItems,
      final EventDetailsResponse? eventDetails,
      final String? errorMessage,
      final List<EventCategoryItem>? citiesList,
      final List<EventCategoryItem>? seasonList,
      final List<EventCategoryItem>? categoryList,
      final List<EventCategoryItem>? audinceList,
      final List<EventCategoryItem>? feesList,
      final String? searchKeyword,
      final EventCategoryItem? selectedCity,
      final EventCategoryItem? selectedSeason,
      final EventCategoryItem? selectedCategory,
      final EventCategoryItem? selectedAudince,
      final EventCategoryItem? selectedFees,
      final DateTime? fromDate,
      final DateTime? toDate,
      final String? sortBy}) {
    return EventsState(
        searchItems: searchItems ?? this.searchItems,
        status: status ?? this.status,
        searchedParams: searchedParams ?? this.searchedParams,
        errorMessage: errorMessage ?? this.errorMessage,
        eventDetails: eventDetails ?? this.eventDetails,
        cityStatus: cityStatus ?? this.cityStatus,
        seasonStatus: seasonStatus ?? this.seasonStatus,
        categoryStatus: categoryStatus ?? this.categoryStatus,
        audinceStatus: audinceStatus ?? this.audinceStatus,
        feesStatus: feesStatus ?? this.feesStatus,
        citiesList: citiesList ?? this.citiesList,
        seasonList: seasonList ?? this.seasonList,
        feesList: feesList ?? this.feesList,
        categoryList: categoryList ?? this.categoryList,
        audinceList: audinceList ?? this.audinceList,
        searchKeyword: searchKeyword ?? this.searchKeyword,
        selectedCity: selectedCity ?? this.selectedCity,
        selectedSeason: selectedSeason ?? this.selectedSeason,
        selectedCategory: selectedCategory ?? this.selectedCategory,
        selectedAudince: selectedAudince ?? this.selectedAudince,
        selectedFees: selectedFees ?? this.selectedFees,
        fromDate: fromDate ?? this.fromDate,
        sortBy: sortBy ?? this.sortBy,
        toDate: toDate ?? this.toDate);
  }

  @override
  List<Object?> get props => [
        searchItems,
        status,
        errorMessage,
        searchedParams,
        eventDetails,
        audinceStatus,
        categoryStatus,
        seasonStatus,
        cityStatus,
        feesStatus,
        selectedAudince,
        selectedCategory,
        selectedSeason,
        selectedCity,
        selectedFees,
        searchKeyword,
        audinceList,
        categoryList,
        feesList,
        toDate,
        fromDate,
        sortBy
      ];
}
