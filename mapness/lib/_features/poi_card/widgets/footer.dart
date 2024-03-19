import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/favourites/domain/extensions/extensions.dart';
import 'package:mapness/_features/favourites/domain/favourite_item.dart';
import 'package:mapness/_features/favourites/providers/favourite_repository.dart';
import 'package:mapness/_features/happiness_map/domain/happiness_feedback.dart';
import 'package:mapness/_features/poi_card/extensions/geopoint_mapper.dart';
import 'package:mapness/_features/poi_card/poi_card_view_model.dart';
import 'package:mapness/_features/poi_card/widgets/poi_favorite_dialog.dart';
import 'package:mapness/_features/poi_card/widgets/style.dart';
import 'package:mapness/app/routes/routing.dart';
import 'package:mapness/features/routing/ui/brief_route_widgets.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/shared/providers/map/point_of_interest.dart';

class PoiCardFooter extends ConsumerWidget {
  PoiCardFooter({
    required this.data,
    required this.viewModel,
    required this.onEntranceTap,
    super.key,
  }) {
    _finishPoint = RouteSearchPointMessage(
      coordinates: data.markerPosition!.toGeoPointMessage(),
      objectId: data.id!,
    );
  }
  final DirectoryObjectMessage data;
  final PoiCardViewModel viewModel;
  final void Function() onEntranceTap;
  late final RouteSearchPointMessage _finishPoint;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = PoiModel(
      directoryObjectMessage: data,
    );

    final objectMessage = model.directoryObjectMessage;
    final hasEntrances = objectMessage?.entrances.isNotEmpty == true;
    final hasContacts = objectMessage?.contactInfos.isNotEmpty == true;
    final carIconFlex = (hasEntrances || hasContacts) ? 3 : 2;

    /// redraw footer if fav repo changes. Do not remove, entail bug with multi fav add!
    ref.watch(favouriteRepositoryProvider).valueOrNull;
    final provider = ref.watch(favouriteRepositoryProvider.notifier);

    final isFav =
        provider.isFavourite(model.directoryObjectMessage?.id?.objectId);
    final favData =
        provider.getFavouriteOrNull(model.directoryObjectMessage?.id?.objectId);

    Widget favItem({int flex = 1}) => buildIconButton(
          flex: flex,
          assetName: isFav
              ? 'assets/icons/svg/ic_fav_solid.svg'
              : 'assets/icons/svg/ic_fav_poi.svg',
          colorIcon: context.color.text_and_icons_status_accent,
          onTap: () => _onFavTap(
            context: context,
            favouriteItem: favData,
            ref: ref,
          ),
          // desc: (hasContacts == false)
          //     ? Text(
          //         context.l10n.favourites,
          //         style: Theme.of(context)
          //             .extension<ThemeTextStyles>()!
          //             .accentS
          //             .copyWith(color: context.color.text_and_icons_base_primary.withOpacity(0.5)),
          //         overflow: TextOverflow.ellipsis,
          //         maxLines: 1,
          //         textAlign: TextAlign.start,
          //       )
          //     : const SizedBox.shrink(),
        );

    Widget carItem({int flex = 1}) => Flexible(
          flex: flex,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: BriefRouteButton(
              routeType: RouteSearchOptionsMessage.car,
              onTap: () {
                RoutingRoutesRoute(
                  finishLabel: objectMessage!.title,
                  finishLatitude: objectMessage.markerPosition!.latitude,
                  finishLongitude: objectMessage.markerPosition!.longitude,
                  finishObjectId: objectMessage.id?.objectId,
                  finishEntranceId: objectMessage.id?.entranceId,
                  finishLevelId: objectMessage.levelId,
                  startLabel: context.l10n.myLocation,
                  startLatitude: null,
                  startLongitude: null,
                  startObjectId: null,
                  startEntranceId: null,
                  startLevelId: null,
                ).pushReplacement(context);
              },
              finishPoint: _finishPoint,
            ),
          ),
        );

    Widget entranceItem({int flex = 1}) => hasEntrances
        ? buildIconButton(
            flex: flex,
            assetName: 'assets/icons/svg/ic_entrance.svg',
            onTap: onEntranceTap,
            // onTap: () => widget.viewModel.onEntranceTap(objectMessage),
            // desc: (hasContacts == false)
            //     ? Text(
            //         context.l10n.exits,
            //         style: Theme.of(context)
            //             .extension<ThemeTextStyles>()!
            //             .accentS
            //             .copyWith(color: context.color.text_and_icons_base_primary.withOpacity(0.5)),
            //         overflow: TextOverflow.ellipsis,
            //         maxLines: 1,
            //         textAlign: TextAlign.start,
            //       )
            //     : const SizedBox.shrink(),
          )
        : const SizedBox.shrink();

    // shareItem({int flex = 1}) => buildIconButton(
    //       flex: flex,
    //       desc: (hasEntrances == false && hasContacts == false)
    //           ? Text(
    //               'يشارك',
    //               style: Theme.of(context).extension<ThemeTextStyles>()!.accentS.copyWith(color: context.color.text_and_icons_base_primary.withOpacity(0.5)),
    //               overflow: TextOverflow.ellipsis,
    //               maxLines: 1,
    //               textAlign: TextAlign.start,
    //             )
    //           : const SizedBox.shrink(),
    //       assetName: 'assets/icons/svg/ic_share.svg',
    //       onTap: () => viewModel.share(objectMessage),
    //     );

    Widget phoneItem({int flex = 1}) => hasContacts
        ? buildIconButton(
            flex: flex,
            assetName: 'assets/icons/svg/ic_phone_poi.svg',
            onTap: () => viewModel.callPhone(data: objectMessage),
          )
        : const SizedBox.shrink();

    final childrenRtl = (hasContacts == false && hasEntrances == false)
        ? [
            favItem(flex: 2),
            // shareItem(flex: 2),
            carItem(flex: 2),
          ]
        : [
            // shareItem(flex: 2),
            if (hasEntrances) entranceItem(flex: 2),
            if (hasContacts) phoneItem(flex: 2),
            favItem(flex: 2),
            carItem(flex: carIconFlex),
          ];

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(8),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: footerHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: childrenRtl,
          ),
        ),
      ),
    );
  }

  Future<void> _onFavTap({
    required BuildContext context,
    required WidgetRef ref,
    FavouriteItem? favouriteItem,
  }) async {
    await CommonFunctions.authOrOpen(
      context,
      callback: () {
        final favState = ref.read(favouriteRepositoryProvider).valueOrNull;
        final favRepo = ref.read(favouriteRepositoryProvider.notifier);
        final objectMessage = data;

        final newFav = FavouriteItem(
          coordinates: Coordinates(
            latitude: objectMessage.markerPosition?.latitude ?? 0,
            longitude: objectMessage.markerPosition?.longitude ?? 0,
          ),
          id: 'overriden',
          subtitle: objectMessage.subtitle,
          title: objectMessage.title,
          entity: FavouriteItemEntity(
            sourceType: EntitySourceType.urbi,
            id: objectMessage.id?.objectId.toString() ?? 'id',
          ),
        );

        /// if already in favourites - remove
        if (favouriteItem != null) {
          favRepo.delete(favouriteItem);
          return;
        }

        /// do not show dialog if home and work are set
        if (favState?.home != null && favState?.work != null) {
          favRepo.addItem(objectMessage.mapToFavourite());
        } else {
          /// show dialog to choose home, work or regular
          showDialog(
            // barrierColor: Colors.transparent,
            useSafeArea: false,
            context: context,
            builder: (contextDialog) => ProviderScope(
              parent: ProviderScope.containerOf(context),
              child: Theme(
                data: Theme.of(context),
                child: MediaQuery(
                  data: MediaQuery.of(context),
                  child: Directionality(
                    textDirection: Directionality.of(context),
                    child: Localizations.override(
                      context: context,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: PoiFavoriteDialog(
                          favItem: newFav,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
