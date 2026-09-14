import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/favourites/favourite_item.dart';
import 'package:mapness/features/favourites/providers/favourite_cache.dart';
import 'package:mapness/shared/lib/auth/auth_methods.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:urbi_utils/urbi_utils.dart';

import '../../../widgets/navi_search/vertical_chip.dart';

part 'widgets/routing_favourites_button.dart';

class RoutingFavourites extends ConsumerWidget {
  final bool showBookmark;
  final void Function(FavouriteItem) onFavouriteTap;

  const RoutingFavourites({
    required this.showBookmark,
    required this.onFavouriteTap,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onFavouritesTap = () async {
      if (showBookmark) {
        await ref
            .read(authMethodsProvider.notifier)
            .authAndOpen(
              context,
              callback: () async {
                final result = await context.router.push(const FavouritesPickerRoute());

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
        await ref
            .read(authMethodsProvider.notifier)
            .authAndOpen(
              context,
              callback: () async {
                final favouritesState = await ref.read(favouriteCacheProvider.future);
                if (favouritesState.home == null) {
                  await context.router.push(
                    FavouritesSearchRoute(
                      markerType: FavouriteItemMarkerType.home,
                    ),
                  );
                } else {
                  onFavouriteTap(favouritesState.home!);
                }
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
        await ref
            .read(authMethodsProvider.notifier)
            .authAndOpen(
              context,
              callback: () async {
                final favouritesState = await ref.read(favouriteCacheProvider.future);
                if (favouritesState.work == null) {
                  await context.router.push(
                    FavouritesSearchRoute(
                      markerType: FavouriteItemMarkerType.work,
                    ),
                  );
                } else {
                  onFavouriteTap(
                    favouritesState.work!,
                  );
                }
              },
            );
      } else {
        onFavouriteTap(work);
      }
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
      child: Directionality(
        // For all design, we use LTR
        textDirection: TextDirection.ltr,
        child: Row(
          children: <Widget>[
            // _FavButton(
            //   icon: GeneralIcons.briefcase,
            //   onTap: onWorkTap,
            //   label: context.l10n.work,
            // ),
            Expanded(
              child: VerticalChip(
                icon: GeneralIcons.briefcase,
                title: context.l10n.work,
                onTap: onWorkTap,
                width: double.infinity,
                height: 75,
              ),
            ),

            Expanded(
              child: VerticalChip(
                icon: GeneralIcons.home,
                title: context.l10n.home,
                onTap: onHomeTap,
                width: double.infinity,
                height: 75,
              ),
            ),
            // _FavButton(
            //   icon: GeneralIcons.home,
            //   onTap: onHomeTap,
            //   label: context.l10n.home,
            // ),
            if (showBookmark)
              Expanded(
                child: VerticalChip(
                  icon: SystemIcons.bookmark,
                  title: context.l10n.favorites,
                  onTap: onFavouritesTap,
                  width: double.infinity,
                  height: 75,
                ),
              ),
            // _FavButton(
            //   icon: SystemIcons.bookmark,
            //   onTap: onFavouritesTap,
            //   label: context.l10n.favorites,
            // ),
          ].insertBetween(Spacing.$3x.widthBox).toList(),
        ),
      ),
    );
  }
}
