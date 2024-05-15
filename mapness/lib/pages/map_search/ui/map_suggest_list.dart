import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/router.dart';
import 'package:mapness/app/routes/poi_map.dart';
import 'package:mapness/features/search/ui/suggest_item.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';

class MapSuggestList extends ConsumerWidget {
  const MapSuggestList({
    required this.suggest,
    super.key,
  });

  final SuggestResultMessage suggest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggests = suggest.suggests.whereType<SuggestMessage>().toList();

    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsetsDirectional.only(
        start: 16,
        bottom: 16,
      ),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => SuggestItem(
        suggest: suggests[index],
        onObjectTap: (object) {
          ref.read(urbiMetricsProvider.notifier).logEvent(
              'Search/Suggestion => Tap', {'object': object.id!.objectId});
          PoiMapRoute.open(ref.read(goRouterProvider), object.id!.objectId);
        },
      ),
      itemCount: suggests.length,
      separatorBuilder: (context, index) => const Padding(
        padding: EdgeInsetsDirectional.only(start: 52),
        child: Divider(),
      ),
    );
  }
}
