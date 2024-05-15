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

    return ListView.separated(
      shrinkWrap: true,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsetsDirectional.only(
        start: 16,
        bottom: 16,
      ),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => SuggestItem(
        suggest: suggests[index],
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
      separatorBuilder: (context, index) => const Padding(
        padding: EdgeInsetsDirectional.only(
          start: 52,
        ),
        child: Divider(),
      ),
    );
  }
}
