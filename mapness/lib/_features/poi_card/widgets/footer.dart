import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/favourites/domain/favourite_item.dart';
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

class PoiCardFooter extends ConsumerStatefulWidget {
  final DirectoryObjectMessage data;
  final PoiCardViewModel viewModel;
  final DraggableScrollableController scrollController;
  final void Function() onEntranceTap;

  const PoiCardFooter({
    super.key,
    required this.scrollController,
    required this.data,
    required this.viewModel,
    required this.onEntranceTap,
  });

  @override
  ConsumerState<PoiCardFooter> createState() => _PoiCardFooterState();
}

class _PoiCardFooterState extends ConsumerState<PoiCardFooter> {
  bool isShow = true;

  late RouteSearchPointMessage _finishPoint;

  @override
  void dispose() {
    widget.scrollController.removeListener(listener);
    super.dispose();
  }

  @override
  void initState() {
    _finishPoint = RouteSearchPointMessage(
      coordinates: widget.data.markerPosition!.toGeoPointMessage(),
      objectId: widget.data.id!,
    );
    var scrollController = widget.scrollController;
    scrollController.addListener(listener);

    super.initState();
  }

  void listener() {
    if (widget.scrollController.size < .2) {
      setState(() {
        isShow = false;
      });
    } else {
      setState(() {
        isShow = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isShow) return const SizedBox.shrink();

    final model = PoiModel(
      directoryObjectMessage: widget.data,
    );

    final objectMessage = model.directoryObjectMessage;
    final hasEntrances = objectMessage?.entrances.isNotEmpty == true;
    final hasContacts = objectMessage?.contactInfos.isNotEmpty == true;
    final carIconFlex = (hasEntrances || hasContacts) ? 3 : 2;

    final isFav = widget.viewModel.isFavourite(model);
    final favData = widget.viewModel.getFavouriteOrNull(model);

    final favouriteItem = favData ??
        FavouriteItem(
          coordinates: Coordinates(
            latitude: objectMessage?.markerPosition?.latitude ?? 0,
            longitude: objectMessage?.markerPosition?.longitude ?? 0,
          ),
          id: 'overriden',
          subtitle: objectMessage?.subtitle ?? '',
          title: objectMessage?.title ?? '',
          entity: FavouriteItemEntity(
            sourceType: EntitySourceType.urbi,
            id: objectMessage?.id?.objectId.toString() ?? 'id',
          ),
        );

    favItem({int flex = 1}) {
      return buildIconButton(
        flex: flex,
        assetName: isFav
            ? 'assets/icons/svg/ic_fav_solid.svg'
            : 'assets/icons/svg/ic_fav_poi.svg',
        onTap: () async {
          final viewModel = widget.viewModel;
          await _onFavTap(favouriteItem);
          if (favData == null) {
            final directoryObjectMessage = objectMessage;
            if (directoryObjectMessage != null) {
              viewModel.addToFavourites(directoryObjectMessage);
            }
          } else {
            viewModel.removeFromFavourite(favData);
          }
        },
        desc: (hasContacts == false)
            ? Text(
                context.l10n.favourites,
                style: Theme.of(context)
                    .extension<ThemeTextStyles>()!
                    .accentS
                    .copyWith(color: colorPrimary.withOpacity(0.5)),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textAlign: TextAlign.start,
              )
            : const SizedBox.shrink(),
      );
    }

    carItem({int flex = 1}) => Flexible(
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
                  startLabel: context.l10n.myLocation,
                  startLatitude: null,
                  startLongitude: null,
                ).pushReplacement(context);
              },
              finishPoint: _finishPoint,
            ),
          ),
        );

    entranceItem({int flex = 1}) => hasEntrances
        ? buildIconButton(
            flex: flex,
            assetName: 'assets/icons/svg/ic_entrance.svg',
            onTap: () => widget.onEntranceTap(),
            // onTap: () => widget.viewModel.onEntranceTap(objectMessage),
            desc: (hasContacts == false)
                ? Text(
                    context.l10n.exits,
                    style: Theme.of(context)
                        .extension<ThemeTextStyles>()!
                        .accentS
                        .copyWith(color: colorPrimary.withOpacity(0.5)),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.start,
                  )
                : const SizedBox.shrink(),
          )
        : const SizedBox.shrink();

    // shareItem({int flex = 1}) => buildIconButton(
    //       flex: flex,
    //       desc: (hasEntrances == false && hasContacts == false)
    //           ? Text(
    //               'يشارك',
    //               style: Theme.of(context).extension<ThemeTextStyles>()!.accentS.copyWith(color: colorPrimary.withOpacity(0.5)),
    //               overflow: TextOverflow.ellipsis,
    //               maxLines: 1,
    //               textAlign: TextAlign.start,
    //             )
    //           : const SizedBox.shrink(),
    //       assetName: 'assets/icons/svg/ic_share.svg',
    //       onTap: () => viewModel.share(objectMessage),
    //     );

    phoneItem({int flex = 1}) => hasContacts
        ? buildIconButton(
            flex: flex,
            assetName: 'assets/icons/svg/ic_phone_poi.svg',
            onTap: () => widget.viewModel.callPhone(data: objectMessage),
          )
        : const SizedBox.shrink();

    final childrenRtl = (hasContacts == false && hasEntrances == false)
        ? [
            // favItem(flex: 2),
            // shareItem(flex: 2),
            carItem(flex: 2),
          ]
        : [
            // shareItem(flex: 2),
            if (hasEntrances) entranceItem(flex: 2),
            if (hasContacts) phoneItem(flex: 2),
            // favItem(flex: 2),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: childrenRtl,
          ),
        ),
      ),
    );
  }

  Future<void> _onFavTap(FavouriteItem favouriteItem) async {
    CommonFunctions.authOrOpen(ref, context, callback: () {
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
                    child: PoiFavoriteDialog(favItem: favouriteItem),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
