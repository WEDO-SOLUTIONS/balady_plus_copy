import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/favourites/favourite_item.dart';
import 'package:mapness/entities/routing/route_search_point.dart';
import 'package:mapness/features/favourites/providers/favourite_cache.dart';
import 'package:mapness/features/parking_spot/parking_manage.dart';
import 'package:mapness/features/poi_card/enums/poi_card_bottom_sheet_state.dart';
import 'package:mapness/features/poi_card/extensions/geopoint_mapper.dart';
import 'package:mapness/shared/extensions/brief_route_info_message_ext.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/map/find_brief_route_info.dart';
import 'package:mapness/shared/ui/toast/toast_overlay.dart';
import 'package:mapness/widgets/helpers/throttled_callback_widget.dart';

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
  final RouteSearchPoint? finishPoint;
  final LatLng? closestPoint;
  final StatefulBottomSheetController<PoiCardBottomSheetState>? bottomSheetController;

  PoiCardFooter({
    required this.share,
    required this.onTapCar,
    required this.onTapFavorite,
    this.callPhone,
    this.onEntranceTap,
    this.data,
    this.closestPoint,
    this.bottomSheetController,
    super.key,
  }) : finishPoint = data != null
            ? RouteSearchPoint(
                coordinates: data.markerPosition!.toGeoPointMessage(),
                dgisObjectId: data.id!,
              )
            : null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final briefInfo = ref.watch(
      briefRouteInfoProvider(
        finishPoint: finishPoint,
        navType: RouteSearchOptionsMessage.car,
      ),
    );
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

    final parkingPoi = objectId == parkingObjectId;
    final brief = briefInfo?.firstOrNull;
    final carParkingLabel = [
      brief?.getBriefRouteDescription(context.l10n),
      brief?.getBriefRouteDistanceDescription(context.l10n),
    ].where((e) => e != null && e.trim().isNotEmpty).join(' ');

    return ThrottledCallbackWidget(
      callback: share,
      resetAfterFutureCompleted: true,
      builder: (context, throttledShare) => BottomActionBar(
        displayShadow: displayShadow.value,
        items: [
          ItemActionBar(
            icon: TransportIcons.car,
            buttonType: BaladyButtonType.primary,
            label: hasContactsAndHasEntrances
                ? null
                : parkingPoi
                    ? carParkingLabel
                    : briefInfo?.firstOrNull?.getBriefRouteDescription(context.l10n) ?? '',
            onPressed: onTapCar,
          ),
          if (hasContactsAndHasEntrances && callPhone != null)
            ItemActionBar(
                icon: GeneralIcons.phoneLTR,
                buttonType: BaladyButtonType.secondary,
                label: hasContactsAndHasEntrances ? null : context.l10n.call,
                onPressed: callPhone),
          if (hasEntrances && onEntranceTap != null)
            ItemActionBar(
              icon: SystemIcons.turnRight,
              buttonType: BaladyButtonType.secondary,
              onPressed: onEntranceTap,
            ),
          if (!parkingPoi)
            ItemActionBar(
              icon: iconData,
              buttonType: BaladyButtonType.secondary,
              label: hasContactsAndHasEntrances ? null : context.l10n.save,
              onPressed: () => onTapFavorite(favouriteItem),
            ),
          ItemActionBar(
            icon: SystemIcons.share,
            buttonType: BaladyButtonType.secondary,
            label: hasContactsAndHasEntrances || parkingPoi ? null : context.l10n.share,
            onPressed: throttledShare,
          ),
          if (!parkingPoi)
            ItemActionBar(
              icon: SystemIcons.parkingAdd,
              buttonType: BaladyButtonType.secondary,
              onPressed: () => _onParkingTab(ref, context),
            ),
          if (parkingPoi)
            ItemActionBar(
              icon: SystemIcons.edit,
              buttonType: BaladyButtonType.secondary,
              onPressed: () => context.router.push(ParkingSpotRoute(isEdit: true)),
            ),
          if (parkingPoi)
            ItemActionBar(
              icon: GeneralIcons.trash,
              buttonType: BaladyButtonType.secondary,
              onPressed: () => _onTrashTab(ref, context),
            ),
        ],
      ),
    );
  }

  void _onParkingTab(WidgetRef ref, BuildContext context) {
    final hasNotParking = ref.read(parkingManageProvider).valueOrNull != null;
    if (hasNotParking) {
      context.router.push(
        ParkingDialogRoute(
          title: context.l10n.createNewParkingSpot,
          desc: context.l10n.currentParkingSpaceRemoved,
          onAcceptTab: () {
            context.router.popAndPush(ParkingSpotRoute(
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
            iconAsset: iconAsset,
          );
          context.router.popUntilRouteWithName(BottomMenuRoute.name);
        },
        onCancelTab: context.router.popForced,
      ),
    );
  }
}
