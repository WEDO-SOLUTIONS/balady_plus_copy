import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/lifestyle_layers/providers/active_layers_tab.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_state.dart' as layers_state;
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/widgets/layers/layer_sliver_list.dart';
import 'package:sliver_tools/sliver_tools.dart';

class LayersSheetContent extends ConsumerWidget {
  final ValueChanged<layers_state.LayerType>? onIconTap;
  final Function() onClose;
  final Set<layers_state.LayerType> layerTapItems;

  const LayersSheetContent({required this.onIconTap, required this.onClose, this.layerTapItems = const {}, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(layersControlsProvider);
    final activeTab = ref.watch(activeLayersTabProvider);
    return SliverPadding(
      padding: const EdgeInsets.only(left: Spacing.$4x, right: Spacing.$4x, bottom: Spacing.$4x),
      sliver: MultiSliver(
        children: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: Spacing.$3x),
              child: Row(
                children: [
                  Text(
                    context.l10n.layersOnTheMap,
                    style: context.textStyles.h4SemiBold.copyWith(color: context.colors.foregroundDefault),
                  ),
                  const Spacer(),
                  AppButton.close(
                    onTap: () {
                      Metrics.logEventAdvanced(
                        MetricsConstants.layersKeys.exitIcon,
                        group: MetricsConstants.layersTag,
                        action: MetricAction.tap.toString(),
                      );
                      onClose();
                    },
                    color: context.colors.backgroundSurface5,
                    padding: EdgeInsets.zero,
                    innerPadding: const EdgeInsets.symmetric(horizontal: Spacing.$2x),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: Spacing.$3x),
              child: _LayersTabRow(
                active: activeTab,
                onSelected: (tab) => ref.read(activeLayersTabProvider.notifier).set(tab),
              ),
            ),
          ),
          // Two grids for "All layers" so base-map options (Default, Satellite)
          // occupy a row by themselves and overlays start on a fresh row —
          // matches the Figma macet for BE-243. Other tabs keep a single grid.
          if (activeTab == LayersTab.allLayers) ...[
            LayerSliverList(
              onIconTap: onIconTap,
              layerType: layers_state.LayerType.baseMaps,
              layersState: state,
              layerTapItems: layerTapItems,
            ),
            LayerSliverList(
              onIconTap: onIconTap,
              layerType: layers_state.LayerType.overlays,
              layersState: state,
              layerTapItems: layerTapItems,
            ),
          ] else
            LayerSliverList(
              onIconTap: onIconTap,
              layerType: switch (activeTab) {
                LayersTab.mapDetails => layers_state.LayerType.mapDetails,
                LayersTab.publicTransport => layers_state.LayerType.publicTransport,
                LayersTab.allLayers => layers_state.LayerType.v1, // unreachable; keeps the switch exhaustive.
              },
              layersState: state,
              layerTapItems: layerTapItems,
            ),
        ],
      ),
    );
  }
}

class _LayersTabRow extends StatelessWidget {
  const _LayersTabRow({required this.active, required this.onSelected});

  final LayersTab active;
  final ValueChanged<LayersTab> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final labels = <LayersTab, String>{
      LayersTab.allLayers: l10n.allLayers,
      LayersTab.mapDetails: l10n.mapDetails,
      LayersTab.publicTransport: l10n.publicTransport,
    };
    // Intrinsic width per chip + spaceBetween — chips size to their text and
    // spread across the row width. Matches Figma node 6194:9044.
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (final tab in LayersTab.values)
          _LayersTabChip(label: labels[tab]!, isSelected: tab == active, onTap: () => onSelected(tab)),
      ],
    );
  }
}

class _LayersTabChip extends StatelessWidget {
  const _LayersTabChip({required this.label, required this.isSelected, required this.onTap});

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Styling per Figma node 6194:9044: rectangular neutral button, 1px
    // borderDefault always present, fill flips to backgroundSurface5 on the
    // active tab. No accent border / accent text — selection is signalled
    // by fill, like an iOS segmented control.
    final colors = context.colors;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: Spacing.$3x),
        decoration: BoxDecoration(
          color: isSelected ? colors.backgroundSurface5 : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: colors.borderDefault),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textStyles.bodySmallMedium.copyWith(color: colors.foregroundDefault),
        ),
      ),
    );
  }
}
