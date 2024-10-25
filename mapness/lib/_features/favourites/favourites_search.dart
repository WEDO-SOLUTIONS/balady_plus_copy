import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/favourites/domain/extensions/extensions.dart';
import 'package:mapness/_features/favourites/domain/favourite_item.dart';
import 'package:mapness/_features/favourites/providers/favourite_cache.dart';
import 'package:mapness/_features/favourites/widgets/screen/search_screen.dart';
import 'package:mapness/features/search/ui/search_scope.dart';
import 'package:mapness/shared/lib/make_address.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/suggest.dart';

@RoutePage()
class FavouritesSearchPage extends StatelessWidget {
  final FavouriteItemMarkerType markerType;

  const FavouritesSearchPage({
    required this.markerType,
    super.key,
  });

  @override
  Widget build(BuildContext context) => SearchScope(
        named: SearchScopeEnum.map,
        child: Material(
          child: FavouritesSearch(
            markerType: FavouriteItemMarkerType.values.firstWhere(
              (element) => element.name == markerType.name,
              orElse: () => FavouriteItemMarkerType.place,
            ),
          ),
        ),
      );
}

class FavouritesSearch extends ConsumerWidget {
  const FavouritesSearch({required this.markerType, super.key});

  final FavouriteItemMarkerType markerType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchResult = (ref.watch(suggestResultsProvider).value ?? [])
        .map((element) => element.handler.objectHandler)
        .whereType<SuggestObjectHandlerMessage>()
        .map((e) => e.item)
        .toList();

    return SearchScreen(
      hintText: markerType.getHintText(context),
      onHistoryItemTap: (item) async {
        final dgisController = await ref.read(dgisControllerProvider.future);

        final object = await dgisController.searchByObjectId(
          DgisObjectIdMessage(
            objectId: int.tryParse(item?.objectId ?? '') ?? 0,
            entranceId: int.tryParse(item?.objectId ?? '') ?? 0,
          ),
        );
        await onSearchTap(ref, context, object);
      },
      onBackTap: () {
        FocusScope.of(context).unfocus();
        context.router.back();
      },
      itemCount: searchResult.length,
      itemBuilder: (_, index) {
        final item = searchResult[index];

        return ContentRow(
          onTap: () async => onSearchTap(ref, context, item),
          options: ContentRowOptions(
            leadingIcon: General16Icons.pin.icon(
              color: context.color.textAndIconsStatusAccent,
            ),
            title: item.title,
            subtitle: item.makeAddress(),
            subtitleExtra: item.workStatus!.desc,
          ),
        );
      },
    );
  }

  Future<void> onSearchTap(WidgetRef ref, BuildContext context, DirectoryObjectMessage item) async {
    final favItem = item.mapToFavourite();
    final repo = ref.read(favouriteCacheProvider.notifier);
    await switch (markerType) {
      FavouriteItemMarkerType.unknown || FavouriteItemMarkerType.place => repo.addItem(favItem),
      FavouriteItemMarkerType.home => repo.setHome(favItem),
      FavouriteItemMarkerType.work => repo.setWork(favItem),
    };
    if (context.mounted && context.router.canPop()) {
      context.router.back();
    }
  }
}
