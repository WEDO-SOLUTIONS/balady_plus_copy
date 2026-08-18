import 'package:auto_size_text/auto_size_text.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/lifestyle_layers/providers/active_layers_tab.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/features/satellite/providers/base_map_switcher_enabled.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_state.dart' as layers_state;
import 'package:mapness/shared/extensions/build_context_ext.dart';
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
                    onTap: onClose,
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
            // BALADY-3754: base-map switcher is gated by the
            // `base_map_switcher_enabled` FRC flag (hidden by default) until
            // the satellite tile source is production-ready.
            if (ref.watch(baseMapSwitcherEnabledProvider).value ?? false)
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
    // BALADY-3724: explicit Expanded + SizedBox gaps. Intrinsic-width +
    // spaceBetween crowded on narrower screens (Huawei) when chip texts
    // already filled most of the row width, leaving ~0px between chips.
    // Equal-width chips with a guaranteed gap render predictably across
    // devices.
    const tabs = LayersTab.values;
    return Row(
      children: [
        for (var i = 0; i < tabs.length; i++) ...[
          if (i > 0) const SizedBox(width: Spacing.$3x),
          Expanded(
            child: _LayersTabChip(
              label: labels[tabs[i]]!,
              isSelected: tabs[i] == active,
              onTap: () => onSelected(tabs[i]),
            ),
          ),
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
    // BALADY-3752: the selected tab carries an accent (green) highlight, not a
    // neutral one. The previous iteration signalled selection with a
    // backgroundSurface5 fill per Figma node 6194:9044; QA re-tested against
    // Figma "Layers on Map v3.0" and reports the green highlight as missing.
    //
    // Tokens follow the uikit's own selected-chip recipe (ChipsType.accent in
    // balady_uikit chips/tools/colors.dart — accentDefault fill +
    // accentOnAccent label), already used for a selectable chip row in
    // FeedbackChips, and echo the accent selection of the layer cards directly
    // below this row in the same sheet (LayerSwitcherCard uses an accentDefault
    // border). accentOnAccent is white in every palette and accentDefault is
    // brand-owned, so contrast holds in dark mode (darkDGA shares light's
    // #1B8354/#FFFFFF) and the special themes retint the chip on their own.
    final colors = context.colors;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      // BALADY-3725: instant state flip, no AnimatedContainer. Animating the
      // fill color over 150 ms produced overlapping transitions across two
      // chips (old + new both half-gray for a frame), which QA logged as a
      // flash. Selection is binary anyway, animation gave nothing here.
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: Spacing.$2x),
        decoration: BoxDecoration(
          color: isSelected ? colors.accentDefault : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: isSelected ? colors.accentDefault : colors.borderDefault),
        ),
        alignment: Alignment.center,
        // BALADY-3736: Arabic labels (e.g. "المواصلات العامة") are wider than
        // an equal-width chip and overflowed adjacent tabs. Shrink-to-fit
        // with AutoSizeText keeps all three labels readable on one line.
        child: AutoSizeText(
          label,
          maxLines: 1,
          minFontSize: 9,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: context.textStyles.bodySmallMedium.copyWith(
            color: isSelected ? colors.accentOnAccent : colors.foregroundDefault,
          ),
        ),
      ),
    );
  }
}
