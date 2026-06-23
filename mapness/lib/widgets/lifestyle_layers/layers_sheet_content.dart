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

  List<layers_state.LayerType> _layersForTab(LayersTab tab) => switch (tab) {
    LayersTab.allLayers => layers_state.LayerType.v1,
    LayersTab.mapDetails => layers_state.LayerType.mapDetails,
    LayersTab.publicTransport => layers_state.LayerType.publicTransport,
  };

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
          LayerSliverList(
            onIconTap: onIconTap,
            layerType: _layersForTab(activeTab),
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
    // TODO(BE-243): replace inline strings with Localazy keys once added.
    const labels = <LayersTab, String>{
      LayersTab.allLayers: 'All layers',
      LayersTab.mapDetails: 'Map details',
      LayersTab.publicTransport: 'Public transport',
    };
    return Row(
      children: [
        for (final tab in LayersTab.values) ...[
          if (tab != LayersTab.allLayers) const SizedBox(width: Spacing.$2x),
          _LayersTabChip(label: labels[tab]!, isSelected: tab == active, onTap: () => onSelected(tab)),
        ],
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
    final colors = context.colors;
    final accent = colors.accentDefault;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: Spacing.$3x),
        decoration: BoxDecoration(
          color: colors.backgroundSurface2,
          borderRadius: BorderRadius.circular(RadiusBorder.m),
          border: Border.all(color: isSelected ? accent : Colors.transparent, width: 2),
          boxShadow: const [
            BoxShadow(color: Color(0x14000000), offset: Offset(0, 1), blurRadius: 4),
            BoxShadow(color: Color(0x0A000000), spreadRadius: 0.5),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textStyles.bodySmallMedium.copyWith(color: isSelected ? accent : colors.foregroundDefault),
        ),
      ),
    );
  }
}
