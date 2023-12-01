import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/favourites/domain/favourite_item.dart';
import 'package:mapness/_features/favourites/providers/favourite_repository.dart';
import 'package:mapness/_features/favourites/widgets/screen/search_screen.dart';
import 'package:mapness/_features/happiness_map/domain/happiness_feedback.dart';
import 'package:mapness/shared/lib/make_address.dart';
import 'package:mapness/shared/providers/map/suggest.dart';

class FavouritesSearch extends ConsumerStatefulWidget {
  final FavouriteItemMarkerType markerType;
  const FavouritesSearch({required this.markerType, super.key});

  @override
  ConsumerState<FavouritesSearch> createState() => _FavouritesSearchState();
}

class _FavouritesSearchState extends ConsumerState<FavouritesSearch> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.watch(suggestQueryProvider.notifier).update("");
    });
  }

  @override
  void dispose() {
    ref.watch(suggestQueryProvider.notifier).update("");
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
      onBackTap: () {
        context.pop();
      },
      itemCount: searchResult.length,
      itemBuilder: (_, index) {
        final item = searchResult[index];

        return InkWell(
          onTap: () async {
            final favItem = FavouriteItem(
              coordinates: Coordinates(
                latitude: item.markerPosition?.latitude ?? 0,
                longitude: item.markerPosition?.longitude ?? 0,
              ),
              id: "${item.id!.objectId}", // -${item.id!.entranceId}",
              subtitle: item.subtitle,
              title: item.title,
              entity: FavouriteItemEntity(
                // id: item.id!.toString(),
                id: "${item.id!.objectId}", // -${item.id!.entranceId}",
                sourceType: EntitySourceType.urbi,
              ),
            );
            final repo = ref.read(favouriteRepositoryProvider.notifier);
            await switch (widget.markerType) {
              FavouriteItemMarkerType.unknown ||
              FavouriteItemMarkerType.place =>
                repo.addItem(favItem),
              FavouriteItemMarkerType.home => repo.setHome(favItem),
              FavouriteItemMarkerType.work => repo.setWork(favItem),
            };
            if (context.mounted && context.canPop()) {
              context.pop();
            }
          },
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          maxLines: 3,
                          style: Theme.of(context)
                              .extension<ThemeTextStyles>()!
                              .textS
                              .copyWith(color: const Color(0xFF1E2A36)),
                        ),
                        Text(
                          item.makeAddress(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .extension<ThemeTextStyles>()!
                              .textS
                              .copyWith(color: const Color(0xFF1E2A36)),
                        ),
                        if (item.workStatus != null)
                          Text(
                            item.workStatus!.desc,
                            style: Theme.of(context)
                                .extension<ThemeTextStyles>()!
                                .textS
                                .copyWith(
                                  color: item.workStatus!.isOpen
                                      ? const Color(0xFF4CA5B4)
                                      : const Color(0xFF1E2A36),
                                ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  // Text(
                  //   "0 ${context.l10n.km}",
                  //   style: Theme.of(context).extension<ThemeTextStyles>()!.textS,
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
