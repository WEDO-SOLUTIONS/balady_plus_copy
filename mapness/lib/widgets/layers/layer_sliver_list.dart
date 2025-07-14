import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/lifestyle_layers/helpers/layers_type_extension.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_state.dart' as layers_state;
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/auth/auth_methods.dart';
import 'package:mapness/shared/providers/map/traffic_state.dart' as traffic;

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
    final watch = ref.watch(layersControlsProvider.notifier);

    return SliverList.separated(
      separatorBuilder: (_, __) => const SizedBox(height: 4),
      itemCount: layerType.length,
      itemBuilder: (_, index) {
        final value = layerType[index];
        final isSelected = layersState.selectedType == value;

        final selectedColor = context.colors.accentOnContainer;
        final selectedStyle = context.textStyles.bodyLargeMedium.copyWith(
          color: selectedColor,
        );
        final textStyle = context.textStyles.bodyLargeRegular.copyWith(
          color: context.colors.foregroundDefault,
        );

        final textColor = isSelected ? selectedColor : context.colors.foregroundSoft;

        const _iconDefaultSize = 24;

        return ContentRow(
          onTap: () async {
            if (value == layers_state.LayerType.favourites) {
              await ref.read(authMethodsProvider.notifier).authOrOpen(
                context,
                callback: () async {
                  watch.handleTap(value);
                },
              );
            } else {
              watch.handleTap(value);
            }
            if (value == layers_state.LayerType.metro) {
              final trafficState = ref.read(traffic.trafficStateProvider.notifier);
              if (trafficState.isTrafficEnabled) {
                ref.read(traffic.trafficStateProvider.notifier).onTrafficTap();
              }
            }
          },
          // ignore: deprecated_member_use
          options: ContentRowOptions(
            padding: EdgeInsets.zero,
            wrapperEnabled: true,
            wrapperColor: isSelected ? context.colors.accentContainerDefault : Colors.transparent,
            leadingIcon: value.iconData().icon(color: textColor),
            title: value.titleLocale(context.l10n),
            customActionWidget: value == layers_state.LayerType.parkingLots
                ? GestureDetector(
                    onTap: tapOnParkingLotsMenu,
                    behavior: HitTestBehavior.opaque,
                    child: SizedBox(
                      height: _iconDefaultSize + Spacing.$3x * 2,
                      width: _iconDefaultSize + Spacing.$4x * 2,
                      child: SystemIcons.ellipsis.icon(color: context.colors.accentOnContainer),
                    ),
                  )
                : null,
            titleStyle: isSelected ? selectedStyle : textStyle,
          ),
        );
      },
    );
  }
}
