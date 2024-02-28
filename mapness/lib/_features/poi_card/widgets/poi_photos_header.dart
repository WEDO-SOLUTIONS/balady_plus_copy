import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/poi_card/provider/poi_photo_provider.dart';
import 'package:mapness/_features/poi_card/widgets/poi_photos_row.dart';
import 'package:mapness/shared/ui/bottom_sheet/dgis_bottom_sheet.dart';

class PoiPhotosHeader extends ConsumerWidget {
  const PoiPhotosHeader({
    required this.expansion,
    required this.objectId,
    super.key,
  });
  final ValueListenable<Expansion> expansion;
  final int objectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photos = ref.watch(poiPhotoProvider(objectId));

    /// two crossfades since we have 4 states. And it looks more smooth than animated container imo
    return ValueListenableBuilder(
      valueListenable: expansion,
      builder: (context, expansion, child) => AnimatedCrossFade(
        firstCurve: Curves.easeInOut,
        secondCurve: Curves.easeInOut,
        sizeCurve: Curves.easeInOut,
        duration: const Duration(milliseconds: 300),
        firstChild: const SizedBox.shrink(),
        secondChild: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: AnimatedCrossFade(
            firstCurve: Curves.easeInOut,
            secondCurve: Curves.easeInOut,
            sizeCurve: Curves.easeInOut,
            duration: const Duration(milliseconds: 300),
            crossFadeState: expansion == Expansion.middle
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: SizedBox(height: 150, child: child),
            secondChild: SizedBox(height: 100, child: child),
          ),
        ),
        crossFadeState: !photos.hasValue ||
                photos.requireValue.items.isEmpty ||
                expansion == Expansion.hidden ||
                expansion == Expansion.expanded
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
      ),
      child: PoiPhotosRow(
        objectId: objectId,
      ),
    );
  }
}
