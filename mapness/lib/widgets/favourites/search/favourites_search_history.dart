import 'package:auto_route/auto_route.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/favourites/favourite_item.dart';
import 'package:mapness/features/favourites/mappers/directory_object_message_mapper.dart';
import 'package:mapness/features/favourites/providers/favourite_cache.dart';
import 'package:mapness/features/search/models/search_scope.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/providers/search_history.dart';
import 'package:mapness/features/search/ui/search_history.dart' as ui;
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/features/balady_analytics/metrics.dart';
import 'package:mapness/shared/providers/analytic/bss_service.dart';
import 'package:mapness/shared/providers/analytic/models/bss_request.dart';
import 'package:mapness/shared/providers/analytic/models/extensions/search_type_ext.dart';
import 'package:mapness/shared/providers/analytic/models/payload/bss_payload.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:provider/provider.dart';

class FavouritesSearchHistory extends ConsumerWidget {
  const FavouritesSearchHistory({
    required this.markerType,
    super.key,
  });

  final FavouriteItemMarkerType markerType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scope = context.read<SearchScope>();

    Future<void> sendHistoryTapEvent(
      SearchHistoryDirectoryObjectMessage item,
      int index,
      BssHistoryList? historyList,
    ) async {
      final bssHistoryHandlingType = item.id?.objectId != null
          ? BssHistoryHandlingType.openRecord
          : BssHistoryHandlingType.searchSuggestedText;
      await BssService.instance.sendEvent(
        BssRequest(
          eventType: BSSEventType.action,
          actionType: BSSActionType.tap,
          uiElement: BssUIElement(
            name: BssUIElementNames.historyItem,
            ownerName: BssUIElementNames.historyList,
            position: index + 1,
          ),
          payload: BssPayload(
            searchRequest: BssSearchRequest(text: item.title),
            historyItem: item.toBss(bssHistoryHandlingType),
            historyList: historyList,
          ),
        ),
      );
    }

    return ui.SearchHistory(
      onTap: (item, index, historyList) async {
        FocusManager.instance.primaryFocus?.unfocus();

        if (item.id?.objectId != null) {
          final dgisController = await ref.read(dgisControllerProvider.future);
          try {
            final object = await dgisController.searchByObjectId(
              DgisObjectIdMessage(
                objectId: item.id?.objectId ?? 0,
                entranceId: item.id?.entranceId ?? 0,
              ),
            );

            Metrics.logEventAdvanced(
              MetricsConstants.searchKeys.suggestion,
              group: MetricsConstants.searchTag,
              action: MetricAction.tap.toString(),
              props: {'object': item.id?.objectId},
            );

            final favItem = object.mapToFavourite();
            final repo = ref.read(favouriteCacheProvider.notifier);
            await switch (markerType) {
              FavouriteItemMarkerType.unknown || FavouriteItemMarkerType.place => repo.addItem(favItem),
              FavouriteItemMarkerType.home => repo.setHome(favItem),
              FavouriteItemMarkerType.work => repo.setWork(favItem),
            };
            await sendHistoryTapEvent(item, index, historyList);
            if (context.mounted && context.router.canPop()) {
              context.router.pop(favItem);
            }
            return;
          } catch (e) {
            if (!context.mounted) {
              return;
            }
            final result = await context.router.push(
              ErrorSheetDialogRoute(
                buttonLabel: context.l10n.tryAgain,
                onRetry: () => context.router.pop(true),
                onClose: (_) => context.router.pop(true),
                onBarrierTap: () => context.router.pop(true),
              ),
            );
            await ref.read(searchHistoryProvider(scope.value).notifier).delete(index);

            if (result != null && result as bool) {
              await ref.read(searchProvider(scope.value).notifier).searchByText(item.title);
            }
          }
        } else {
          await ref.read(searchProvider(scope.value).notifier).searchByText(item.title);
        }
        await sendHistoryTapEvent(item, index, historyList);
      },
    );
  }
}
