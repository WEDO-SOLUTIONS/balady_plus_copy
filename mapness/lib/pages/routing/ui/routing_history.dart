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
import 'package:mapness/features/balady_analytics/metrics.dart';
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
    // Captured synchronously: the onTap flow awaits, and both host screens pop
    // this sheet in updatePoint — the error-sheet callbacks below then run with
    // this widget's element already defunct, so touching `context` there threw.
    // The router and the notifier objects outlive the widget.
    final router = AutoRouter.of(context);
    final tryAgainLabel = context.l10n.tryAgain;
    final historyNotifier = ref.read(searchHistoryProvider(SearchScopeEnum.routes.value).notifier);

    final history = ref.watch(searchHistoryProvider(SearchScopeEnum.routes.value))
      ..where((e) => e.id?.objectId != null);

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
        historyNotifier.clear();
      },
      onDelete: (item, index) {
        Metrics.logEventAdvanced(
          MetricsConstants.routesKeys.searchOnDelete,
          group: MetricsConstants.routesTag,
          action: MetricAction.tap.toString(),
          props: {'item': item.id?.objectId},
        );

        historyNotifier.delete(index);
      },
      onTap: (item, index, historyList) async {
        Metrics.logEventAdvanced(
          MetricsConstants.routesKeys.routeSelectionChangeNavType,
          group: MetricsConstants.routesTag,
          action: MetricAction.tap.toString(),
          props: {'item': item.id?.objectId},
        );
        final dgisController = await ref.read(dgisControllerProvider.future);
        try {
          final object = await dgisController.searchByObjectId(
            DgisObjectIdMessage(
              objectId: item.id?.objectId ?? 0,
              entranceId: item.id?.entranceId ?? 0,
            ),
          );

          final point = RoutePointDirectoryObject(object);
          updatePoint(point);
        } catch (e) {
          final result = await router.push(
            ErrorSheetDialogRoute(
              buttonLabel: tryAgainLabel,
              // maybePop: retry/close/barrier can each fire for one dismissal;
              // the second pop must not target an already-removed route.
              onRetry: () => router.maybePop(true),
              onClose: (_) => router.maybePop(true),
              onBarrierTap: () => router.maybePop(true),
            ),
          );
          await historyNotifier.delete(index);
          if (result != null && result as bool) {
            searchByQuery(item.title);
          }
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
