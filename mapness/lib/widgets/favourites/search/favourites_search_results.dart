import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/favourites/favourite_item.dart';
import 'package:mapness/features/favorite_lists/providers/home_work_favorites.dart';
import 'package:mapness/features/favourites/mappers/directory_object_message_mapper.dart';
import 'package:mapness/features/search/models/search_scope.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/shared/lib/make_address.dart';
import 'package:provider/provider.dart';

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
    final scope = context.read<SearchScope>();
    final contentColor = context.colors.backgroundSurface1;

    final items = results.firstPage?.items;
    final length = items?.length ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x).copyWith(top: Spacing.$1_5x),
          child: Text(
            'Suggested searches',
            style: context.textStyles.captionLargeRegular.copyWith(color: context.colors.foregroundSoft),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: Spacing.$4x, right: Spacing.$4x, bottom: Spacing.$4x, top: Spacing.$3x),
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
                    backgroundColor: context.colors.backgroundSurface1,
                    isDividerEnabled: index != length - 1,
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      await onSearchTap(ref, context, item, ref.read(searchProvider(scope.value).notifier));
                    },
                    leading: GeneralIcons.location.icon(color: context.colors.accentActive),
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
        ),
      ],
    );
  }

  Future<void> onSearchTap(WidgetRef ref, BuildContext context, DirectoryObjectMessage item, Search searcher) async {
    final favItem = item.mapToFavourite();
    switch (markerType) {
      // Every live caller of FavouritesSearchRoute passes home/work only.
      case FavouriteItemMarkerType.unknown:
      case FavouriteItemMarkerType.place:
        break;
      case FavouriteItemMarkerType.home:
        await ref.read(homeWorkFavoritesActionsProvider.notifier).setHome(favItem);
      case FavouriteItemMarkerType.work:
        await ref.read(homeWorkFavoritesActionsProvider.notifier).setWork(favItem);
    }
    // Reset the (autoDispose) search state right before popping — in the same
    // tick, with no `await` in between — so a stale SearchStateResults isn't
    // handed to the next FavouritesSearchRoute, without unmounting this
    // subtree before `setHome`/`setWork` finished (BE-88).
    searcher.clear();
    if (context.mounted && context.router.canPop()) {
      context.router.pop(favItem);
    }
  }
}
