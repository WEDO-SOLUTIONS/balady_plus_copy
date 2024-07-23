import 'dart:async';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/favourites/domain/extensions/extensions.dart';
import 'package:mapness/_features/favourites/domain/favourite_item.dart';
import 'package:mapness/_features/favourites/providers/favourite_cache.dart';
import 'package:mapness/_features/happiness_map/domain/happiness_feedback.dart';
import 'package:mapness/_features/poi_card/extensions/geopoint_mapper.dart';
import 'package:mapness/_features/poi_card/widgets/poi_favorite_dialog.dart';
import 'package:mapness/entities/routing/route_search_point.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/brief_route_info_message_ext.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/map/find_brief_route_info.dart';

class PoiCardFooter extends ConsumerWidget {
  static const double height = 40;
  static const double padding = 8;

  final DirectoryObjectMessage data;
  final VoidCallback share;
  final VoidCallback callPhone;
  final VoidCallback onEntranceTap;
  final VoidCallback onTapCar;
  final RouteSearchPoint finishPoint;

  PoiCardFooter({
    required this.data,
    required this.share,
    required this.callPhone,
    required this.onEntranceTap,
    required this.onTapCar,
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

    return BottomActionBar(
      items: [
        ItemActionBar(
          icon: TransportIcons.car,
          colorScheme: ButtonColorScheme.primary,
          label: briefInfo?.first.getBriefRouteDescription(context.l10n) ?? '',
          onPressed: onTapCar,
        ),
        if (hasContactsAndHasEntrances)
          ItemActionBar(
            icon: GeneralIcons.phoneLTR,
            colorScheme: ButtonColorScheme.secondary,
            label: context.l10n.call,
            onPressed: callPhone,
          ),
        if (hasEntrances)
          ItemActionBar(
            icon: SystemIcons.turnRight,
            colorScheme: ButtonColorScheme.secondary,
            onPressed: onEntranceTap,
          ),
        ItemActionBar(
          icon: iconData,
          colorScheme: ButtonColorScheme.secondary,
          label: context.l10n.save,
          onPressed: () => _onFavoriteTap(context: context, favouriteItem: favouriteItem, ref: ref),
        ),
        ItemActionBar(
          icon: SystemIcons.share,
          colorScheme: ButtonColorScheme.secondary,
          label: context.l10n.share,
          onPressed: share,
        ),
      ],
    );
  }

  Future<void> _onFavoriteTap({
    required BuildContext context,
    required WidgetRef ref,
    FavouriteItem? favouriteItem,
  }) async {
    await CommonFunctions.authOrOpen(
      context,
      callback: () {
        Metrics.logEventAdvanced(
          MetricsConstants.poiKeys.addToFavorite,
          group: MetricsConstants.poiTag,
          action: MetricAction.tap.toString(),
          props: {
            'objectId': data.id?.objectId,
          },
        );

        final favState = ref.read(favouriteCacheProvider).valueOrNull;
        final favRepo = ref.read(favouriteCacheProvider.notifier);

        /// if already in favourites - remove
        if (favouriteItem != null) {
          favRepo.deleteItem(favouriteItem);
          return;
        }

        FavouriteItem? favItem = favouriteItem;
        if (favItem == null && data.markerPosition != null && data.id != null) {
          favItem = FavouriteItem(
            coordinates: Coordinates(
              latitude: data.markerPosition!.latitude,
              longitude: data.markerPosition!.longitude,
            ),
            id: 'overriden',
            subtitle: data.subtitle,
            title: data.title,
            entity: FavouriteItemEntity(
              sourceType: EntitySourceType.urbi,
              id: data.id!.objectId.toString(),
            ),
          );
        }

        if (favItem == null) {
          return;
        }

        /// do not show dialog if home and work are set
        if (favState?.home != null && favState?.work != null) {
          favRepo.addItem(data.mapToFavourite());
        } else {
          /// show dialog to choose home, work or regular
          _showDialog(context, favItem);
        }
      },
    );
  }

  Future<void> _showDialog(
    BuildContext context,
    FavouriteItem newFavourite,
  ) async {
    await showDialog(
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
                    favItem: newFavourite,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
