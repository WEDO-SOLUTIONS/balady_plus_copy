import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/components.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/favourites/domain/favourite_item.dart';
import 'package:mapness/_features/favourites/providers/favourite_cache.dart';
import 'package:mapness/app/routes/favourites.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:urbi_utils/urbi_utils.dart';

part 'widgets/routing_favourites_button.dart';

class RoutingFavourites extends ConsumerWidget {
  const RoutingFavourites({
    required this.showBookmark,
    required this.onFavouriteTap,
    super.key,
  });

  final bool showBookmark;
  final void Function(FavouriteItem) onFavouriteTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onFavouritesTap = () async {
      if (showBookmark) {
        await CommonFunctions.authOrOpen(
          context,
          callback: () async {
            final result = await const FavouritesPickerRoute().push(context);

            if (result != null) {
              onFavouriteTap(result as FavouriteItem);
            }
            return;
          },
        );
      }
    };
    final onHomeTap = () async {
      final favouritesState = await ref.read(favouriteCacheProvider.future);
      final home = favouritesState.home;
      if (home == null) {
        await CommonFunctions.authOrOpen(
          context,
          callback: () async {
            await const FavouritesSearchRoute(
              markerType: FavouriteItemMarkerType.home,
            ).push(context);

            final favouritesState = await ref.read(favouriteCacheProvider.future);

            onFavouriteTap(favouritesState.home!);
          },
        );
      } else {
        onFavouriteTap(home);
      }
    };

    final onWorkTap = () async {
      final favouritesState = await ref.read(favouriteCacheProvider.future);
      final work = favouritesState.work;
      if (work == null) {
        await CommonFunctions.authOrOpen(
          context,
          callback: () async {
            await const FavouritesSearchRoute(
              markerType: FavouriteItemMarkerType.work,
            ).push(context);

            final favouritesState = await ref.read(favouriteCacheProvider.future);

            onFavouriteTap(
              favouritesState.work!,
            );
          },
        );
      } else {
        onFavouriteTap(work);
      }
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
            children: <Widget>[
          if (showBookmark)
            _Button(
              icon: SystemIcons.bookmark,
              onTap: onFavouritesTap,
            ),
          _Button(
            icon: GeneralIcons.home,
            onTap: onHomeTap,
          ),
          _Button(
            icon: GeneralIcons.briefcase,
            onTap: onWorkTap,
          ),
        ].insertBetween(Spacing.$3x.widthBox).toList()),
      ),
    );
  }
}
