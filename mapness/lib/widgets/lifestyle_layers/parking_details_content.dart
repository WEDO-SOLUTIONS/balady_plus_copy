import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/lifestyle_layers/parking_lot_row.dart';

class ParkingDetailsContent extends ConsumerWidget {
  final VoidCallback onPanelClose;

  const ParkingDetailsContent({required this.onPanelClose, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layersControlsProviderNotifier = ref.watch(layersControlsProvider.notifier);

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          Row(
            children: [
              Text(
                context.l10n.parkingLots,
                style: context.textStyles.h4SemiBold.copyWith(
                  color: context.colors.foregroundDefault,
                ),
              ),
              const Spacer(),
              AppButton.close(
                color: context.colors.backgroundSurface1,
                onTap: () {
                  onPanelClose();
                  layersControlsProviderNotifier.update(
                    layersWidgetType: LayersPanelType.layers,
                  );
                },
                padding: EdgeInsets.zero,
              ),
            ],
          ),
          const SizedBox(height: Spacing.$2x),
          ContentWrapper(
            color: context.colors.backgroundSurface1,
            children: [
              const ParkingLotRow(
                type: ParkingFilter.all,
              ),
              Divider(
                color: context.colors.borderDefault,
                endIndent: 10,
                indent: 10,
              ),
              const ParkingLotRow(
                type: ParkingFilter.free,
              ),
              Divider(
                color: context.colors.borderDefault,
                endIndent: 10,
                indent: 10,
              ),
              const ParkingLotRow(type: ParkingFilter.paid),
            ],
          ),
          const SizedBox(height: Spacing.$9x),
        ]),
      ),
    );
  }
}
