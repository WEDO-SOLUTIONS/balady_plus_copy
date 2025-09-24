import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/entities/favourites/favourite_item.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/features/favourites/providers/favourite_cache.dart';
import 'package:mapness/features/poi_card/enums/contacts_info_type.dart';
import 'package:mapness/features/poi_card/extensions/poi_content/src/poi_content_contacts.dart';
import 'package:mapness/features/poi_card/provider/poi_card_actions_provider.dart';
import 'package:mapness/pages/poi_card/poi_card_widget_page.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/auth/auth_methods.dart';
import 'package:mapness/widgets/helpers/throttled_callback_widget.dart';

class SearchItemQuickActions extends HookConsumerWidget {
  final DirectoryObjectMessage directoryObject;

  const SearchItemQuickActions({
    required this.directoryObject,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final objectId = directoryObject.id?.objectId;

    ref.watch(favouriteCacheProvider).valueOrNull;
    final provider = ref.watch(favouriteCacheProvider.notifier);
    final isFavourite = objectId != null && provider.isFavourite(objectId);
    final favouriteItem = objectId != null ? provider.getFavouriteOrNull(objectId) : null;
    final iconData = isFavourite ? SystemIcons.bookmarkFill : SystemIcons.bookmark;

    final poiActions = ref.read(poiCardActionsProvider.notifier);

    final phoneNumber = directoryObject.getContactsInfoModels
        .firstWhereOrNull(
          (element) => element.type == ContactsInfoType.phone,
        )
        ?.value;

    final website = directoryObject.getContactsInfoModels
        .firstWhereOrNull(
          (element) => element.type == ContactsInfoType.website,
        )
        ?.value;

    final actions = [
      ItemActionBar(
        icon: TransportIcons.locationDirectionNavigator,
        buttonType: ButtonType.secondary,
        colorScheme: ButtonColorScheme.accent,
        label: context.l10n.poiCardDirections,
        innerPadding: const EdgeInsets.symmetric(vertical: Spacing.$2x, horizontal: Spacing.$3x),
        onPressed: () {
          openRoutingRoutes(
            context,
            directoryObject.id!.objectId,
            directoryObject.title,
            RouteParamsPoint(
              latitude: directoryObject.markerPosition!.latitude,
              longitude: directoryObject.markerPosition!.longitude,
              objectId: directoryObject.id?.objectId,
              entranceId: directoryObject.id?.entranceId,
              levelId: directoryObject.levelId,
            ),
            ref,
          );
        },
      ),
      ItemActionBar(
        icon: iconData,
        buttonType: ButtonType.secondary,
        colorScheme: ButtonColorScheme.accent,
        onPressed: () {
          _onFavoriteTap(
            context: context,
            ref: ref,
            data: directoryObject,
            favouriteItem: favouriteItem,
          );
        },
      ),
      ThrottledCallbackWidget(
        callback: () {
          final markerPosition = directoryObject.markerPosition;
          final latLng = markerPosition != null
              ? LatLng(latitude: markerPosition.latitude, longitude: markerPosition.longitude)
              : null;

          poiActions.share(
            objectId: objectId,
            markerCoords: latLng,
          );
        },
        resetAfterFutureCompleted: true,
        builder: (context, throttledShare) => ItemActionBar(
          icon: SystemIcons.share,
          colorScheme: ButtonColorScheme.accent,
          buttonType: ButtonType.secondary,
          onPressed: throttledShare,
        ),
      ),
      if (phoneNumber != null)
        ItemActionBar(
          icon: GeneralIcons.phoneLTR,
          colorScheme: ButtonColorScheme.accent,
          buttonType: ButtonType.secondary,
          onPressed: () => poiActions.callPhone(phoneNumber),
        ),
      if (website != null)
        ItemActionBar(
          icon: GeneralIcons.web,
          colorScheme: ButtonColorScheme.accent,
          buttonType: ButtonType.secondary,
          onPressed: () => poiActions.launch(website),
        ),
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.$3x),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: Spacing.$10x + Spacing.$3x),
        child: Padding(
          padding: const EdgeInsets.only(top: Spacing.$3x),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
            itemBuilder: (context, index) => actions.elementAt(index),
            separatorBuilder: (context, index) => Spacing.$2x.widthBox,
            itemCount: actions.length,
          ),
        ),
      ),
    );
  }
}

Future<void> _onFavoriteTap({
  required BuildContext context,
  required WidgetRef ref,
  required DirectoryObjectMessage data,
  required FavouriteItem? favouriteItem,
}) async {
  await ref.read(authMethodsProvider.notifier).authOrOpen(
    context,
    callback: () {
      toggleFavoriteDirectoryObject(context: context, ref: ref, data: data, favouriteItem: favouriteItem);
    },
  );
}
