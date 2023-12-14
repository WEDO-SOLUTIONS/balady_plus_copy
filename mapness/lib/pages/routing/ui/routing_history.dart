import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/routing/route_point.dart';
import 'package:mapness/features/search/providers/search_history.dart';
import 'package:mapness/pages/routing/ui/routing_history_empty.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/widgets/search/ui/search_history_collapsible.dart';

const _searchScope = 'RoutingSearch';

class RoutingHistory extends ConsumerWidget {
  const RoutingHistory({
    super.key,
    required this.updatePoint,
  });

  final void Function(RoutePoint point) updatePoint;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(searchHistoryProvider(_searchScope));

    return history.isEmpty
        ? const RoutingHistoryEmpty()
        : SearchHistoryCollapsible(
            history: history,
            onClear: () {
              ref.read(searchHistoryProvider(_searchScope).notifier).clear();
            },
            onTap: (item) {
              ref
                  .read(dgisControllerProvider)
                  .value
                  ?.searchByObjectId(
                    DgisObjectIdMessage(
                        objectId: item.objectId ?? 0,
                        entranceId: item.entranceId ?? 0),
                  )
                  .then(
                (object) {
                  final point = RoutePointDirectoryObject(object);
                  updatePoint(point);
                },
              );
            },
          );
  }
}
