import 'package:mapness/entities/metrics/events/metrics_event.dart';
import 'package:mapness/entities/metrics/metrics_data_source.dart';
import 'package:mapness/features/search/providers/search_box_click.dart';
import 'package:mapness/shared/providers/metrics/sources/byte_dance_metrics_data_source.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'metrics_route_flow_manager.dart';

part 'metrics_repository.g.dart';

@Riverpod(keepAlive: true)
class MetricsRepository extends _$MetricsRepository {
  late final List<MetricsDataSource> _dataSources;

  @override
  void build() {
    _dataSources = [
      ByteDanceMetricsDataSource(),
    ];
  }

  Future<void> sendEvent(MetricsEvent event) => Future.wait(_dataSources.map((e) => e.sendEvent(event)));

  Future<void> sendFavoriteAddEvent({
    required MetricsFavouriteType favoriteType,
    required String poiAddress,
    required String poiId,
    required String poiType,
    required String poiName,
    required double poiDistance,
  }) => _sendByteDanceEvent(
    (eventSource) => MetricsEvent.favoriteAdd(
      eventSource: eventSource,
      favoriteType: favoriteType,
      poiAddress: poiAddress,
      poiId: poiId,
      poiType: poiType,
      poiName: poiName,
      poiDistance: poiDistance,
    ),
  );

  Future<void> sendQuickSearchClickEvent(String searchText) => _sendByteDanceEvent(
    (eventSource) => MetricsEvent.quickSearchClick(eventSource: eventSource, searchText: searchText),
  );

  Future<void> sendSearchBoxClickEvent() async {
    final lastSearchEvent = ref.read(searchBoxClickProvider);
    ref.read(searchBoxClickProvider.notifier).update(DateTime.now());
    final isFirstClick =
        lastSearchEvent == null || DateTime.now().difference(lastSearchEvent).abs() > const Duration(minutes: 5);
    _sendByteDanceEvent(
      (eventSource) => MetricsEvent.searchBoxClick(eventSource: eventSource, isFirstClick: isFirstClick),
    );
  }

  Future<void> sendSearchBoxInputEvent({
    required MetricsSearchBoxInputOperationType operationType,
    required String inputText,
  }) async {
    _sendByteDanceEvent(
      (eventSource) => MetricsEvent.searchBoxInput(
        eventSource: eventSource,
        operationType: operationType,
        inputText: inputText,
      ),
    );
  }

  Future<void> sendSearchButtonClickEvent({
    required String searchText,
    MetricsSearchButtonClickTriggerMethod triggerMethod = MetricsSearchButtonClickTriggerMethod.keyboard,
  }) async {
    _sendByteDanceEvent(
      (eventSource) => MetricsEvent.searchButtonClick(
        eventSource: eventSource,
        triggerMethod: triggerMethod,
        searchText: searchText,
      ),
    );
  }

  Future<void> sendSuggestionExposureEvent({
    required Map<String, String> searchParam,
    required String suggestionSessionId,
    required String requestId,
    required String searchText,
    required MetricsSuggestionExposureSuggestionType suggestionType,
    required String suggestionName,
    required int suggestionRank,
    String? suggestionPoiId,
    String? suggestionPoiAddress,
    String? suggestionDistance,
  }) async {
    _sendByteDanceEvent(
      (eventSource) => MetricsEvent.suggestionExposure(
        eventSource: eventSource,
        searchParam: searchParam,
        suggestionSessionId: suggestionSessionId,
        requestId: requestId,
        searchText: searchText,
        suggestionType: suggestionType,
        suggestionName: suggestionName,
        suggestionRank: suggestionRank,
        suggestionPoiId: suggestionPoiId,
        suggestionPoiAddress: suggestionPoiAddress,
        suggestionDistance: suggestionDistance,
      ),
    );
  }

  Future<void> sendSuggestionClickEvent({
    required String suggestionSessionId,
    required String requestId,
    required String searchText,
    required MetricsSuggestionExposureSuggestionType suggestionType,
    required String suggestionName,
    required int suggestionRank,
    String? poiId,
    String? poiType,
    String? suggestionPoiAddress,
    String? poiDistance,
    String? poiName,
  }) async {
    _sendByteDanceEvent(
      (eventSource) => MetricsEvent.suggestionClick(
        eventSource: eventSource,
        suggestionSessionId: suggestionSessionId,
        requestId: requestId,
        searchText: searchText,
        suggestionType: suggestionType,
        suggestionName: suggestionName,
        suggestionRank: suggestionRank,
        poiId: poiId,
        poiType: poiType,
        suggestionPoiAddress: suggestionPoiAddress,
        poiDistance: poiDistance,
        poiName: poiName,
      ),
    );
  }

  Future<void> sendSearchResultsExposureEvent({
    required Map<String, dynamic> searchParam,
    required String searchSessionId,
    required String requestId,
    required String searchText,
    required MetricsSearchResultsExposureSearchType searchType,
    required String poiId,
    required String poiAddress,
    required double poiDistance,
    required String poiType,
    required String poiName,
    required int poiRank,
  }) async {
    _sendByteDanceEvent(
      (eventSource) => MetricsEvent.searchResultsExposure(
        eventSource: eventSource,
        searchParam: searchParam,
        searchSessionId: searchSessionId,
        requestId: requestId,
        searchText: searchText,
        searchType: searchType,
        poiId: poiId,
        poiAddress: poiAddress,
        poiDistance: poiDistance,
        poiType: poiType,
        poiName: poiName,
        poiRank: poiRank,
      ),
    );
  }

  Future<void> sendSearchResultsClickEvent({
    required String searchSessionId,
    required String requestId,
    required String searchText,
    required MetricsSearchResultsClickActionType clickAction,
    required String poiId,
    required int poiRank,
    required String poiAddress,
    required String poiType,
    required String poiName,
    required double poiDistance,
  }) async {
    _sendByteDanceEvent(
      (eventSource) => MetricsEvent.searchResultsClick(
        eventSource: eventSource,
        searchSessionId: searchSessionId,
        requestId: requestId,
        searchText: searchText,
        clickAction: clickAction,
        poiId: poiId,
        poiRank: poiRank,
        poiAddress: poiAddress,
        poiType: poiType,
        poiName: poiName,
        poiDistance: poiDistance,
      ),
    );
  }

  Future<void> _sendByteDanceEvent(MetricsEvent Function(MetricsByteDanceEventSource eventSource) mapEvent) async {
    final metricsRouteFlow = ref.read(metricsRouteFlowManagerProvider);
    final eventSource = _mapByteDanceEventSource(metricsRouteFlow);

    if (eventSource == null) {
      return logger.log('failed to get eventSource', logLevel: MapnessLogLevel.error);
    }

    await sendEvent(mapEvent(eventSource));
  }

  // ignore: prefer_expression_function_bodies
  MetricsByteDanceEventSource? _mapByteDanceEventSource(MetricsRouteFlow metricsRouteFlow) {
    // TODO(metrics): it is hard to determine which flow is going so we need to take care of it afterwards
    return MetricsByteDanceEventSource.mapMainPage;
    // if (metricsRouteFlow.containsRouteSequence(MetricsRouteFlowSequence.mapMainPage)) {
    //   return MetricsFavouriteQuickSearchClickEventSource.mapMainPage;
    // }
    // if (metricsRouteFlow.containsRouteSequence(MetricsRouteFlowSequence.mapDirectionPathChanging)) {
    //   return MetricsFavouriteQuickSearchClickEventSource.mapDirectionPathChanging;
    // }
    //
    // return null;
  }
}
