import 'package:balady_uikit/core/extensions/build_context_ext.dart' show BuildContextExt;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_state.dart' as layers_state;
import 'package:mapness/features/map_dimensions/map_dimensions_control_provider.dart';
import 'package:mapness/shared/lib/auth/auth_methods.dart';
import 'package:mapness/shared/providers/map/traffic_state.dart' as traffic;

import 'layer_switcher_card.dart';

class LayerSliverList extends ConsumerWidget {
  final List<layers_state.LayerType> layerType;
  final LayersState layersState;
  final ValueChanged<layers_state.LayerType>? onIconTap;
  final Set<layers_state.LayerType> layerTapItems;

  const LayerSliverList({
    required this.layerType,
    required this.layersState,
    this.layerTapItems = const {},
    this.onIconTap,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layersControl = ref.watch(layersControlsProvider.notifier);
    final mapDimensionsState = ref.watch(mapDimensionsControlProvider);

    // used AlignedGridView because it can handle dynamic child height
    return AlignedGridView.count(
      itemCount: layerType.length,
      crossAxisCount: 3,
      mainAxisSpacing: 1,
      crossAxisSpacing: 10,
      shrinkWrap: true,
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
              // BALADY-3730: must be authAndOpen, not authOrOpen. doAuth()
              // only OPENS the login screen and resolves immediately
              // (EntryPointCubit.onLogin pushes the route and returns), so
              // authOrOpen re-checks isLoggedIn while the user is still on
              // the login form and silently skips the callback. authAndOpen
              // subscribes to userStateStream and runs the callback after
              // login actually completes.
              await ref
                  .read(authMethodsProvider.notifier)
                  .authAndOpen(
                    context,
                    callback: () async {
                      // Read the notifier fresh inside the callback — the
                      // widget-scoped `layersControl` can be disposed while
                      // the auth flow covers the sheet.
                      await ref.read(layersControlsProvider.notifier).toggleFavourites();
                    },
                  );
            } else if (value == layers_state.LayerType.busSubMenu) {
              // BALADY-3726: tap anywhere on the Bus card (incl. the thumbnail)
              // opens the bus submenu — same behavior the label + chevron row
              // already has via LayerSwitcherCard's inner gesture detector.
              onIconTap?.call(value);
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
          child: LayerSwitcherCard(value, layersState, onIconTap, layerTapItems),
        );
      },
    );
  }
}
