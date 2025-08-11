import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/features/map_dimensions/map_dimensions_control_provider.dart';

class DimensionControl extends ConsumerWidget {
  const DimensionControl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapDimensionsState = ref.watch(mapDimensionsControlProvider);

    const double iconSize = 24;

    if (mapDimensionsState == MapDimensionsState.hide) {
      return const SizedBox.shrink();
    }

    return MapButton(
      onTap: () => ref.read(mapDimensionsControlProvider.notifier).toggleMapDimensions(),
      child: SizedBox(
        width: iconSize,
        height: iconSize,
        child: Center(
          child: mapDimensionsState == MapDimensionsState.twoDimensional
              ? Assets.icons.svg.ic3d.svg(
                  width: iconSize,
                  height: iconSize,
                  colorFilter: ColorFilter.mode(context.colors.foregroundDefault, BlendMode.srcIn),
                )
              : Assets.icons.svg.ic2d.svg(
                  width: iconSize,
                  height: iconSize,
                  colorFilter: ColorFilter.mode(context.colors.foregroundDefault, BlendMode.srcIn),
                ),
        ),
      ),
    );
  }
}
