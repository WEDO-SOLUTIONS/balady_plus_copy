import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/favourites/favourite_item.dart';
import 'package:mapness/features/favourites/mappers/directory_object_message_mapper.dart';
import 'package:mapness/features/favourites/providers/favourite_cache.dart';
import 'package:mapness/shared/lib/make_address.dart';

class FavouritesSearchResults extends ConsumerWidget {
  const FavouritesSearchResults({
    required this.results,
    required this.scrollController,
    required this.markerType,
    super.key,
  });

  final FavouriteItemMarkerType markerType;
  final SearchResultMessage results;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contentColor = context.colors.backgroundSurface1;

    final items = results.firstPage?.items;
    final length = items?.length ?? 0;

    return Padding(
      padding: const EdgeInsets.only(
        left: Spacing.$4x,
        right: Spacing.$4x,
        bottom: Spacing.$4x,
      ),
      child: Material(
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(RadiusBorder.xl),
        color: contentColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Spacing.$1x),
          child: ListView.builder(
            controller: ScrollController(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: length,
            itemBuilder: (context, index) {
              final item = items![index];

              return ContentRow(
                backgroundColor: context.colors.backgroundSurface4,
                isDividerEnabled: index != length - 1,
                onTap: () async => onSearchTap(ref, context, item),
                leading: GeneralIcons.location.icon(
                  color: context.colors.accentActive,
                ),
                text: ContentRowTextOptions(
                  title: item.title,
                  subtitle: item.makeAddress(),
                  subtitleExtra: item.workStatus!.desc,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> onSearchTap(WidgetRef ref, BuildContext context, DirectoryObjectMessage item) async {
    final favItem = item.mapToFavourite();
    final repo = ref.read(favouriteCacheProvider.notifier);
    unawaited(
      switch (markerType) {
        FavouriteItemMarkerType.unknown || FavouriteItemMarkerType.place => repo.addItem(favItem),
        FavouriteItemMarkerType.home => repo.setHome(favItem),
        FavouriteItemMarkerType.work => repo.setWork(favItem),
      },
    );
    if (context.mounted && context.router.canPop()) {
      context.router.pop();
    }
  }
}
