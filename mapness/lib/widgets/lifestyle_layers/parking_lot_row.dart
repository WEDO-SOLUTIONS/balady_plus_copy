import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/lifestyle_layers/providers/active_layer.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_state.dart';
import 'package:mapness/features/lifestyle_layers/providers/parking_details.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class ParkingLotRow extends ConsumerWidget {
  final ParkingFilter type;

  const ParkingLotRow({
    required this.type,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parkingDetailsNotifier = ref.watch(parkingDetailsProvider.notifier);
    final layersControls = ref.watch(layersControlsProvider.notifier);
    final state = ref.watch(parkingDetailsProvider);

    return SliverToBoxAdapter(
      child: ContentRow(
        onTap: () async {
          if (ref.read(activeLayerProvider) != LayerType.parkingLots) {
            layersControls.handleTap(LayerType.parkingLots);
          }

          await parkingDetailsNotifier.setParkingFilter(type);
        },
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
