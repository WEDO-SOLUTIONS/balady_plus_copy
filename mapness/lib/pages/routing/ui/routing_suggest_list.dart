import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/entities/routing/route_point.dart';
import 'package:mapness/features/search/ui/suggest_item.dart';

class RoutingSuggestList extends ConsumerWidget {
  const RoutingSuggestList({
    super.key,
    required this.suggest,
  });

  final SuggestResultMessage suggest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggests = suggest.suggests.whereType<SuggestMessage>().toList();

    return ListView.separated(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.only(
        right: 16,
        bottom: 16,
      ),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return SuggestItem(
          suggest: suggests[index],
          onObjectTap: (object) {
            context.pop(RoutePointDirectoryObject(object));
          },
        );
      },
      itemCount: suggests.length,
      separatorBuilder: (BuildContext context, int index) {
        return const Padding(
          padding: EdgeInsets.only(right: 36.0),
          child: Divider(),
        );
      },
    );
  }
}
