import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/landing/providers/search_by_rubrics.dart';
import 'package:mapness/app/routes/poi_map.dart';
import 'package:mapness/features/search/models/search_scope.dart';
import 'package:mapness/features/search/models/search_state.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/pages/map_search/ui/map_search_empty.dart';
import 'package:mapness/pages/map_search/ui/map_search_history.dart';
import 'package:mapness/pages/map_search/ui/map_search_results.dart';
import 'package:mapness/pages/map_search/ui/map_suggest_list.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:provider/provider.dart';

class MapSearchContent extends ConsumerWidget {
  const MapSearchContent({
    super.key,
    required this.scrollController,
  });

  final ScrollController scrollController;

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final scope = context.read<SearchScope>();
    final searchState = ref.watch(searchProvider(scope.value));

    final searchObjectManager = ref.watch(
      mapObjectManagerProvider(
        named: "searchManagerName",
      ).notifier,
    );

    ref.listen(searchByRubricsProvider, (previous, next) async {
      await searchObjectManager.removeAllMarkers();
      if (next != null) {
        List<Marker> markers = [];
        for (final markerInfo
            in (next.itemMarkerInfos ?? List<ItemMarkerInfoMessage>.empty())) {
          markers.add(
            Marker(
              id: markerInfo?.objectId?.objectId.toString() ??
                  context.l10n.invalid,
              onTap: () {
                PoiMapRoute.open(context, markerInfo.objectId!.objectId);
              },
              options: MarkerOptionsMessage(
                position: markerInfo!.geoPoint,
                icon: MarkerIconMessage(
                  path: "assets/icons/svg/ic_marker.svg",
                  width: 24,
                ),
              ),
            ),
          );
        }
        await searchObjectManager.addMarkers(markers);
        await ref
            .read(cameraPositionProvider.notifier)
            .animateToMarkers(markers);
      }
    });

    return searchState.map(
      empty: () => const SliverFillRemaining(
        child: SafeArea(
          top: false,
          child: MapSearchEmpty(),
        ),
      ),
      history: () => const SliverToBoxAdapter(
        child: SafeArea(
          top: false,
          child: MapSearchHistory(),
        ),
      ),
      suggest: (suggest) => SliverToBoxAdapter(
        child: Container(
          color: Colors.white,
          child: SafeArea(
            top: false,
            child: MapSuggestList(
              suggest: suggest,
            ),
          ),
        ),
      ),
      results: (results) => SliverToBoxAdapter(
        child: SafeArea(
          top: false,
          child: MapSearchResults(
            results: results,
            scrollController: scrollController,
          ),
        ),
      ),
    );
  }
}
