import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/favorite_lists/data/favorite_lists_api_exception.dart';
import 'package:mapness/features/favorite_lists/data/models/favorite_list_dto.dart';
import 'package:mapness/features/favorite_lists/providers/favorite_list_detail.dart';
import 'package:mapness/features/favorite_lists/ui/widgets/favorite_list_places_tile.dart';
import 'package:mapness/features/favorite_lists/ui/widgets/favorite_progress_indicator.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/hooks/multi_state_sheet_controller_hook.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:sheetify/sheetify.dart';

@RoutePage()
class FavoriteListDetailsPage extends HookConsumerWidget {
  final FavoriteListDto list;

  const FavoriteListDetailsPage({required this.list, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sheetController = useMultiStateSheetController<ThreeStateSheet>(
      behavior: FractionSnappingBehavior(fractions: {0.0, 0.5, 1.0}),
      mapper: const ThreeStateMapper(),
      initialState: ThreeStateSheet.open,
    );
    final listDetailAsync = ref.watch(favoriteListDetailProvider(listId: list.id));
    final currentList = listDetailAsync.value?.list ?? list;

    return MultiStateSheet(
      scrollController: sheetController,
      backgroundColor: context.colors.backgroundSurface4,
      safeAreaColor: context.colors.backgroundSurface4,
      dragger: SheetDragger(
        draggerColor: context.colors.backgroundSurface5,
        backgroundColor: context.colors.backgroundSurface1,
      ),
      outside: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => context.router.pop(),
        child: const SizedBox.expand(),
      ),
      header: Container(
        padding: const EdgeInsets.fromLTRB(Spacing.$4x, Spacing.$1_5x, Spacing.$4x, Spacing.$3x),
        color: context.colors.backgroundSurface1,
        child: Row(
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              icon: Icon(SystemIcons.ellipsis, size: 24, color: context.colors.foregroundSoft),
              onPressed: () async {
                final shouldClose = await context.router.push(FavoriteListMenuRoute(listId: list.id));
                if (shouldClose == true) {
                  context.router.pop(true);
                }
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.$2x),
                child: Column(
                  children: [
                    Text(
                      currentList.name,
                      style: context.textStyles.h4SemiBold.copyWith(color: context.colors.foregroundDefault),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: Spacing.$1x),
                      child: Text(
                        _placesCountLabel(context, currentList),
                        style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(onPressed: context.router.pop, icon: const Icon(SystemIcons.close)),
          ],
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: Spacing.$3x, horizontal: Spacing.$4x),
      content: [
        _FavoriteListPlacesContent(listId: list.id),
      ],
    );
  }
}

String _placesCountLabel(BuildContext context, FavoriteListDto list) {
  final languageCode = Localizations.localeOf(context).languageCode;
  final placeCount = list.placeCount ?? 0;
  // TODO(claude): localize string and handle Arabic plural forms properly
  return [
    '$placeCount place${placeCount == 1 ? '' : 's'}',
    // TODO(claude): localize string
    'Created ${DateFormat('dd.MM', languageCode).format(list.createdAt)}',
    // TODO(claude): localize string
    'Modified ${DateFormat('dd.MM', languageCode).format(list.updatedAt)}',
  ].join(' • ');
}

class _FavoriteListPlacesContent extends ConsumerWidget {
  const _FavoriteListPlacesContent({required this.listId, super.key});

  final String listId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listDetailAsync = ref.watch(favoriteListDetailProvider(listId: listId));

    return Padding(
      padding: const EdgeInsets.only(top: Spacing.$2x),
      child: listDetailAsync.when(
        data: (listDetail) {
          final places = listDetail.list.places ?? [];
          if (places.isEmpty) {
            // TODO(claude): localize string
            return Text(
              'No places in this list yet',
              style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: Spacing.$3x,
            children: places
                .map<Widget>(
                  (place) => Container(
                    padding: const EdgeInsets.all(Spacing.$3x),
                    decoration: BoxDecoration(
                      color: context.colors.backgroundSurface1,
                      borderRadius: BorderRadius.circular(Spacing.$2x),
                    ),
                    child: FavoriteListPlaceTile(list: listDetail.list, place: place),
                  ),
                )
                .toList(),
          );
        },
        loading: () => const FavoriteProgressIndicator(),
        error: (error, stackTrace) => Text(
          error is FavoriteListsApiException
              ? error.localizedMessage(ref.read(appLanguageProvider))
              : context.l10n.somethingWentWrongPleaseTryAgainLater,
          style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft),
        ),
      ),
    );
  }
}
