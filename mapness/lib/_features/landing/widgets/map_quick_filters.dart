import 'package:balady_plus/app/core/utils/debouncer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/landing/providers/quick_filter_request_source_screen.dart';
import 'package:mapness/_features/landing/providers/search_by_rubrics.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/app/routes/favourites.dart';
import 'package:mapness/entities/quick_filters/quick_filter.dart';
import 'package:mapness/features/quick_filters/ui/quick_filters.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/shared/lib/search/compute_camera_position.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/widgets/quick_filters/models/filter_item.dart';

class MapQuickFilters extends ConsumerStatefulWidget {
  const MapQuickFilters({
    required this.id,
    super.key,
    this.customFilters,
    this.onCustomTap,
    this.forMap = false,
    this.isDashboard = false,
  });

  final List<FilterItem>? customFilters;
  final void Function(FilterItem)? onCustomTap;
  final bool forMap;
  final QuickFilterScreen id;
  final bool isDashboard;

  @override
  ConsumerState<MapQuickFilters> createState() => _MapQuickFiltersState();
}

class _MapQuickFiltersState extends ConsumerState<MapQuickFilters> {
  final _debouncer = Debouncer(milliseconds: 400);

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedQuickFilter = ref.watch(searchByRubricsQueryProvider);
    final settings = MapObjectManagerSettings.search();
    final searchObjectManager = ref.watch(
      mapObjectManagerProvider(
        named: settings.name,
        layerId: settings.layerId,
      ).notifier,
    );
    ref.listen(searchByRubricsProvider, (previous, next) async {
      if (!widget.forMap) {
        return;
      }
      final value = next.unwrapPrevious().value;
      if (value != null) {
        _debouncer.run(() async {
          await computeCameraPosition(
            value,
            ref.read(cameraPositionProvider),
            ref.read(cameraPositionProvider.notifier).animateTo,
          );
        });
      }
    });

    return QuickFilters(
      id: widget.id,
      isDashboard: widget.isDashboard,
      onFavouritesBookmarkTap: () => CommonFunctions.authOrOpen(
        context,
        callback: () {
          if (!mounted) {
            return;
          }
          Metrics.logEventAdvanced(
            MetricsConstants.exploreKeys.bookmarkIcon,
            action: MetricAction.tap.name,
            group: MetricsConstants.exploreTag,
          );

          const FavouritesRoute().push(context);
        },
      ),
      onQuickFilterTap: (quickFilter) {
        _debouncer.run(
          () {
            final isSame = quickFilter.type == selectedQuickFilter?.type;
            if (isSame) {
              ref.read(searchByRubricsQueryProvider.notifier).update(null);
              searchObjectManager.removeAllMarkers();
            } else {
              // TODO(Sergei): we should call removeAllMarkers() because quick filter updating in sdk is slow,
              // remove this when quick filters performance will be fixed
              searchObjectManager.removeAllMarkers();
              ref.read(layersControlsProvider.notifier).disable();
              ref.read(quickFiltersRequestSourceScreenProvider.notifier).setSourceScreen(widget.id);
              ref.read(searchByRubricsQueryProvider.notifier).update(quickFilter);
            }
            Metrics.logEventAdvanced(
              MetricsConstants.exploreKeys.quickFilter,
              action: MetricAction.tap.name,
              group: MetricsConstants.exploreTag,
              props: {
                'filter': quickFilter.title,
                'toggle_state': isSame,
              },
            );
          },
        );
      },
      onFavouritesTap: () {
        _debouncer.run(() {
          Metrics.logEventAdvanced(
            MetricsConstants.exploreKeys.bookmarkIcon,
            action: MetricAction.tap.name,
            group: MetricsConstants.exploreTag,
          );

          ref.read(searchByRubricsQueryProvider.notifier).update(null);
          searchObjectManager.removeAllMarkers();
        });
      },
      selectedQuickFilter: selectedQuickFilter,
      customFilters: widget.customFilters,
      onCustomTap: widget.onCustomTap,
      padding: widget.forMap ? const EdgeInsets.symmetric(horizontal: 12) : const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}
