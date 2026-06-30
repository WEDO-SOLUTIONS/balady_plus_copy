import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/favourites/favourite_item.dart';
import 'package:mapness/features/favourites/providers/favourite_cache.dart';
import 'package:mapness/features/parking_spot/parking_manage.dart';
import 'package:mapness/features/poi_card/enums/contacts_info_type.dart';
import 'package:mapness/features/poi_card/enums/poi_card_bottom_sheet_state.dart';
import 'package:mapness/features/poi_card/extensions/poi_content/src/poi_content_contacts.dart';
import 'package:mapness/features/poi_card/provider/poi_card_actions_provider.dart';
import 'package:mapness/features/routing/providers/current_route.dart';
import 'package:mapness/features/special_themes/core/special_theme_mode.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/analytic/bss_service.dart';
import 'package:mapness/shared/providers/analytic/extension/bss_ext.dart';
import 'package:mapness/shared/providers/analytic/models/payload/bss_payload.dart';
import 'package:mapness/shared/ui/toast/toast_overlay.dart';
import 'package:mapness/widgets/helpers/throttled_callback_widget.dart';
import 'package:sheetify/multi_state_sheet/multi_state_sheet.dart';

const _buttonColorScheme = ButtonColorScheme.accentSecondary;
const _lifestyleBorderRadius = 4.0;
const _lifestyleIconSize = 15.0;

class _PoiFooterActionStyle {
  final bool useLifestyleStyle;
  final BorderSide? secondaryBorder;
  final Color? secondaryBackground;
  final Color directionsBackground;
  final Color directionsForeground;

  const _PoiFooterActionStyle({
    required this.useLifestyleStyle,
    required this.secondaryBorder,
    required this.secondaryBackground,
    required this.directionsBackground,
    required this.directionsForeground,
  });

  factory _PoiFooterActionStyle.of(BuildContext context, WidgetRef ref) {
    final useLifestyleStyle = ref.watch(specialThemeModeProvider) == SpecialThemeMode.base;
    final colors = context.colors;
    final theme = context.read<ThemeController>().currentTheme;
    final isDgaDark = theme == BaladyAppThemes.darkDGA;
    final isDgaLight = theme == BaladyAppThemes.lightDGA;

    return _PoiFooterActionStyle(
      useLifestyleStyle: useLifestyleStyle,
      secondaryBorder: useLifestyleStyle ? BorderSide(color: colors.borderDefault, width: 1) : null,
      secondaryBackground: isDgaDark
          ? colors.neutralMuted
          : isDgaLight
          ? colors.neutralOnNeutral
          : useLifestyleStyle
          ? colors.backgroundSurface1
          : null,
      directionsBackground: colors.accentSecondaryDefault,
      directionsForeground: colors.accentSecondaryOnAccentSecondary,
    );
  }

  ItemActionBar directions({
    required BuildContext context,
    required VoidCallback onPressed,
  }) {
    return ItemActionBar(
      icon: TransportIcons.locationDirectionNavigator,
      buttonType: useLifestyleStyle ? ButtonType.secondary : ButtonType.primary,
      colorScheme: _buttonColorScheme,
      label: context.l10n.poiCardDirections,
      innerPadding: const EdgeInsets.symmetric(vertical: Spacing.$2x, horizontal: Spacing.$3x),
      bgColor: useLifestyleStyle ? directionsBackground : null,
      labelColor: useLifestyleStyle ? directionsForeground : null,
      iconColor: useLifestyleStyle ? directionsForeground : null,
      onPressed: onPressed,
    );
  }

  ItemActionBar secondary({
    required IconData icon,
    required VoidCallback onPressed,
    String? label,
    EdgeInsetsGeometry? innerPadding,
    ButtonType buttonType = ButtonType.secondary,
  }) {
    return ItemActionBar(
      icon: icon,
      buttonType: buttonType,
      colorScheme: _buttonColorScheme,
      label: label,
      innerPadding: innerPadding,
      border: secondaryBorder,
      borderRadius: useLifestyleStyle ? _lifestyleBorderRadius : null,
      bgColor: secondaryBackground,
      iconSize: useLifestyleStyle ? _lifestyleIconSize : null,
      onPressed: onPressed,
    );
  }
}

class PoiCardFooter extends HookConsumerWidget {
  static const double height = 40;
  static const double padding = 12;
  static const iconAsset = 'packages/mapness/assets/icons/svg/ic_complete.svg';

  final Color? color;
  final Curve? curve;
  final Duration? duration;
  final DirectoryObjectMessage? data;
  final Future Function() share;
  final VoidCallback? callPhone;
  final VoidCallback? onEntranceTap;
  final VoidCallback onTapCar;
  final VoidCallback onAddPointToRoute;
  final VoidCallback onRemovePointFromRoute;
  final void Function(FavouriteItem? favouriteItem) onTapFavorite;
  final LatLng? closestPoint;
  final MultiStateSheetController<PoiCardBottomSheetState>? bottomSheetController;

  const PoiCardFooter({
    required this.share,
    required this.onTapCar,
    required this.onAddPointToRoute,
    required this.onRemovePointFromRoute,
    required this.onTapFavorite,
    this.color,
    this.curve,
    this.duration,
    this.callPhone,
    this.onEntranceTap,
    this.data,
    this.closestPoint,
    this.bottomSheetController,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayShadow = useState(true);
    final bottomSheetController = this.bottomSheetController;

    if (bottomSheetController != null) {
      useEffect(() {
        void updateShadow() {
          final isHidden =
              bottomSheetController.state == PoiCardBottomSheetState.hidden &&
              bottomSheetController.interpolation == 0.0;
          if (!isHidden != displayShadow.value) {
            displayShadow.value = !isHidden;
          }
        }

        bottomSheetController.addListener(updateShadow);

        return () => bottomSheetController.removeListener(updateShadow);
      });
    }

    final objectId = data?.id?.objectId;

    ref.watch(favouriteCacheProvider).value;
    final currentRoute = ref.watch(currentRouteProvider);
    final provider = ref.watch(favouriteCacheProvider.notifier);
    final isFavourite = objectId != null && provider.isFavourite(objectId);
    final favouriteItem = objectId != null ? provider.getFavouriteOrNull(objectId) : null;
    const iconData = SystemIcons.bookmark;

    final hasEntrances = data?.entrances.isNotEmpty == true;
    final hasContacts = data?.contactInfos.isNotEmpty == true;
    final hasContactsAndHasEntrances = hasContacts && hasEntrances;

    final callPhone = this.callPhone;
    final onEntranceTap = this.onEntranceTap;

    final type = data?.types.firstOrNull?.type;
    final hasMetro =
        type == ObjectTypeMessage.stationMetro ||
        type == ObjectTypeMessage.station ||
        type == ObjectTypeMessage.stationPlatform ||
        type == ObjectTypeMessage.stationEntrance;

    final website = data?.getContactsInfoModels
        .firstWhereOrNull((element) => element.type == ContactsInfoType.website)
        ?.value;

    final poiActions = ref.read(poiCardActionsProvider.notifier);

    final parkingPoi = objectId == parkingObjectId;
    final actionStyle = _PoiFooterActionStyle.of(context, ref);

    return ThrottledCallbackWidget(
      callback: () {
        share();
      },
      resetAfterFutureCompleted: true,
      builder: (context, throttledShare) => BottomActionBar(
        duration: duration,
        curve: curve,
        color: color,
        displayShadow: displayShadow.value,
        items: [
          actionStyle.directions(context: context, onPressed: onTapCar),
          if (!parkingPoi && isFavourite)
            actionStyle.secondary(
              icon: iconData,
              buttonType: actionStyle.useLifestyleStyle ? ButtonType.secondary : ButtonType.primary,
              onPressed: () => onTapFavorite(favouriteItem),
            ),
          if (currentRoute != null && objectId != null && !currentRoute.isStartOrFinishPOI(objectId))
            if (!currentRoute.containsIntermediatePOI(objectId))
              actionStyle.secondary(
                icon: TransportIcons.addStop,
                label: context.l10n.addStop,
                innerPadding: const EdgeInsets.symmetric(vertical: Spacing.$2x, horizontal: Spacing.$3x),
                onPressed: onAddPointToRoute,
              )
            else
              actionStyle.secondary(
                icon: SystemIcons.closeSmall,
                buttonType: ButtonType.primary,
                label: context.l10n.deletePoint,
                innerPadding: const EdgeInsets.symmetric(vertical: Spacing.$2x, horizontal: Spacing.$3x),
                onPressed: onRemovePointFromRoute,
              ),
          if (hasContactsAndHasEntrances && callPhone != null)
            actionStyle.secondary(
              icon: context.isLTR ? GeneralIcons.phoneLTR : GeneralIcons.phoneRTL,
              label: hasContactsAndHasEntrances ? null : context.l10n.call,
              onPressed: callPhone,
            ),
          if (website != null && data != null)
            actionStyle.secondary(
              icon: GeneralIcons.web,
              onPressed: () {
                BssService.instance.trackLinkTap(data!, BssContactType.website, website);
                poiActions.launch(website);
              },
            ),
          if (hasEntrances && onEntranceTap != null && !hasMetro)
            actionStyle.secondary(
              icon: GeneralIcons.doorEntrance,
              onPressed: onEntranceTap,
            ),
          if (!parkingPoi && !isFavourite)
            actionStyle.secondary(
              icon: iconData,
              onPressed: () => onTapFavorite(favouriteItem),
            ),
          actionStyle.secondary(
            icon: SystemIcons.share,
            onPressed: throttledShare,
          ),
          if (!parkingPoi)
            actionStyle.secondary(
              icon: SystemIcons.parkingAdd,
              onPressed: () => _onParkingTab(ref, context),
            ),
          if (parkingPoi)
            actionStyle.secondary(
              icon: SystemIcons.edit,
              onPressed: () => context.router.push(ParkingSpotRoute(isEdit: true)),
            ),
          if (parkingPoi)
            actionStyle.secondary(
              icon: GeneralIcons.trash,
              onPressed: () => _onTrashTab(ref, context),
            ),
        ],
      ),
    );
  }

  void _onParkingTab(WidgetRef ref, BuildContext context) {
    final hasParking =
        ref.read(parkingManageProvider(theme: context.read<ThemeController>().currentTheme)).value != null;
    if (hasParking) {
      context.router.push(
        ParkingDialogRoute(
          title: context.l10n.createNewParkingSpot,
          desc: context.l10n.currentParkingSpaceRemoved,
          onAcceptTab: () async {
            // BSA-2734: popAndPush have a bug when we have a bottom sheet open
            // We need to make it consistent with popForced
            context.router.pop();
            await Future.delayed(Duration.zero);
            await context.router.push(
              ParkingSpotRoute(
                address: data?.title,
                markerPosition: closestPoint != null
                    ? GeoPointWithElevationMessage(
                        latitude: closestPoint!.latitude,
                        longitude: closestPoint!.longitude,
                        elevation: 0,
                      )
                    : data?.markerPosition,
              ),
            );
          },
          onCancelTab: context.router.pop,
        ),
      );
    } else {
      context.router.push(
        ParkingSpotRoute(
          address: data?.title,
          markerPosition: closestPoint != null
              ? GeoPointWithElevationMessage(
                  latitude: closestPoint!.latitude,
                  longitude: closestPoint!.longitude,
                  elevation: 0,
                )
              : data?.markerPosition,
        ),
      );
    }
  }

  void _onTrashTab(WidgetRef ref, BuildContext context) {
    context.router.push(
      ParkingDialogRoute(
        title: context.l10n.youSureWantDelete,
        onAcceptTab: () {
          ref.read(parkingManageProvider(theme: context.read<ThemeController>().currentTheme).notifier).clearStore();
          ToastOverlay.of(context).show(title: context.l10n.parkingSpotDeleted, icon: const ToastIconAsset(iconAsset));
          context.router.popUntilRouteWithName(BottomMenuRoute.name);
        },
        onCancelTab: context.router.pop,
      ),
    );
  }
}
