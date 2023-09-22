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

  final BlocStatus cityStatus;
  final BlocStatus seasonStatus;
  final BlocStatus categoryStatus;
  final BlocStatus audinceStatus;

  final List<EventCategoryItem>? citiesList;
  final List<EventCategoryItem>? seasonList;
  final List<EventCategoryItem>? categoryList;
  final List<EventCategoryItem>? audinceList;
  final String? searchKeyword;

  final EventCategoryItem? selectedCity;
  final EventCategoryItem? selectedSeason;
  final EventCategoryItem? selectedCategory;
  final EventCategoryItem? selectedAudince;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String? sortBy;

  final SearchEventsParams searchedParams;

  EventsState(
      {this.errorMessage,
      required this.eventDetails,
      this.status = BlocStatus.initial,
      this.cityStatus = BlocStatus.initial,
      this.seasonStatus = BlocStatus.initial,
      this.categoryStatus = BlocStatus.initial,
      this.audinceStatus = BlocStatus.initial,
      required this.searchedParams,
      this.citiesList,
      this.seasonList,
      this.categoryList,
      this.audinceList,
      this.searchKeyword,
      this.selectedCity,
      this.selectedSeason,
      this.selectedCategory,
      this.selectedAudince,
      this.fromDate,
      this.toDate,
      required this.searchItems,
      this.sortBy});

  EventsState copyWith(
      {final BlocStatus? status,
      final BlocStatus? cityStatus,
      final BlocStatus? seasonStatus,
      final BlocStatus? categoryStatus,
      final BlocStatus? audinceStatus,
      final SearchEventsParams? searchedParams,
      final List<SearchEventsItem>? searchItems,
      final EventDetailsResponse? eventDetails,
      final String? errorMessage,
      final List<EventCategoryItem>? citiesList,
      final List<EventCategoryItem>? seasonList,
      final List<EventCategoryItem>? categoryList,
      final List<EventCategoryItem>? audinceList,
      final String? searchKeyword,
      final EventCategoryItem? selectedCity,
      final EventCategoryItem? selectedSeason,
      final EventCategoryItem? selectedCategory,
      final EventCategoryItem? selectedAudince,
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
        citiesList: citiesList ?? this.citiesList,
        seasonList: seasonList ?? this.seasonList,
        categoryList: categoryList ?? this.categoryList,
        audinceList: audinceList ?? this.audinceList,
        searchKeyword: searchKeyword ?? this.searchKeyword,
        selectedCity: selectedCity ?? this.selectedCity,
        selectedSeason: selectedSeason ?? this.selectedSeason,
        selectedCategory: selectedCategory ?? this.selectedCategory,
        selectedAudince: selectedAudince ?? this.selectedAudince,
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
        selectedAudince,
        selectedCategory,
        selectedSeason,
        selectedCity,
        searchKeyword,
        audinceList,
        categoryList,
        toDate,
        fromDate,
        sortBy
      ];
}
