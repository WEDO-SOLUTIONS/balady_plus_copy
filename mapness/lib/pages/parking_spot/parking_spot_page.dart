import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/city_event/city_event.dart';
import 'package:mapness/entities/routing/route_point.dart';
import 'package:mapness/features/city_event/active_city_event.dart';
import 'package:mapness/features/parking_spot/model/parking_store_model.dart';
import 'package:mapness/features/parking_spot/parking_image.dart';
import 'package:mapness/features/parking_spot/parking_manage.dart';
import 'package:mapness/features/parking_spot/parking_spot_map.dart';
import 'package:mapness/shared/entities/coordinates.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/share_util.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:mapness/shared/ui/toast/toast_overlay.dart';
import 'package:mapness/shared/ui/urbi_map.dart';
import 'package:mapness/shared/utils/detach.dart';
import 'package:mapness/widgets/parking_spot/selected_images.dart';
import 'package:provider/provider.dart';

import '../../widgets/landing/map_attribution_label.dart';

@RoutePage()
class ParkingSpotPage extends HookConsumerWidget {
  final String? address;
  final GeoPointWithElevationMessage? markerPosition;
  final bool isEdit;

  const ParkingSpotPage({this.address, this.markerPosition, this.isEdit = false, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController = useTextEditingController();
    final addressNotifier = useState<String>(address ?? '');
    final isDirty = useState<bool>(false);
    final isValid = useState<bool>(true);
    final latLng = useState<LatLng?>(
      markerPosition != null ? LatLng(latitude: markerPosition!.latitude, longitude: markerPosition!.longitude) : null,
    );

    final maxLines = useState<int>(3);
    final inputState = useState<BaladyInputState>(BaladyInputState.defaultValue);
    final supportingText = useState<String?>(null);

    void checkDirty() {
      final stored = ref.read(parkingManageProvider(theme: context.read<ThemeController>().currentTheme)).value;
      final images = ref.read(
        parkingImageProvider(theme: context.read<ThemeController>().currentTheme, isEdit: isEdit),
      );

      final imagesDirty = !const ListEquality().equals(images.map((e) => e.path).toList(), stored?.imagesPaths ?? []);
      final textDirty = textController.text != stored?.comment;
      final addressDirty = addressNotifier.value != stored?.address;
      final latDirty = latLng.value?.latitude != stored?.lat;
      final lonDirty = latLng.value?.longitude != stored?.lon;

      final dirty = isEdit ? (textDirty || addressDirty || latDirty || lonDirty || imagesDirty) : latLng.value != null;
      isDirty.value = dirty;
    }

    useEffect(() {
      final stored = ref.read(parkingManageProvider(theme: context.read<ThemeController>().currentTheme)).value;
      if (isEdit && stored != null) {
        textController.text = stored.comment;
        addressNotifier.value = stored.address;
        latLng.value = LatLng(latitude: stored.lat, longitude: stored.lon);
      }

      addressNotifier.addListener(checkDirty);
      textController.addListener(checkDirty);
      checkDirty();

      return () {
        addressNotifier.removeListener(checkDirty);
        textController.removeListener(checkDirty);
      };
    }, []);

    useEffect(() {
      void calculateMaxLines() {
        const averageCharWidth = 10.0;
        final textFieldWidth = MediaQuery.sizeOf(context).width - (Spacing.$4x * 2);
        final charsPerLine = (textFieldWidth / averageCharWidth).floor();
        final lines = (textController.text.length / charsPerLine).ceil();
        maxLines.value = lines.clamp(3, 7);

        final isValidLength = textController.text.length <= 225;
        inputState.value = isValidLength ? BaladyInputState.defaultValue : BaladyInputState.error;
        supportingText.value = isValidLength ? null : context.l10n.appFeedbackCharacterLimitReached;
        isValid.value = isValidLength;
      }

      textController.addListener(calculateMaxLines);
      return () => textController.removeListener(calculateMaxLines);
    }, [textController]);

    ref
      ..watch(parkingSpotMapProvider.notifier)
      ..watch(parkingManageProvider(theme: context.read<ThemeController>().currentTheme).notifier)
      ..listen(parkingImageProvider(theme: context.read<ThemeController>().currentTheme, isEdit: isEdit), (_, __) {
        checkDirty();
      });
    final canSave = isDirty.value && isValid.value;
    final isDark = ref.read(darkModeProvider).value?.isDark ?? false;
    final activeCityEvent = ref.read(activeCityEventProvider);
    final icParkingIcon = activeCityEvent.getIcParking(isDark: isDark);

    return Scaffold(
      backgroundColor: context.colors.backgroundSurface4,
      appBar: BaladyTopBar(
        systemUiOverlayStyle: context.read<ThemeController>().systemOverlayStyle,
        textStyle: context.textStyles.bodyLargeSemiBold.copyWith(color: context.colors.foregroundDefault),
        title: isEdit ? context.l10n.edit : context.l10n.addParking,
        leading: Semantics(
          label: context.l10n.a11yBack,
          button: true,
          child: ExcludeSemantics(
            child: Container(
              padding: const EdgeInsetsDirectional.only(start: Spacing.$4x),
              alignment: context.isLTR ? Alignment.centerLeft : Alignment.centerRight,
              child: const Icon(SystemIcons.arrowCornerLeftLarge),
            ),
          ),
        ),
        onLeadingPressed: () => context.router.pop(),
      ),
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Padding(
            padding: const EdgeInsets.all(Spacing.$3x),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Spacing.$2x.heightBox,
                SizedBox(
                  height: 108,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomStart,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(RadiusBorder.l)),
                        child: UrbiMap(
                          onMapCreated: (controller) async {
                            final dgisMapController = ref.read(parkingSpotMapProvider.notifier);
                            await dgisMapController.onMapCreated(controller);
                            if (latLng.value != null) {
                              await dgisMapController.setCameraPosition(
                                GeoPointWithElevationMessage(
                                  latitude: latLng.value!.latitude,
                                  longitude: latLng.value!.longitude,
                                  elevation: 0,
                                ),
                              );
                              await dgisMapController.addMarker(
                                Marker(
                                  id: parkingId,
                                  options: MarkerOptionsMessage(
                                    position: GeoPointWithElevationMessage(
                                      latitude: latLng.value!.latitude,
                                      longitude: latLng.value!.longitude,
                                      elevation: 0,
                                    ),
                                    icon: icParkingIcon,
                                  ),
                                ),
                              );
                            }
                          },
                          key: const Key('ParkingSpotDGISMapKey'),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsetsDirectional.only(start: Spacing.$2x, bottom: Spacing.$1x),
                        child: MapAttributionLabel(),
                      ),
                    ],
                  ),
                ),
                Spacing.$2x.heightBox,
                if (addressNotifier.value.isNotEmpty)
                  Text(
                    addressNotifier.value,
                    style: context.textStyles.captionLargeRegular.copyWith(color: context.colors.foregroundSoft),
                  ),
                Spacing.$3x.heightBox,
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    color: context.colors.accentDefault.withOpacity(.1),
                    buttonColorScheme: ButtonColorScheme.accent,
                    buttonType: ButtonType.secondary,
                    size: ButtonSize.large,
                    primaryIcon: GeneralIcons.location,
                    primaryLabel: context.l10n.changeLocation,
                    onTap: () => _handleChangeLocation(context, ref, latLng, addressNotifier, icParkingIcon),
                  ),
                ),
                Spacing.$4x.heightBox,
                BaladyTextInput(
                  controller: textController,
                  inputState: inputState.value,
                  label: BaladyInputLabel(
                    text: context.l10n.comment,
                    style: context.textStyles.captionMediumRegular.copyWith(color: context.colors.foregroundDefault),
                  ),
                  config: BaladyInputConfig(
                    autofocus: true,
                    hintText: context.l10n.feedbackCommentHint,
                    maxLines: maxLines.value,
                    isDisposed: false,
                  ),
                  supportingText: BaladySupportingText(text: supportingText.value),
                ),
                Spacing.$4x.heightBox,
                SelectedImages(isEdit: isEdit),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    buttonColorScheme: ButtonColorScheme.accentSecondary,
                    buttonState: canSave ? ButtonState.defaultState : ButtonState.disabled,
                    primaryLabel: context.l10n.save,
                    size: ButtonSize.large,
                    onTap: canSave
                        ? () => _handleSave(context, ref, textController, latLng, addressNotifier, isEdit)
                        : null,
                  ),
                ),
                Spacing.$0_5x.heightBox,
                Center(
                  child: Text(
                    context.l10n.dataWillStore,
                    style: context.textStyles.captionMediumRegular.copyWith(color: context.colors.foregroundSoft),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  Future<void> _handleChangeLocation(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<LatLng?> latLng,
    ValueNotifier<String> addressNotifier,
    MarkerIconMessage? icParkingIcon,
  ) async {
    final result = await context.router.push(const RoutingMapSelectRoute());
    if (result is RoutePoint) {
      latLng.value = LatLng(latitude: result.latitude!, longitude: result.longitude!);
      addressNotifier.value = result is RoutePointCoordinates && result.label != null
          ? result.label!
          : 'latitude: ${result.latitude}, longitude:${result.longitude}';

      final dgisMapController = ref.read(parkingSpotMapProvider.notifier);
      await dgisMapController.setCameraPosition(
        GeoPointWithElevationMessage(
          latitude: latLng.value!.latitude,
          longitude: latLng.value!.longitude,
          elevation: 0,
        ),
      );
      await dgisMapController.deleteMarkers();
      await dgisMapController.addMarker(
        Marker(
          id: parkingId,
          options: MarkerOptionsMessage(
            position: GeoPointWithElevationMessage(
              latitude: latLng.value!.latitude,
              longitude: latLng.value!.longitude,
              elevation: 0,
            ),
            icon: icParkingIcon,
          ),
        ),
      );
    }
  }

  Future<void> _handleSave(
    BuildContext context,
    WidgetRef ref,
    TextEditingController textController,
    ValueNotifier<LatLng?> latLng,
    ValueNotifier<String> addressNotifier,
    bool isEdit,
  ) async {
    final parkingManage = ref.read(parkingManageProvider(theme: context.read<ThemeController>().currentTheme).notifier);
    final images = ref.read(parkingImageProvider(theme: context.read<ThemeController>().currentTheme, isEdit: isEdit));

    if (latLng.value == null) {
      return;
    }

    await parkingManage.saveStore(
      ParkingStoreModel(
        dateTime: DateTime.now(),
        imagesPaths: images.map((e) => e.path).toList(),
        comment: textController.text,
        lat: latLng.value!.latitude,
        lon: latLng.value!.longitude,
        address: addressNotifier.value,
      ),
    );

    callToast(context, ref, latLng);
    await context.router.maybePop();
  }

  void callToast(BuildContext context, WidgetRef ref, ValueNotifier<LatLng?> latLng) {
    ToastOverlay.of(context).show(
      title: context.l10n.parkingSuccessfullySaved,
      icon: ToastIconAsset(Assets.icons.svg.parkingControl.keyName),
      actions: [
        ToastAction(title: context.l10n.feedbackBreaksSheetClose),
        ToastAction(
          title: context.l10n.share,
          onTap: () async {
            final markerCoords = latLng.value;
            final coordinates = markerCoords == null
                ? null
                : Coordinates(latitude: markerCoords.latitude, longitude: markerCoords.longitude);
            detach(
              ShareUtil.sharePOI(
                context: context,
                objectId: parkingObjectId.toString(),
                markerCoords: coordinates,
              ),
              tag: 'parkingSpotPage.sharePOI',
            );
          },
        ),
      ],
    );
  }
}
