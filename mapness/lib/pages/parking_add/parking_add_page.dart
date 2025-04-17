import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/routing/route_point.dart';
import 'package:mapness/features/lifestyle_layers/configs/layers_consts.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/parking_add.dart';
import 'package:mapness/shared/ui/urbi_map.dart';
import 'package:mapness/widgets/parking_add/selected_images.dart';

@RoutePage()
class ParkingAddPage extends ConsumerStatefulWidget {
  final String? address;
  final GeoPointWithElevationMessage? markerPosition;

  const ParkingAddPage({
    required this.address,
    required this.markerPosition,
    super.key,
  });

  @override
  ConsumerState<ParkingAddPage> createState() => _ParkingAddPageState();
}

class _ParkingAddPageState extends ConsumerState<ParkingAddPage> {
  late final TextEditingController _textEditingController = TextEditingController();
  late final ValueNotifier<String> _addressNotifier = ValueNotifier(widget.address ?? '');
  late final _parkingId = 'parking_marker';
  late final _iconParking = 'packages/mapness/assets/icons/svg/places_new/ic_parking.svg';

  @override
  void dispose() {
    _textEditingController.dispose();
    _addressNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(parkingAddProvider.notifier);

    return Scaffold(
      backgroundColor: context.colorsV3.backgroundSurface4,
      appBar: BaladyTopBar(
        textStyle: context.textStyleV3.bodyLargeSemiBold.copyWith(color: context.colorsV3.foregroundDefault),
        title: 'Add parking',
        leading: Container(
          padding: const EdgeInsetsDirectional.only(start: Spacing.$4x),
          alignment: context.isLTR ? Alignment.centerLeft : Alignment.centerRight,
          child: const Icon(SystemIcons.arrowCornerLeftLarge),
        ),
        onLeadingPressed: () => context.router.popForced(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Spacing.$3x),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.feedbackAddress,
              style: context.textStyleV3.captionMediumRegular.copyWith(color: context.colorsV3.foregroundDefault),
            ),
            Spacing.$2x.heightBox,
            SizedBox(
              height: 84,
              child: UrbiMap(onMapCreated: _onMapCreated),
            ),
            Spacing.$2x.heightBox,
            ValueListenableBuilder(
                valueListenable: _addressNotifier,
                builder: (_, value, __) {
                  if (value.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return Text(
                    value,
                    style: context.textStyleV3.captionLargeRegular.copyWith(color: context.colorsV3.foregroundSoft),
                  );
                }),
            Spacing.$3x.heightBox,
            SizedBox(
              width: double.infinity,
              child: AppButton(
                buttonColorScheme: ButtonColorScheme.secondary,
                primaryIcon: GeneralIcons.location,
                primaryLabel: 'Change location',
                iconColor: context.colorsV3.accentSecondaryOnContainer,
                textColor: context.colorsV3.accentSecondaryOnContainer,
                onTap: () => _onTapChangeLocation(context),
              ),
            ),
            Spacing.$4x.heightBox,
            BaladyTextInput(
              label: BaladyInputLabel(
                text: context.l10n.comment,
                style: context.textStyleV3.captionMediumRegular,
              ),
              controller: _textEditingController,
              config: BaladyInputConfig(
                isDisposed: false,
                hintText: context.l10n.feedbackCommentHint,
                background: BaladyInputBackground.color,
                fillColor: context.colorsV2.neutralContainerDefault,
                autovalidateMode: AutovalidateMode.onUnfocus,
              ),
            ),
            Spacing.$4x.heightBox,
            SelectedImages(selectedImages: (images) {}),
          ],
        ),
      ),
    );
  }

  Future<void> _onTapChangeLocation(BuildContext context) async {
    final result = await context.router.push(const RoutingMapSelectRoute());

    if (result == null || result is! RoutePoint) {
      return;
    }

    if (result is RoutePointCoordinates && result.label != null) {
      _addressNotifier.value = result.label!;
    } else {
      _addressNotifier.value = 'latitude: ${result.latitude}, longitude:${result.longitude}';
    }

    if (result.latitude != null && result.longitude != null) {
      final dgisMapController = ref.read(parkingAddProvider.notifier);

      await dgisMapController.setCameraPosition(
        GeoPointWithElevationMessage(
          latitude: result.latitude!,
          longitude: result.longitude!,
          elevation: 0,
        ),
      );
      await dgisMapController.addMarker(
        Marker(
          id: _parkingId,
          options: MarkerOptionsMessage(
            position: GeoPointWithElevationMessage(
              latitude: result.latitude!,
              longitude: result.longitude!,
              elevation: 0,
            ),
            icon: _iconParking.markerIcon(),
          ),
        ),
      );
    }
  }

  Future<void> _onMapCreated(DgisMapController controller) async {
    final dgisMapController = ref.read(parkingAddProvider.notifier);
    await dgisMapController.onMapCreated(controller);
    if (widget.markerPosition != null) {
      await dgisMapController.setCameraPosition(
        GeoPointWithElevationMessage(
          latitude: widget.markerPosition!.latitude,
          longitude: widget.markerPosition!.longitude,
          elevation: 0,
        ),
      );
      await dgisMapController.addMarker(
        Marker(
          id: _parkingId,
          options: MarkerOptionsMessage(
            position: GeoPointWithElevationMessage(
              latitude: widget.markerPosition!.latitude,
              longitude: widget.markerPosition!.longitude,
              elevation: 0,
            ),
            icon: _iconParking.markerIcon(),
          ),
        ),
      );
    }
  }
}
