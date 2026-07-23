import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/app/auto_route/poi_card_ext.dart';
import 'package:mapness/features/app_analytics/app_analytics.dart';
import 'package:mapness/features/app_analytics/models/datafinder_models.dart';
import 'package:mapness/features/balady_analytics/events/search_events.dart';
import 'package:mapness/features/poi_card/domain/model/poi_camera_config.dart';
import 'package:mapness/features/search/models/search_scope.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/providers/search_history.dart';
import 'package:mapness/features/search/ui/search_history.dart' as ui;
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/analytic/bss_service.dart';
import 'package:mapness/shared/providers/analytic/models/bss_request.dart';
import 'package:mapness/shared/providers/analytic/models/extensions/search_type_ext.dart';
import 'package:mapness/shared/providers/analytic/models/payload/bss_payload.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:provider/provider.dart';

class MapSearchHistory extends ConsumerWidget {
  const MapSearchHistory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scope = context.read<SearchScope>();

    return ui.SearchHistory(
      iconColor: context.colors.foregroundMuted,
      onTap: (item, index, historyList) async {
        // Balady analytics: a tapped history record is a selected result.
        trackSearchResultSelected(query: item.title, rank: index + 1, resultType: SearchResultType.history);
        // DataFinder: tapping a past search counts as `History` input, and the
        // resulting search_results_exposure must report search_type: History.
        ref
            .read(appAnalyticsProvider)
            .searchBoxInput(
              operationType: DataFinderInputOperation.history,
              inputText: item.title,
            );
        ref.read(searchProvider(scope.value).notifier).markSearchFromHistory();
        if (item.id?.objectId != null) {
          final dgisController = await ref.read(dgisControllerProvider.future);
          try {
            // todo remove as it is no-op
            await dgisController.searchByObjectId(
              DgisObjectIdMessage(
                objectId: item.id?.objectId ?? 0,
                entranceId: item.id?.entranceId ?? 0,
              ),
            );

            // todo rewrite
            if (item.id?.objectId == null) {
              return;
            }

            await context.router.replaceOrPush(
              route: PoiCardWidgetRoute(
                objectId: DgisObjectIdMessage(
                  objectId: item.id!.objectId,
                  // todo pass entranceId
                  entranceId: 0,
                ),
                cameraConfig: const PoiCameraConfig(zoom: 18),
              ),
              toCompareRoutes: [PoiCardWidgetRoute.page],
            );
          } catch (e) {
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
      },
    );
  }
}
