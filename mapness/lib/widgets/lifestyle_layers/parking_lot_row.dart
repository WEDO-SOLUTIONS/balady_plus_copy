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
  final bool? dividerEnabled;

  const ParkingLotRow({
    required this.type,
    this.dividerEnabled,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parkingDetailsNotifier = ref.watch(parkingDetailsProvider.notifier);
    final layersControls = ref.watch(layersControlsProvider.notifier);
    final state = ref.watch(parkingDetailsProvider);

    final selectedColor = context.colors.accentDefault;
    final selectedStyle = context.textStyles.bodyLargeMedium.copyWith(
      color: selectedColor,
    );
    final textStyle = context.textStyles.bodyLargeRegular.copyWith(
      color: context.colors.foregroundDefault,
    );

    final isSelected = type == state.parkingFilter;
    return ContentRow(
      onTap: () async {
        await parkingDetailsNotifier.setParkingFilter(type);
        if (ref.read(activeLayerProvider) != LayerType.parkingLots) {
          await layersControls.enableParking();
        }
      },
      options: ContentRowOptions(
        dividerEnabled: dividerEnabled,
        padding: const EdgeInsets.symmetric(vertical: Spacing.$3x, horizontal: Spacing.$4x),
        leadingIcon: type.icon().icon(
          color: isSelected ? selectedColor : context.colors.foregroundSoft,
        ),
        wrapperEnabled: true,
        title: type.title(context.l10n),
        titleStyle: textStyle,
        actionWidget: isSelected
            ? ContentRowActionOptions(
                actionIcon: General16Icons.checkmarkLTR.icon(),
              )
            : null,
      ),
    );
  }
}
