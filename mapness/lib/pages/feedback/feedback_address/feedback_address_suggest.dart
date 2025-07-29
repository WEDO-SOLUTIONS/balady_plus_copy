import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mapness/entities/routing/route_point.dart';
import 'package:mapness/features/search/ui/suggest_item.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/make_address.dart';
import 'package:mapness/shared/providers/location.dart';

class FeedbackAddressSuggestions extends ConsumerWidget {
  const FeedbackAddressSuggestions({
    required this.suggest,
    super.key,
  });

  final SuggestResultMessage suggest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggests = suggest.suggests.whereType<SuggestMessage>().toList();
    final myLocation = ref.watch(locationProvider);
    final contentColor = context.colors.backgroundSurface1;

    return SliverMainAxisGroup(slivers: [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.only(
            top: Spacing.$1_5x,
            left: Spacing.$4x,
            right: Spacing.$4x,
          ),
          child: Text(
            context.l10n.suggestedSearches,
            style: context.textStyles.captionLargeRegular
                .copyWith(color: context.colors.foregroundSoft),
          ),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.only(
          top: Spacing.$3x,
          left: Spacing.$4x,
          right: Spacing.$4x,
          bottom: Spacing.$4x,
        ),
        sliver: DecoratedSliver(
          decoration: BoxDecoration(
            color: contentColor,
            borderRadius:
                const BorderRadius.all(Radius.circular(RadiusBorder.xl)),
          ),
          sliver: SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: Spacing.$1x),
            sliver: SliverList.builder(
              itemBuilder: (context, index) => SuggestItem(
                index: index,
                suggest: suggests[index],
                myLocation: myLocation == null
                    ? null
                    : GeoPointMessage(
                        latitude: myLocation.latitude,
                        longitude: myLocation.longitude,
                      ),
                isLast: index == suggests.length - 1,
                onObjectTap: (object) {
                  if (!context.mounted) {
                    return;
                  }
                  final latitude = object.markerPosition?.latitude;
                  final longitude = object.markerPosition?.longitude;
                  if (latitude == null || longitude == null) {
                    return;
                  }
                  final address = object.makeFullAddress();
                  context.router.popForced(
                    RoutePointCoordinates(
                        GeoPointMessage(
                            latitude: latitude, longitude: longitude),
                        address,
                        null),
                  );
                },
              ),
              itemCount: suggests.length,
            ),
          ),
        ),
      ),
    ]);
  }
}
