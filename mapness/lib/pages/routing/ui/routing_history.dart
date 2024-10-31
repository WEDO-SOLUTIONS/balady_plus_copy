import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/routing/route_point.dart';
import 'package:mapness/features/search/providers/search_history.dart';
import 'package:mapness/features/search/ui/search_scope.dart';
import 'package:mapness/pages/routing/ui/routing_history_empty.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/ui/sheets/error_sheet.dart';
import 'package:mapness/widgets/search/ui/search_history_collapsible.dart';

class RoutingHistory extends ConsumerWidget {
  const RoutingHistory({
    required this.updatePoint,
    required this.searchByQuery,
    super.key,
  });

  final void Function(RoutePoint point) updatePoint;
  final void Function(String query) searchByQuery;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(searchHistoryProvider(SearchScopeEnum.routes.value))
      ..retainWhere((e) => e.objectId != null);

    return history.isEmpty
        ? const RoutingHistoryEmpty()
        : SearchHistoryCollapsible(
            history: history,
            onClear: () {
              Metrics.logEventAdvanced(
                MetricsConstants.routesKeys.searchClearButton,
                group: MetricsConstants.routesTag,
                action: MetricAction.tap.toString(),
              );
              ref.read(searchHistoryProvider(SearchScopeEnum.routes.value).notifier).clear();
            },
            onDelete: (item) {
              Metrics.logEventAdvanced(
                MetricsConstants.routesKeys.searchOnDelete,
                group: MetricsConstants.routesTag,
                action: MetricAction.tap.toString(),
                props: {
                  'item': item.objectId,
                },
              );

              ref.read(searchHistoryProvider(SearchScopeEnum.routes.value).notifier).delete(item);
            },
            onTap: (item) async {
              Metrics.logEventAdvanced(
                MetricsConstants.routesKeys.routeSelectionChangeNavType,
                group: MetricsConstants.routesTag,
                action: MetricAction.tap.toString(),
                props: {
                  'item': item.objectId,
                },
              );
              final dgisController = await ref.read(dgisControllerProvider.future);
              try {
                final object = await dgisController.searchByObjectId(
                  DgisObjectIdMessage(
                    objectId: int.tryParse(item.objectId ?? '') ?? 0,
                    entranceId: int.tryParse(item.entranceId ?? '') ?? 0,
                  ),
                );

                final point = RoutePointDirectoryObject(object);
                updatePoint(point);
              } catch (e) {
                final result = await showDialog(
                  barrierColor: Colors.transparent,
                  useSafeArea: false,
                  context: context,
                  builder: (contextDialog) => ProviderScope(
                    parent: ProviderScope.containerOf(context),
                    child: Theme(
                      data: Theme.of(context),
                      child: MediaQuery(
                        data: MediaQuery.of(context),
                        child: Directionality(
                          textDirection: Directionality.of(context),
                          child: Localizations.override(
                            context: context,
                            child: ColoredBox(
                              color: Colors.black45,
                              child: Column(
                                children: [
                                  const Spacer(),
                                  ErrorSheet(
                                    buttonLabel: context.l10n.tryAgain,
                                    errorLabel: context.l10n.placeWasNotFound,
                                    onRetry: () => Navigator.of(contextDialog).pop(true),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
                await ref.read(searchHistoryProvider(SearchScopeEnum.routes.value).notifier).delete(item);
                if (result as bool) {
                  searchByQuery(item.title);
                }
              }
            },
          );
  }
}
