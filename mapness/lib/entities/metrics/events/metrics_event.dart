// ignore_for_file: always_put_required_named_parameters_first
import 'dart:collection';

import 'package:auto_route/auto_route.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';

part '_enums.dart';
part '_route_flow.dart';
part '_route_flow_sequence.dart';
part 'metrics_event.freezed.dart';

@freezed
sealed class MetricsEvent with _$MetricsEvent {
  const MetricsEvent._();

  const factory MetricsEvent.favoriteAdd({
    required String eventSource,
    required MetricsFavouriteType favoriteType,
    required String poiAddress,
    required String poiId,
    required String poiType,
    required String poiName,
    required double poiDistance,
  }) = MetricsEventFavouriteAdd;

  const factory MetricsEvent.quickSearchClick({
    required MetricsFavouriteQuickSearchClickEventSource eventSource,
    required String searchText,
  }) = MetricsEventQuickSearchClick;

  const factory MetricsEvent.searchBoxClick({
    required String eventSource,

    /// In user behavior tracking, a first search is
    /// defined as the first search a user performs
    /// in the search box after opening the app. If
    /// the user exits the app or remains inactive
    /// for 5 minutes, the next search will be
    /// considered a new search.
    required bool isFirstClick,
  }) = MetricsEventSearchBoxClick;

  const factory MetricsEvent.searchBoxInput({
    required MetricsSearchBoxInputOperationType operationType,
    required String inputText,
  }) = MetricsEventSearchBoxInput;

  const factory MetricsEvent.searchButtonClick({
    required String eventSource,
    required MetricsSearchButtonClickTriggerMethod triggerMethod,
    required String searchText,
  }) = MetricsEventSearchButtonClick;

  const factory MetricsEvent.suggestionExposure({
    required Map<String, dynamic> searchParam,

    /// [suggestionSessionId] is used to link suggestion_exposure
    /// and suggestion_click. It should be generated each time
    /// before calling the Suggestion API.
    required String suggestionSessionId,

    // todo needed?
    required String requestId,
    required String searchText,
    required MetricsSuggestionExposureSuggestionType suggestionType,

    /// if [suggestionType] is .poi, this is a POI id
    String? suggestionPoiId,

    /// if [suggestionType] is .poi, this is a POI address
    String? suggestionPoiAddress,

    /// if [suggestionType] is .poi, this is the POI distance from the user's
    /// current latitude and longitude
    String? suggestionDistance,
    required String suggestionName,
    required int suggestionRank,
  }) = MetricsEventSuggestionExposure;

  const factory MetricsEvent.suggestionClick({
    required String eventSource,

    /// [suggestionSessionId] generated in the suggestion_exposure event
    required String suggestionSessionId,
    // todo needed?
    required String requestId,
    required String searchText,
    required MetricsSuggestionExposureSuggestionType suggestionType,
    required String suggestionName,

    /// if [suggestionType] is .poi, this is a POI id
    String? poiId,
    required int suggestionRank,

    /// if [suggestionType] is .poi, this is a POI type
    String? poiType,

    /// if [suggestionType] is .poi, this is a POI address
    String? suggestionPoiAddress,

    /// If user clicked the specific POI,the distance from
    /// the user's current location is calculated in
    /// kilometers (km) with two-decimal precision. A
    /// minimum distance threshold of 10 meters (0.01
    /// km) is applied, otherwise, omit this field.
    String? poiDistance,

    /// If user clicked the specific POI,the POI name,otherwise, omit this field.
    String? poiName,
  }) = MetricsEventSuggestionClick;

  const factory MetricsEvent.searchResultsExposure({
    required Map<String, dynamic> searchParam,

    /// [searchSessionId] is used to link
    /// search_results_exposure and search_results_click.
    /// It is generated whenever a new search is initiated via
    /// the Places API (but not for pagination). In other
    /// words, a new search_session_id is created whenever
    /// the page number is 1. If the page number is 2 or
    /// higher, it is considered a pagination request, and no
    /// new search_session_id is generated.
    required String searchSessionId,
    // todo needed?
    required String requestId,
    required String searchText,
    required String eventSource,
    required MetricsSearchResultsExposureSearchType searchType,
    required String poiId,
    required String poiAddress,
    required double poiDistance,
    required String poiType,
    required String poiName,
    required int poiRank,
  }) = MetricsEventSearchResultsExposure;

  const factory MetricsEvent.searchResultsClick({
    /// [searchSessionId] generated in the search_results_exposure event
    required String searchSessionId,
    // todo needed?
    required String requestId,
    required String searchText,
    required String clickAction,
    required String eventSource,
    required String poiId,
    required int poiRank,
    required String poiAddress,
    required String poiType,
    required String poiName,
    required double poiDistance,
  }) = MetricsEventSearchResultsClick;
}
