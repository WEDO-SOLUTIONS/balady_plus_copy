import 'package:balady_uikit/balady_uikit.dart' hide TrafficControlStatus;
import 'package:balady_uikit/core/extensions/build_context_ext.dart' show BuildContextExt;
import 'package:dgis_map/library.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/features/lifestyle_layers/helpers/layers_type_extension.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_state.dart' as layers_state;
import 'package:mapness/features/map_dimensions/map_dimensions_control_provider.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/auth/auth_methods.dart';

import 'package:mapness/shared/providers/map/traffic_state.dart' as traffic;

import '../../_generated/assets/assets.gen.dart';
import 'layer_switcher_card.dart';

class LayerSliverList extends ConsumerWidget {
  final List<layers_state.LayerType> layerType;
  final LayersState layersState;
  final Function() tapOnParkingLotsMenu;

  const LayerSliverList({
    required this.layerType,
    required this.layersState,
    required this.tapOnParkingLotsMenu,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layersControl = ref.watch(layersControlsProvider.notifier);
    final mapDimensionsState = ref.watch(mapDimensionsControlProvider);

    return SliverGrid.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 4,
        mainAxisExtent: 110,
        mainAxisSpacing: 1,
        crossAxisSpacing: 10,
      ),
      itemCount: layerType.length,
      itemBuilder: (_, index) {
        final value = layerType[index];
        final isSelected = layersState.selectedType == value;

        final selectedColor = context.colors.accentOnContainer;
        final selectedStyle = context.textStyles.bodyLargeMedium.copyWith(color: selectedColor);
        final textStyle = context.textStyles.bodyLargeRegular.copyWith(color: context.colors.foregroundDefault);

        final textColor = isSelected ? selectedColor : context.colors.foregroundSoft;

        const _iconDefaultSize = 24;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () async {
            if (value == layers_state.LayerType.favourites) {
              await ref
                  .read(authMethodsProvider.notifier)
                  .authOrOpen(
                    context,
                    callback: () async {
                      layersControl.handleTap(value);
                    },
                  );
            } else {
              layersControl.handleTap(value);
            }

            if (value == layers_state.LayerType.metro) {
              final trafficState = ref.read(traffic.trafficStateProvider.notifier);
              if (trafficState.isTrafficEnabled) {
                ref.read(traffic.trafficStateProvider.notifier).onTrafficTap();
              }
            }
          },
          child: LayerSwitcherCard(value, layersState, tapOnParkingLotsMenu),
        );
      },
    );
  }
}
