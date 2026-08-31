import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/routing/route_point.dart';
import 'package:mapness/entry_point.dart';
import 'package:mapness/features/search/ui/suggest_item.dart';
import 'package:mapness/shared/providers/location.dart';

class RoutingSuggestList extends ConsumerWidget {
  const RoutingSuggestList({required this.suggest, super.key});

  final SuggestResultMessage suggest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggests = suggest.suggests.whereType<SuggestMessage>().toList();
    final myLocation = ref.watch(locationProvider);
    final contentColor = context.colors.backgroundSurface4;

    return Padding(
      padding: const EdgeInsets.only(left: Spacing.$4x, right: Spacing.$4x, bottom: Spacing.$4x),
      child: Material(
        clipBehavior: Clip.antiAlias,
        borderRadius: const BorderRadius.all(Radius.circular(RadiusBorder.xl)),
        color: contentColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Spacing.$1x),
          child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            itemBuilder: (context, index) => SuggestItem(
              index: index,
              suggest: suggests[index],
              myLocation: myLocation == null
                  ? null
                  : GeoPointMessage(latitude: myLocation.latitude, longitude: myLocation.longitude),
              isLast: index == suggests.length - 1,
              onObjectTap: (object) {
                if (!context.mounted) {
                  mixpanel?.track('impossible-unounted-context');
                  return;
                }

                context.router.pop(RoutePointDirectoryObject(object));
              },
            ),
            itemCount: suggests.length,
          ),
        ),
      ),
    );
  }
}
