import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_state.dart' as layers_state;
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/widgets/layers/layer_sliver_list.dart';

class LayersSheetContent extends ConsumerWidget {
  final ScrollController scrollController;

  final Function() tapOnParkingLotsMenu;
  final Function() onClose;

  const LayersSheetContent({
    required this.scrollController,
    required this.tapOnParkingLotsMenu,
    required this.onClose,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(layersControlsProvider);
    // final layersControlsProviderNotifier = ref.watch(layersControlsProvider.notifier);

    return CustomScrollView(
      controller: scrollController,
      primary: false,
      shrinkWrap: true,
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              const SizedBox(height: 8),
              const SheetDragger(),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(context.l10n.layersOnTheMap, style: context.textStyle.heading2),
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
                    innerPadding: const EdgeInsets.all(8),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        // TODO(Ayat): BSA(1069) For now we hide the switches and present only the Lifestyle logic, we will come back to this later
        // SliverToBoxAdapter(
        //   child: Column(
        //     children: [
        //       TabsRow.v2(
        //         initialIndex: state.layersType.index,
        //         tabsContent: [
        //           TabsRowV2Content(title: context.l10n.lifestyle),
        //           TabsRowV2Content(title: context.l10n.business),
        //         ],
        //         onIndexChanged: (index) {
        //           layersControlsProviderNotifier.update(
        //             layersType: LayersType.values[index ?? 0],
        //           );
        //         },
        //       ),
        //       const SizedBox(height: 12),
        //     ],
        //   ),
        // ),
        LayerSliverList(
          tapOnParkingLotsMenu: tapOnParkingLotsMenu,
          layerType: switch (state.layersType) {
            LayersType.lifestyle => layers_state.LayerType.lifestyle,
            LayersType.business => layers_state.LayerType.business,
          },
          layersState: state,
        ),
      ],
    );
  }
}
