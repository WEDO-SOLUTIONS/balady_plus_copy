import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_state.dart' as layers_state;
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/features/balady_analytics/metrics.dart';
import 'package:mapness/widgets/layers/layer_sliver_list.dart';
import 'package:sliver_tools/sliver_tools.dart';

class BusDetailsContent extends ConsumerWidget {
  final VoidCallback onPanelClose;

  const BusDetailsContent({required this.onPanelClose, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(layersControlsProvider);
    final layersControlsProviderNotifier = ref.watch(layersControlsProvider.notifier);

    return SliverPadding(
      padding: const EdgeInsets.only(
        left: Spacing.$4x,
        right: Spacing.$4x,
        bottom: Spacing.$4x,
      ),
      sliver: MultiSliver(
        children: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: Spacing.$5x),
              child: Row(
                children: [
                  Text(
                    context.l10n.bus,
                    style: context.textStyles.h4SemiBold.copyWith(color: context.colors.foregroundDefault),
                  ),
                  const Spacer(),
                  AppButton.close(
                    onTap: () {
                      onPanelClose();
                      Metrics.logEventAdvanced(
                        MetricsConstants.layersKeys.exitIcon,
                        group: MetricsConstants.layersTag,
                        action: MetricAction.tap.toString(),
                      );

                      layersControlsProviderNotifier.update(
                        layersWidgetType: LayersPanelType.layers,
                      );
                    },
                    padding: EdgeInsets.zero,
                    innerPadding: const EdgeInsets.symmetric(horizontal: Spacing.$2x),
                  ),
                ],
              ),
            ),
          ),
          LayerSliverList(
            layerType: layers_state.LayerType.bus,
            layersState: state,
          ),
        ],
      ),
    );
  }
}
