/*import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/router.dart';
import 'package:mapness/app/routes/poi_map.dart';
import 'package:mapness/features/search/ui/suggest_item.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/location.dart';

class MapSuggestList extends ConsumerWidget {
  const MapSuggestList({
    required this.suggest,
    super.key,
  });

  final SuggestResultMessage suggest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggests = suggest.suggests.whereType<SuggestMessage>().toList();
    final myLocation = ref.watch(locationProvider);
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => SuggestItem(
        suggest: suggests[index],
        myLocation:
            myLocation == null ? null : GeoPointMessage(latitude: myLocation.latitude, longitude: myLocation.longitude),
        isLast: index == suggests.length - 1,
        onObjectTap: (object) {
          Metrics.logEventAdvanced(
            MetricsConstants.searchKeys.suggestion,
            group: MetricsConstants.searchTag,
            action: MetricAction.tap.toString(),
            props: {
              'object': object.id!.objectId,
            },
          );

          PoiMapRoute.open(
            ref.read(goRouterProvider),
            object.id!.objectId,
            zoom: 18,
          );
        },
      ),
      itemCount: suggests.length,
    );
  }
}
*/