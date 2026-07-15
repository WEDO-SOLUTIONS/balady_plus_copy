import 'package:balady_uikit/balady_uikit.dart' hide TrafficControlStatus;
import 'package:balady_uikit/core/extensions/build_context_ext.dart' show BuildContextExt;
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/entities/common/image_asset_type.dart';
import 'package:mapness/features/lifestyle_layers/helpers/layers_type_extension.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_state.dart' as layers_state;
import 'package:mapness/features/map_dimensions/map_dimensions_control_provider.dart';
import 'package:mapness/features/metro/metro_layer_visible_provider.dart';
import 'package:mapness/features/satellite/providers/satellite_map_controller.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/map/traffic_state.dart' as traffic;

class LayerSwitcherCard extends ConsumerWidget {
  final layers_state.LayerType value;
  final LayersState layersState;
  final ValueChanged<layers_state.LayerType>? onIconTap;
  final Set<layers_state.LayerType> layerTapItems;

  const LayerSwitcherCard(
    this.value,
    this.layersState,
    this.onIconTap,
    this.layerTapItems, {
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isSelected = layersState.selectedType == value;

    final colors = context.colors;
    final selectedColor = colors.accentOnContainer;
    final textStyles = context.textStyles;

    if (value == layers_state.LayerType.three3D) {
      final mapDimensionsState = ref.watch(mapDimensionsControlProvider);
      isSelected = mapDimensionsState == MapDimensionsState.threeDimensional;
    }

    if (value == layers_state.LayerType.metro) {
      isSelected = ref.watch(metroLayerVisibleProvider);
    }

    if (value == layers_state.LayerType.traffic) {
      final trafficState = ref.watch(traffic.trafficStateProvider);
      isSelected = trafficState.status == TrafficControlStatus.enabled;
    }

    if (value == layers_state.LayerType.busSubMenu) {
      final trafficState = ref.watch(traffic.trafficStateProvider);
      isSelected = layers_state.LayerType.bus.contains(layersState.selectedType);
    }

    if (value == layers_state.LayerType.satellite) {
      isSelected = ref.watch(satelliteMapControllerProvider);
    }

    if (value == layers_state.LayerType.defaultMap) {
      isSelected = !ref.watch(satelliteMapControllerProvider);
    }

    final withIcon = onIconTap != null && layerTapItems.contains(value);

    final (imageType, assetPath) = value.imageAsset();
    final image = switch (imageType) {
      ImageAssetType.svg => Semantics(
        label: '',
        image: true,
        enabled: false,
        child: SvgPicture.asset(
          assetPath,
          fit: BoxFit.cover,
          height: 80,
          colorFilter: ColorFilter.mode(
            Colors.black.withAlpha(40),
            BlendMode.overlay,
          ),
        ),
      ),
      ImageAssetType.image => Semantics(
        label: '',
        image: true,
        enabled: false,
        child: Image.asset(
          assetPath,
          fit: BoxFit.cover,
          height: 80,
        ),
      ),
    };

    return Semantics(
      label: value.titleLocale(context.l10n),
      enabled: true,
      child:Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              strokeAlign: BorderSide.strokeAlignOutside,
              color: isSelected != true ? Colors.transparent : colors.accentDefault,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(RadiusBorder.m),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(RadiusBorder.m),
            child: image,
          ),
        ),
       //  const SizedBox(height: Spacing.$1x),
        // BE-153: when this is the parking layer card, the whole title row
        // (text + chevron) opens the parking menu — not only the chevron icon.
        GestureDetector(
          onTap: withIcon ? () => onIconTap?.call(value) : null,
          behavior: HitTestBehavior.opaque,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Semantics(
                    label: '',
                    enabled: false,
                    child: Text(
                      value.titleLocale(context.l10n),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: textStyles.bodySmallMedium.copyWith(
                        color: isSelected ? colors.accentOnContainer : colors.foregroundDefault,
                      ),
                    ),
                  ),
                ),
                if (withIcon)
                  Icon(
                    Icons.chevron_right,
                    size: 22,
                    color: colors.foregroundSoft,
                  ),
              ],
            ),
          ),
          const SizedBox(height: Spacing.$2x),
        ],
      ),
    );
  }
}
