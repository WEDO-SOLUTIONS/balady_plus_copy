import 'package:balady_uikit/balady_uikit.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/favourites/domain/favourite_item.dart';
import 'package:mapness/_features/favourites/providers/favourite_cache.dart';
import 'package:mapness/entities/routing/route_search_point.dart';
import 'package:mapness/features/poi_card/extensions/geopoint_mapper.dart';
import 'package:mapness/shared/extensions/brief_route_info_message_ext.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/map/find_brief_route_info.dart';
import 'package:mapness/widgets/helpers/throttled_callback_widget.dart';

class PoiCardFooter extends ConsumerWidget {
  static const double height = 40;
  static const double padding = 8;

  final DirectoryObjectMessage data;
  final VoidCallback share;
  final VoidCallback callPhone;
  final VoidCallback onEntranceTap;
  final VoidCallback onTapCar;
  final void Function(FavouriteItem? favouriteItem) onTapFavorite;
  final RouteSearchPoint finishPoint;

  PoiCardFooter({
    required this.data,
    required this.share,
    required this.callPhone,
    required this.onEntranceTap,
    required this.onTapCar,
    required this.onTapFavorite,
    super.key,
  }) : finishPoint = RouteSearchPoint(
          coordinates: data.markerPosition!.toGeoPointMessage(),
          dgisObjectId: data.id!,
        );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final briefInfo = ref.watch(
      briefRouteInfoProvider(
        finishPoint: finishPoint,
        navType: RouteSearchOptionsMessage.car,
      ),
    );

    final objectId = data.id?.objectId;

    ref.watch(favouriteCacheProvider).valueOrNull;
    final provider = ref.watch(favouriteCacheProvider.notifier);
    final isFavourite = objectId != null && provider.isFavourite(objectId);
    final favouriteItem = objectId != null ? provider.getFavouriteOrNull(objectId) : null;
    final iconData = isFavourite ? SystemIcons.bookmarkFill : SystemIcons.bookmark;

    final hasEntrances = data.entrances.isNotEmpty == true;
    final hasContacts = data.contactInfos.isNotEmpty == true;
    final hasContactsAndHasEntrances = hasContacts && hasEntrances;

    return ThrottledCallbackWidget(
      callback: share,
      builder: (context, throttledShare) => BottomActionBar(
        items: [
          ItemActionBar(
            icon: TransportIcons.car,
            buttonType: BaladyButtonType.primary,
            label: hasContactsAndHasEntrances
                ? null
                : briefInfo?.firstOrNull?.getBriefRouteDescription(context.l10n) ?? '',
            onPressed: onTapCar,
          ),
          if (hasContactsAndHasEntrances)
            ItemActionBar(
              icon: GeneralIcons.phoneLTR,
              buttonType: BaladyButtonType.secondary,
              label: hasContactsAndHasEntrances ? null : context.l10n.call,
              onPressed: callPhone,
            ),
          if (hasEntrances)
            ItemActionBar(
              icon: SystemIcons.turnRight,
              buttonType: BaladyButtonType.secondary,
              onPressed: onEntranceTap,
            ),
          ItemActionBar(
            icon: iconData,
            buttonType: BaladyButtonType.secondary,
            label: hasContactsAndHasEntrances ? null : context.l10n.save,
            onPressed: () => onTapFavorite(favouriteItem),
          ),
          ItemActionBar(
            icon: SystemIcons.share,
            buttonType: BaladyButtonType.secondary,
            label: hasContactsAndHasEntrances ? null : context.l10n.share,
            onPressed: throttledShare,
          ),
        ],
      ),
    );
  }
}
