import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/landing/providers/interesting_places.dart';
import 'package:mapness/_generated/protocol/protocol.pb.dart' as proto;
import 'package:mapness/shared/extensions/build_context_ext.dart';

import 'places_horizontal_list.dart';

class InterestingPlacesCardsList extends ConsumerWidget {
  const InterestingPlacesCardsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final places = ref.watch(interestingPlacesProvider).where((e) {
      return e.tags.contains(
        proto.InterestingPlaceTag.INTERESTING_PLACE_CATEGORY_IMMERSIVE_MODEL,
      );
    }).toList();

    return PlacesHorizontalList(
      title: context.l10n.placesToVisit,
      places: places,
    );
  }
}
