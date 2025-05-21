import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/routing/route_point.dart';
import 'package:mapness/features/lifestyle_layers/configs/layers_consts.dart';
import 'package:mapness/features/parking_spot/model/parking_store_model.dart';
import 'package:mapness/features/parking_spot/parking_image.dart';
import 'package:mapness/features/parking_spot/parking_manage.dart';
import 'package:mapness/features/parking_spot/parking_spot_map.dart';
import 'package:mapness/features/routing/providers/routes.dart';
import 'package:mapness/shared/constants/constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/deeplink_functions.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:mapness/shared/ui/toast/toast_overlay.dart';
import 'package:mapness/shared/ui/urbi_map.dart';
import 'package:mapness/widgets/parking_spot/selected_images.dart';
import 'package:share_plus/share_plus.dart';

@RoutePage()
class ParkingSpotPage extends ConsumerStatefulWidget {
  final String? address;
  final GeoPointWithElevationMessage? markerPosition;
  final bool isEdit;

  const ParkingSpotPage({
    this.address,
    this.markerPosition,
    this.isEdit = false,
    super.key,
  });

  @override
  ConsumerState<ParkingSpotPage> createState() => _ParkingSpotState();
}

class _ParkingSpotState extends ConsumerState<ParkingSpotPage> {
  late final TextEditingController _textEditingController = TextEditingController();
  late final ValueNotifier<String> _addressNotifier = ValueNotifier(widget.address ?? '');
  final _isDirty = ValueNotifier(false);
  final ValueNotifier<bool?> _initializationMap = ValueNotifier(null);
  LatLng? _latLng;

  @override
  void initState() {
    super.initState();

    final stored = ref
        .read(parkingManageProvider)
        .valueOrNull;

    if (widget.isEdit && stored != null) {
      _textEditingController.text = stored.comment;
      _addressNotifier.value = stored.address;
      _latLng = LatLng(latitude: stored.lat, longitude: stored.lon);
    } else {
      _textEditingController.text = '';
      _addressNotifier.value = widget.address ?? '';
      _latLng = LatLng(
        latitude: widget.markerPosition?.latitude ?? 0,
        longitude: widget.markerPosition?.longitude ?? 0,
      );
    }

    _addressNotifier.addListener(_checkDirty);
    _textEditingController.addListener(_checkDirty);
    _checkDirty();
  }

  @override
  void dispose() {
    _isDirty.dispose();
    _textEditingController.dispose();
    _addressNotifier.dispose();
    _initializationMap.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref
      ..watch(parkingSpotMapProvider.notifier)..watch(parkingManageProvider.notifier)
      ..listen(parkingImageProvider(isEdit: widget.isEdit), (_, __) => _checkDirty());

    return Scaffold(
      backgroundColor: context.colorsV3.backgroundSurface4,
      appBar: BaladyTopBar(
        systemUiOverlayStyle: SystemUiOverlayStyle.dark,
        textStyle: context.textStyleV3.bodyLargeSemiBold.copyWith(color: context.colorsV3.foregroundDefault),
        title: widget.isEdit ? context.l10n.edit : context.l10n.addParking,
        leading: Container(
          padding: const EdgeInsetsDirectional.only(start: Spacing.$4x),
          alignment: context.isLTR ? Alignment.centerLeft : Alignment.centerRight,
          child: const Icon(SystemIcons.arrowCornerLeftLarge),
        ),
        onLeadingPressed: () => context.router.popForced(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Spacing.$3x),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacing.$2x.heightBox,
              ValueListenableBuilder(
                  valueListenable: _initializationMap,
                  builder: (context, value, _) {
                    if (value == null || value == false) {
                      return const SizedBox.shrink();
                    }

                    return SizedBox(
                      height: 108,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(RadiusBorder.l)),
                        child: UrbiMap(
                          onMapCreated: _onMapCreated,
                          key: const Key('ParkingSpotDGISMapKey'),
                        ),
                      ),
                    );
                  }),
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
                  primaryLabel: context.l10n.changeLocation,
                  iconColor: context.colorsV3.accentSecondaryOnContainer,
                  textColor: context.colorsV3.accentSecondaryOnContainer,
                  onTap: () => _onTapChangeLocation(context),
                ),
              ),
              Spacing.$4x.heightBox,
              BaladyTextInput(
                label: BaladyInputLabel(
                    text: context.l10n.comment,
                    style:
                    context.textStyleV3.captionMediumRegular.copyWith(color: context.colorsV3.foregroundDefault)),
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
              SelectedImages(isEdit: widget.isEdit,),
              const Spacer(),
              ValueListenableBuilder<bool>(
                valueListenable: _isDirty,
                builder: (_, canSave, __) =>
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        buttonColorScheme: ButtonColorScheme.primary,
                        buttonState: canSave ? ButtonState.normal : ButtonState.disabled,
                        primaryLabel: context.l10n.save,
                        onTap: canSave ? () => _onTapSave(context) : null,
                      ),
                    ),
              ),
              Spacing.$0_5x.heightBox,
              Center(
                child: Text(
                  context.l10n.dataStoredFor,
                  style: context.textStyleV3.captionMediumRegular.copyWith(color: context.colorsV3.foregroundSoft),
                ),
              )
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  Future<void> _onTapChangeLocation(BuildContext context) async {
    final result = await context.router.push(const RoutingMapSelectRoute());


    if (result == null || result is! RoutePoint) {
      return;
    }

    _latLng = LatLng(latitude: result.latitude!, longitude: result.longitude!);

    if (result is RoutePointCoordinates && result.label != null) {
      _addressNotifier.value = result.label!;
    } else {
      _addressNotifier.value = 'latitude: ${result.latitude}, longitude:${result.longitude}';
    }

    if (result.latitude != null && result.longitude != null) {
      final dgisMapController = ref.read(parkingSpotMapProvider.notifier);

      await dgisMapController.setCameraPosition(
        GeoPointWithElevationMessage(
          latitude: result.latitude!,
          longitude: result.longitude!,
          elevation: 0,
        ),
      );

      await ref.read(parkingSpotMapProvider.notifier).deleteMarkers();

      await dgisMapController.addMarker(
        Marker(
          id: parkingId,
          options: MarkerOptionsMessage(
            position: GeoPointWithElevationMessage(
              latitude: _latLng!.latitude,
              longitude: _latLng!.longitude,
              elevation: 0,
            ),
            icon: Assets.icons.svg.placesNew.icParking.keyName.markerIcon(),
          ),
        ),
      );
    }
  }

  Future<void> _onMapCreated(DgisMapController controller) async {
    final initialize = await controller.initialize();
    _initializationMap.value = initialize.wasInitialized;

    //Styles
    await controller.loadStyles(MapnessConstants.mapStylesPath);

    // Appearance
    await controller.setZoomRestrictions(min: 5.5);
    await controller.overrideLocales(ref.read(appLanguageProvider) == Language.arabic ? ['ar-SA'] : ['en-SA']);
    await controller.setAppearance(
        (await ref.read(darkModeProvider.future)).isDark ? MapAppearanceMessage.night : MapAppearanceMessage.day);
    await controller.setBetterRouteSettings(BetterRouteSettings.prod);

    final dgisMapController = ref.read(parkingSpotMapProvider.notifier);
    await dgisMapController.onMapCreated(controller);
    if (_latLng != null) {
      await dgisMapController.setCameraPosition(
        GeoPointWithElevationMessage(
          latitude: _latLng!.latitude,
          longitude: _latLng!.longitude,
          elevation: 0,
        ),
      );
      await dgisMapController.addMarker(
        Marker(
          id: parkingId,
          options: MarkerOptionsMessage(
            position: GeoPointWithElevationMessage(
              latitude: _latLng!.latitude,
              longitude: _latLng!.longitude,
              elevation: 0,
            ),
            icon: Assets.icons.svg.placesNew.icParking.keyName.markerIcon(),
          ),
        ),
      );
    }
  }

  Future<void> _onTapSave(BuildContext context) async {
    final parkingManage = ref.read(parkingManageProvider.notifier);
    final images = ref.read(parkingImageProvider(isEdit: widget.isEdit));

    if (_latLng == null) {
      return;
    }

    await parkingManage.saveStore(
      ParkingStoreModel(
        dateTime: DateTime.now(),
        imagesPaths: images.map((e) => e.path).toList(),
        comment: _textEditingController.text,
        lat: _latLng!.latitude,
        lon: _latLng!.longitude,
        address: _addressNotifier.value,
      ),
    );

    callToast();
    context.router.popUntilRouteWithName(BottomMenuRoute.name);
  }

  void callToast() {
    ToastOverlay.of(context).show(
      title: context.l10n.parkingSuccessfullySaved,
      firstText: context.l10n.feedbackBreaksSheetClose,
      secondText: context.l10n.share,
      iconAsset: Assets.icons.svg.parkingControl.keyName,
      onSecondTap: () async {
        if (_latLng == null) {
          return;
        }

        final baseUri = BaldayDeeplink.basePoiUri;
        final query = <String, String>{};

        query[BaldayDeeplink.dgisObjectIdKey] = parkingObjectId.toString();

        query[BaldayDeeplink.latitudeKey] = _latLng!.latitude.toString();
        query[BaldayDeeplink.longitudeKey] = _latLng!.longitude.toString();

        await Share.share(
            '${rootNavigatorKey.currentContext?.l10n.leftMyCarHere} ${BaldayDeeplink.urlWithQuery(baseUri, query)}');
      },
    );
  }

  void _checkDirty() {
    final stored = ref
        .read(parkingManageProvider)
        .valueOrNull;
    final images = ref.read(parkingImageProvider(isEdit: widget.isEdit));

    final imagesDirty = !const ListEquality().equals(images.map((e) => e.path).toList(), stored?.imagesPaths ?? []);

    final textDirty = _textEditingController.text != stored?.comment;
    final addressDirty = _addressNotifier.value != stored?.address;
    final latDirty = _latLng?.latitude != stored?.lat;
    final lonDirty = _latLng?.longitude != stored?.lon;

    final dirty = widget.isEdit ? (textDirty || addressDirty || latDirty || lonDirty || imagesDirty) : _latLng != null;

    if (_isDirty.value != dirty) {
      _isDirty.value = dirty;
    }
  }
}
