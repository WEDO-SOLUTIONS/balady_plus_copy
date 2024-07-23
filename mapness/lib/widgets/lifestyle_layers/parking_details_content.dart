import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/_features/lifestyle_layers/providers/parking_details.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';

class ParkingDetailsContent extends ConsumerWidget {
  final ScrollController scrollController;

  const ParkingDetailsContent({
    required this.scrollController,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layersControlsProviderNotifier = ref.watch(layersControlsProvider.notifier);

    return CustomScrollView(
      controller: scrollController,
      primary: false,
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Material(
            color: Colors.transparent,
            child: Column(
              children: [
                const SizedBox(height: 8),
                const SheetDragger(),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      context.l10n.parkingLots,
                      style: context.textStyle.heading2,
                    ),
                    const Spacer(),
                    AppButton.close(
                      onTap: () {
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
                      innerPadding: const EdgeInsets.all(8),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
        const _ParkingLotRow(type: ParkingFilter.all),
        const _ParkingLotRow(type: ParkingFilter.free),
        const _ParkingLotRow(type: ParkingFilter.paid),
      ],
    );
  }
}

class _ParkingLotRow extends ConsumerWidget {
  final ParkingFilter type;
  const _ParkingLotRow({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parkingDetailsNotifier = ref.watch(parkingDetailsProvider.notifier);
    final state = ref.watch(parkingDetailsProvider);

    return SliverToBoxAdapter(
      child: ContentRow(
        onTap: () => parkingDetailsNotifier.setParkingFilter(type),
        options: ContentRowOptions(
          padding: const EdgeInsets.symmetric(vertical: Spacing.$3x, horizontal: Spacing.$4x),
          leadingIcon: type.icon().icon(),
          wrapperEnabled: true,
          wrapperColor: Colors.transparent,
          actionWidget: state.parkingFilter == type
              ? ContentRowActionOptions(
                  actionIcon: SystemIcons.checkmark.icon(
                    color: context.color.textAndIconsStatusAccent,
                  ),
                )
              : null,
          title: type.title(context.l10n),
          titleStyle: context.textStyle.text.copyWith(
            color: context.color.textAndIconsBasePrimary,
          ),
        ),
      ),
    );
  }
}
