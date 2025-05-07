import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/favourites/favourite_item.dart';
import 'package:mapness/features/advert_metrics/advert_metrics.dart';
import 'package:mapness/features/favourites/mappers/directory_object_message_mapper.dart';
import 'package:mapness/features/favourites/providers/favourite_cache.dart';
import 'package:mapness/features/search/ui/search_scope.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/make_address.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/suggest.dart';
import 'package:mapness/widgets/favourites/screen/favourites_search_screen.dart';

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
            markerType: _getMarkerType(),
          ),
        ),
      );

  FavouriteItemMarkerType _getMarkerType() {
    try {
      return FavouriteItemMarkerType.values.byName(markerType.name);
    } catch (_) {
      return FavouriteItemMarkerType.place;
    }
  }
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

    return FavouritesSearchScreen(
      markerType: markerType,
      hintText: switch (markerType) {
        FavouriteItemMarkerType.unknown || FavouriteItemMarkerType.place => '',
        FavouriteItemMarkerType.home => context.l10n.home_address,
        FavouriteItemMarkerType.work => context.l10n.work_address,
      },
      onHistoryItemTap: (item) async {
        final dgisController = await ref.read(dgisControllerProvider.future);

        if (item?.objectId == null) {
          if (item?.title != null) {
            ref.read(suggestQueryProvider.notifier).update(item!.title);
          }
        } else {
          final object = await dgisController.searchByObjectId(
            DgisObjectIdMessage(
              objectId: int.tryParse(item?.objectId ?? '') ?? 0,
              entranceId: int.tryParse(item?.objectId ?? '') ?? 0,
            ),
          );
          unawaited(onSearchTap(ref, context, object));
        }
      },
      onTapOfSearch: () {
        ref.read(advertMetricsProvider.notifier).sendEvent(AdvertMetricsKeys.journeySearch);
      },
      onClose: () {
        FocusScope.of(context).unfocus();
        context.router.popForced();
      },
      onChanged: (value) {
        if (value.isEmpty) {
          ref.read(suggestQueryProvider.notifier).update('');
        } else {
          ref.read(suggestQueryProvider.notifier).update(value);
        }
      },
      itemCount: searchResult.length,
      itemBuilder: (_, index) {
        final item = searchResult[index];

        return ContentRowV2(
          isDividerEnabled: index != searchResult.length - 1,
          onTap: () async => onSearchTap(ref, context, item),
          leading: GeneralIcons.location.icon(
            color: context.colorsV2.accentActive,
          ),
          text: ContentRowTextOptions(
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
    unawaited(
      switch (markerType) {
        FavouriteItemMarkerType.unknown || FavouriteItemMarkerType.place => repo.addItem(favItem),
        FavouriteItemMarkerType.home => repo.setHome(favItem),
        FavouriteItemMarkerType.work => repo.setWork(favItem),
      },
    );
    if (context.mounted && context.router.canPop()) {
      context.router.popForced();
    }
  }
}
