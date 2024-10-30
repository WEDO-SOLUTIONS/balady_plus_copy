import 'package:mapness/shared/constants/advanced_metrics_constants.dart';

class SearchResponseTimeMetric {
  /// A value in milliseconds indicating how long it took to return search results.
  /// Example: 1000
  final int responseTime;

  /// Query used to search.
  /// Specifies the type of search (for example, search by address, by objects, by category).
  /// Example: "search by address"
  final String query;

  /// Text entered by the user in the search bar to analyze the frequency and types of queries.
  final String searchQuery;

  const SearchResponseTimeMetric({
    required this.responseTime,
    required this.query,
    required this.searchQuery,
  });

  SearchResponseTimeMetric copyWith({
    int? responseTime,
    String? query,
    String? searchQuery,
  }) =>
      SearchResponseTimeMetric(
        responseTime: responseTime ?? this.responseTime,
        query: query ?? this.query,
        searchQuery: searchQuery ?? this.searchQuery,
      );

  /// Convert the object to a Map
  Map<String, dynamic> toJson() => {
        AdvancedMetricsConstants.keys.searchResponseDuration: responseTime,
        AdvancedMetricsConstants.keys.searchQueryType: query,
        AdvancedMetricsConstants.keys.searchQueryValue: searchQuery,
      };

  @override
  String toString() =>
      '${AdvancedMetricsConstants.debugConsole}::${AdvancedMetricsConstants.searchDuration}: ResponseTime: $responseTime ms, query: $query, searchQuery: $searchQuery';
}
