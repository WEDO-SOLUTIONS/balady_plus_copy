import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/routing/route_point.dart';
import 'package:mapness/features/search/providers/search_history.dart';
import 'package:mapness/features/search/ui/search_scope.dart';
import 'package:mapness/pages/routing/ui/routing_history_empty.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/analytic/bss_service.dart';
import 'package:mapness/shared/providers/analytic/models/bss_request.dart';
import 'package:mapness/shared/providers/analytic/models/extensions/search_type_ext.dart';
import 'package:mapness/shared/providers/analytic/models/payload/bss_payload.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/widgets/search/ui/search_history_collapsible.dart';

class RoutingHistory extends ConsumerWidget {
  const RoutingHistory({required this.updatePoint, required this.searchByQuery, super.key});

  final void Function(RoutePoint point) updatePoint;
  final void Function(String query) searchByQuery;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(searchHistoryProvider(SearchScopeEnum.routes.value));

    if (history.isEmpty) {
      return const RoutingHistoryEmpty();
    }

    return SearchHistoryCollapsible(
      history: history,
      iconColor: context.colors.foregroundSoft,
      onClear: () {
        Metrics.logEventAdvanced(
          MetricsConstants.routesKeys.searchClearButton,
          group: MetricsConstants.routesTag,
          action: MetricAction.tap.toString(),
        );
        ref.read(searchHistoryProvider(SearchScopeEnum.routes.value).notifier).clear();
      },
      onDelete: (item, index) {
        Metrics.logEventAdvanced(
          MetricsConstants.routesKeys.searchOnDelete,
          group: MetricsConstants.routesTag,
          action: MetricAction.tap.toString(),
          props: {'item': item.id?.objectId},
        );

        ref.read(searchHistoryProvider(SearchScopeEnum.routes.value).notifier).delete(index);
      },
      onTap: (item, index, historyList) async {
        Metrics.logEventAdvanced(
          MetricsConstants.routesKeys.routeSelectionChangeNavType,
          group: MetricsConstants.routesTag,
          action: MetricAction.tap.toString(),
          props: {'item': item.id?.objectId},
        );
        // BALADY-3618: the routes history holds two kinds of entries — directory
        // objects (`SearchHistoryItem.fromDirectoryObject`, `id` set) and plain
        // text queries (`SearchHistoryItem.fromQuery`, `id` null), written by the
        // routing search bar and by "perform search" suggests. A text entry has
        // no object to resolve, so it goes straight to a text search: routing it
        // through `searchByObjectId` requested objectId 0 and always failed,
        // showing the error sheet instead of the results.
        final objectId = item.id?.objectId;
        if (objectId == null) {
          searchByQuery(item.title);
        } else {
          await _openDirectoryObject(context, ref, item, index, objectId);
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

  /// Resolve a history entry that points at a concrete directory object and
  /// hand it back as the route point. When the id no longer resolves the entry
  /// is dropped from the history and the user is offered a text search for the
  /// same title instead.
  Future<void> _openDirectoryObject(
    BuildContext context,
    WidgetRef ref,
    SearchHistoryDirectoryObjectMessage item,
    int index,
    int objectId,
  ) async {
    final dgisController = await ref.read(dgisControllerProvider.future);
    try {
      final object = await dgisController.searchByObjectId(
        DgisObjectIdMessage(
          objectId: objectId,
          entranceId: item.id?.entranceId ?? 0,
        ),
      );

      final point = RoutePointDirectoryObject(object);
      updatePoint(point);
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
      await ref.read(searchHistoryProvider(SearchScopeEnum.routes.value).notifier).delete(index);
      if (result != null && result as bool) {
        searchByQuery(item.title);
      }
    }
  }
}
