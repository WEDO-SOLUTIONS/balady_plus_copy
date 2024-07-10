import 'package:balady_uikit/components.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/icon_ext.dart';
import 'package:balady_uikit/core/icons/app_icons.dart';
import 'package:balady_uikit/core/icons/system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/landing/providers/search_by_rubrics.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_state.dart' as layers_state;
import 'package:mapness/_features/lifestyle_layers/providers/lib/layers_type_extension.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/common_functions.dart';

class LayerSliverList extends ConsumerWidget {
  final List<layers_state.LayerType> layerType;
  final LayersState layersState;

  const LayerSliverList({
    required this.layerType,
    required this.layersState,
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

        return ContentRow(
          onTap: () async {
            ref.read(searchByRubricsQueryProvider.notifier).update(null);

            if (value == layers_state.LayerType.favourites) {
              await CommonFunctions.authOrOpen(
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
            wrapperEnabled: true,
            wrapperColor: isSelected ? context.color.surfaceStatusContrastAccent.withOpacity(0.12) : Colors.transparent,
            leadingIcon: value.iconData().icon(color: textColor),
            title: value.titleLocale(context.l10n),
            actionWidget: value == layers_state.LayerType.parkingLots
                ? ContentRowActionOptions(
              actionPressed: () {},
              actionIcon: const AppIcons(iconData: SystemIcons.ellipsis),
            )
                : null,
            titleStyle: context.textStyle.text.copyWith(color: textColor),
          ),
        );
      },
    );
  }
}