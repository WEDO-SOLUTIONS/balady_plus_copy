import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/entities/routing/route_point.dart';
import 'package:mapness/entry_point.dart';
import 'package:mapness/features/search/ui/suggest_item.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';

class RoutingSuggestList extends ConsumerWidget {
  const RoutingSuggestList({
    required this.suggest,
    super.key,
  });

  final SuggestResultMessage suggest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggests = suggest.suggests.whereType<SuggestMessage>().toList();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemBuilder: (context, index) => SuggestItem(
        suggest: suggests[index],
        isLast: index == suggests.length - 1,
        onObjectTap: (object) {
          if (!context.mounted) {
            mixpanel?.track('impossible-unounted-context');
            return;
          }

          Metrics.logEventAdvanced(MetricsConstants.routesKeys.searchSuggestion,
              group: MetricsConstants.routesTag,
              action: MetricAction.tap.toString(),
              props: {
                'item': object.id?.objectId,
              });

          context.pop(RoutePointDirectoryObject(object));
        },
      ),
      itemCount: suggests.length,
    );
  }
}
