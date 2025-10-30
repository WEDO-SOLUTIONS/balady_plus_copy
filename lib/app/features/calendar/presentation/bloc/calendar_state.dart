import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/features/calendar/domain/entities/search_calendar/search_calendar_item.dart';
import 'package:balady_plus/app/features/events/domain/entities/events_category/events_category_item.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/search_calendar/calendar_details_response.dart';
import '../../domain/entities/search_calendar/search_calendar_params.dart';

class CalendarState extends Equatable {
  final List<SearchCalendarItem> searchItems;
  final BlocStatus status;
  final String? errorMessage;

  final BlocRequestStatus seasonStatus;
  final List<EventCategoryItem>? seasonList;
  final String? searchKeyword;

  final EventCategoryItem? selectedSeason;
  final DateTime? fromDate;
  final DateTime? toDate;

  final SearchCalendarParams searchedParams;
  final CalendarDetailsResponse? details;

  CalendarState({
    this.errorMessage,
    this.status = BlocStatus.initial,
    this.seasonStatus = BlocRequestStatus.initial,
    required this.searchedParams,
    this.seasonList,
    this.searchKeyword,
    this.selectedSeason,
    this.fromDate,
    this.toDate,
    this.details,
    required this.searchItems,
  });

  CalendarState copyWith(
      {final BlocStatus? status,
      final BlocRequestStatus? seasonStatus,
      final SearchCalendarParams? searchedParams,
      final List<SearchCalendarItem>? searchItems,
      final String? errorMessage,
      final List<EventCategoryItem>? seasonList,
      final String? searchKeyword,
      final EventCategoryItem? selectedSeason,
      final DateTime? fromDate,
      final DateTime? toDate,
      final CalendarDetailsResponse? details}) {
    return CalendarState(
        searchItems: searchItems ?? this.searchItems,
        status: status ?? this.status,
        searchedParams: searchedParams ?? this.searchedParams,
        errorMessage: errorMessage ?? this.errorMessage,
        seasonStatus: seasonStatus ?? this.seasonStatus,
        seasonList: seasonList ?? this.seasonList,
        searchKeyword: searchKeyword ?? this.searchKeyword,
        selectedSeason: selectedSeason ?? this.selectedSeason,
        fromDate: fromDate ?? this.fromDate,
        toDate: toDate ?? this.toDate,
        details: details ?? this.details);
  }

  @override
  List<Object?> get props => [
        searchItems,
        status,
        errorMessage,
        searchedParams,
        seasonStatus,
        selectedSeason,
        searchKeyword,
        toDate,
        fromDate,
        details
      ];
}
