import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/favourites/domain/extensions/extensions.dart';
import 'package:mapness/_features/favourites/domain/favourite_item.dart';
import 'package:mapness/_features/favourites/providers/favourite_cache.dart';
import 'package:mapness/_features/favourites/widgets/screen/search_screen.dart';
import 'package:mapness/shared/lib/make_address.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/suggest.dart';

class FavouritesSearch extends ConsumerStatefulWidget {
  const FavouritesSearch({required this.markerType, super.key});

  final FavouriteItemMarkerType markerType;

  @override
  ConsumerState<FavouritesSearch> createState() => _FavouritesSearchState();
}

class _FavouritesSearchState extends ConsumerState<FavouritesSearch> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(suggestQueryProvider.notifier).update('');
    });
  }

  @override
  void dispose() {
    ref.read(suggestQueryProvider.notifier).update('');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchResult = (ref.watch(suggestResultsProvider).value ?? [])
        .map((element) => element.handler.objectHandler)
        .whereType<SuggestObjectHandlerMessage>()
        .map((e) => e.item)
        .toList();

    return SearchScreen(
      hintText: widget.markerType.getHintText(context),
      onHistoryItemTap: (item) async {
        final dgisController = await ref.read(dgisControllerProvider.future);

        final object = await dgisController.searchByObjectId(
          DgisObjectIdMessage(
            objectId: int.tryParse(item?.objectId ?? '') ?? 0,
            entranceId: int.tryParse(item?.objectId ?? '') ?? 0,
          ),
        );
        await onSearchTap(context, object);
      },
      onBackTap: () {
        context.pop();
      },
      itemCount: searchResult.length,
      itemBuilder: (_, index) {
        final item = searchResult[index];

        return ContentRow(
          onTap: () async => onSearchTap(context, item),
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

  Future<void> onSearchTap(
    BuildContext context,
    DirectoryObjectMessage item,
  ) async {
    final favItem = item.mapToFavourite();
    final repo = ref.read(favouriteCacheProvider.notifier);
    await switch (widget.markerType) {
      FavouriteItemMarkerType.unknown || FavouriteItemMarkerType.place => repo.addItem(favItem),
      FavouriteItemMarkerType.home => repo.setHome(favItem),
      FavouriteItemMarkerType.work => repo.setWork(favItem),
    };
    if (context.mounted && context.canPop()) {
      context.pop();
    }
  }
}
