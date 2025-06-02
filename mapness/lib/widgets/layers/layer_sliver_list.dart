import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/lifestyle_layers/helpers/layers_type_extension.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_state.dart' as layers_state;
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/auth/auth_methods.dart';

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
        final textColor = isSelected ? context.color.textAndIconsStatusAccent : context.color.textAndIconsBasePrimary;

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
          },
          options: ContentRowOptions(
            padding: EdgeInsets.zero,
            wrapperEnabled: true,
            wrapperColor: isSelected ? context.color.surfaceStatusContrastAccent.withOpacity(0.12) : Colors.transparent,
            leadingIcon: Padding(
              padding: const EdgeInsets.symmetric(vertical: Spacing.$3x),
              child: Row(
                children: [
                  Spacing.$4x.widthBox,
                  value.iconData().icon(color: textColor),
                ],
              ),
            ),
            title: value.titleLocale(context.l10n),
            customActionWidget: value == layers_state.LayerType.parkingLots
                ? GestureDetector(
                    onTap: tapOnParkingLotsMenu,
                    child: Container(
                      height: _iconDefaultSize + Spacing.$3x * 2,
                      width: _iconDefaultSize + Spacing.$4x * 2,
                      color: Colors.transparent,
                      child: SystemIcons.ellipsis.icon(),
                    ),
                  )
                : null,
            titleStyle: context.textStyle.text.copyWith(color: textColor),
          ),
        );
      },
    );
  }
}
