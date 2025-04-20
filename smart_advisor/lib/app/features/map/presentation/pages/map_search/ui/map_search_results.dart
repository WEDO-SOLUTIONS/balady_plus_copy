/*import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/router.dart';
import 'package:mapness/app/routes/poi_map.dart';
import 'package:mapness/features/search/ui/search_results.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/widgets/search/ui/search_item.dart';

class MapSearchResults extends ConsumerWidget {
  const MapSearchResults({
    required this.results,
    required this.scrollController,
    super.key,
  });

  final SearchResultMessage results;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(appLanguageProvider);
    final myLocation = ref.watch(locationProvider);
    return SearchResults(
      results: results,
      scrollController: scrollController,
      loaderBuilder: (context) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Center(
          child: CircularProgressIndicator(
            color: Colors.black,
          ),
        ),
      ),
      itemBuilder: (context, item) => SearchItem(
        result: item,
        language: language,
        myLocation:
            myLocation == null ? null : GeoPointMessage(latitude: myLocation.latitude, longitude: myLocation.longitude),
        onTap: () {
          Metrics.logEventAdvanced(
            MetricsConstants.searchKeys.searchResult,
            group: MetricsConstants.searchTag,
            action: MetricAction.tap.toString(),
            props: {
              'object': item.id!.objectId,
            },
          );

          WidgetsBinding.instance.addPostFrameCallback((_) {
            PoiMapRoute.open(
              ref.read(goRouterProvider),
              item.id!.objectId,
              zoom: 18,
            );
          });
        },
      ),
    );
  }
}
*/