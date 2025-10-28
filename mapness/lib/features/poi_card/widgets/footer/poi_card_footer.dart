import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/favourites/favourite_item.dart';
import 'package:mapness/features/favourites/providers/favourite_cache.dart';
import 'package:mapness/features/parking_spot/parking_manage.dart';
import 'package:mapness/features/poi_card/enums/poi_card_bottom_sheet_state.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/toast/toast_overlay.dart';
import 'package:mapness/widgets/helpers/throttled_callback_widget.dart';
import 'package:sheetify/multi_state_sheet/multi_state_sheet.dart';

class PoiCardFooter extends HookConsumerWidget {
  static const double height = 40;
  static const double padding = 12;
  static const iconAsset = 'packages/mapness/assets/icons/svg/ic_complete.svg';

  final DirectoryObjectMessage? data;
  final Future Function() share;
  final VoidCallback? callPhone;
  final VoidCallback? onEntranceTap;
  final VoidCallback onTapCar;
  final void Function(FavouriteItem? favouriteItem) onTapFavorite;
  final LatLng? closestPoint;
  final MultiStateSheetController<PoiCardBottomSheetState>? bottomSheetController;

  const PoiCardFooter({
    required this.share,
    required this.onTapCar,
    required this.onTapFavorite,
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
          final isHidden = bottomSheetController.state == PoiCardBottomSheetState.hidden &&
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

    ref.watch(favouriteCacheProvider).valueOrNull;
    final provider = ref.watch(favouriteCacheProvider.notifier);
    final isFavourite = objectId != null && provider.isFavourite(objectId);
    final favouriteItem = objectId != null ? provider.getFavouriteOrNull(objectId) : null;
    final iconData = isFavourite ? SystemIcons.bookmarkFill : SystemIcons.bookmark;

    final hasEntrances = data?.entrances.isNotEmpty == true;
    final hasContacts = data?.contactInfos.isNotEmpty == true;
    final hasContactsAndHasEntrances = hasContacts && hasEntrances;

    final callPhone = this.callPhone;
    final onEntranceTap = this.onEntranceTap;

    final type = data?.types.firstOrNull?.type;
    final hasMetro = type == ObjectTypeMessage.stationMetro ||
        type == ObjectTypeMessage.station ||
        type == ObjectTypeMessage.stationPlatform ||
        type == ObjectTypeMessage.stationEntrance;

    final parkingPoi = objectId == parkingObjectId;

    return ThrottledCallbackWidget(
      callback: share,
      resetAfterFutureCompleted: true,
      builder: (context, throttledShare) => BottomActionBar(
        displayShadow: displayShadow.value,
        items: [
          ItemActionBar(
            icon: TransportIcons.locationDirectionNavigator,
            buttonType: ButtonType.primary,
            label: context.l10n.poiCardDirections,
            innerPadding: const EdgeInsets.symmetric(vertical: Spacing.$2x, horizontal: Spacing.$3x),
            onPressed: onTapCar,
          ),
          if (hasContactsAndHasEntrances && callPhone != null)
            ItemActionBar(
              icon: GeneralIcons.phoneLTR,
              buttonType: ButtonType.secondary,
              colorScheme: ButtonColorScheme.accent,
              label: hasContactsAndHasEntrances ? null : context.l10n.call,
              onPressed: callPhone,
            ),
          if (hasEntrances && onEntranceTap != null && !hasMetro)
            ItemActionBar(
              icon: SystemIcons.turnRight,
              buttonType: ButtonType.secondary,
              colorScheme: ButtonColorScheme.accent,
              onPressed: onEntranceTap,
            ),
          if (!parkingPoi)
            ItemActionBar(
              icon: iconData,
              buttonType: ButtonType.secondary,
              colorScheme: ButtonColorScheme.accent,
              onPressed: () => onTapFavorite(favouriteItem),
            ),
          ItemActionBar(
            icon: SystemIcons.share,
            buttonType: ButtonType.secondary,
            colorScheme: ButtonColorScheme.accent,
            onPressed: throttledShare,
          ),
          if (!parkingPoi)
            ItemActionBar(
              icon: SystemIcons.parkingAdd,
              buttonType: ButtonType.secondary,
              colorScheme: ButtonColorScheme.accent,
              onPressed: () => _onParkingTab(ref, context),
            ),
          if (parkingPoi)
            ItemActionBar(
              icon: SystemIcons.edit,
              buttonType: ButtonType.secondary,
              colorScheme: ButtonColorScheme.accent,
              onPressed: () => context.router.push(ParkingSpotRoute(isEdit: true)),
            ),
          if (parkingPoi)
            ItemActionBar(
              icon: GeneralIcons.trash,
              buttonType: ButtonType.secondary,
              colorScheme: ButtonColorScheme.accent,
              onPressed: () => _onTrashTab(ref, context),
            ),
        ],
      ),
    );
  }

  void _onParkingTab(WidgetRef ref, BuildContext context) {
    final hasParking = ref.read(parkingManageProvider).valueOrNull != null;
    if (hasParking) {
      context.router.push(
        ParkingDialogRoute(
          title: context.l10n.createNewParkingSpot,
          desc: context.l10n.currentParkingSpaceRemoved,
          onAcceptTab: () async {
            // BSA-2734: popAndPush have a bug when we have a bottom sheet open
            // We need to make it consistent with popForced
            context.router.popForced();
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
          onCancelTab: context.router.popForced,
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
          ref.read(parkingManageProvider.notifier).clearStore();
          ToastOverlay.of(context).show(
            title: context.l10n.parkingSpotDeleted,
            icon: const ToastIconAsset(iconAsset),
          );
          context.router.popUntilRouteWithName(BottomMenuRoute.name);
        },
        onCancelTab: context.router.popForced,
      ),
    );
  }
}
