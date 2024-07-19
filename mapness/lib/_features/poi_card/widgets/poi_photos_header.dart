import 'package:balady_uikit/balady_uikit.dart';
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

    final bool = !photos.hasValue || photos.requireValue.items.isEmpty;
    return ValueListenableBuilder(
      valueListenable: expansion,
      builder: (context, expansion, child) => AnimatedCrossFade(
          crossFadeState: bool || expansion == Expansion.hidden || expansion == Expansion.fullHidePhoto ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstCurve: Curves.easeInOut,
          secondCurve: Curves.easeInOut,
          sizeCurve: Curves.easeInOut,
          firstChild: const SizedBox.shrink(),
          secondChild: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: bool
                ? 0
                : switch (expansion) {
                    Expansion.fullHidePhoto => 0,
                    Expansion.hidden => 100,
                    Expansion.expanded => 150,
                    Expansion.collapsed || Expansion.middle => 100,
                  },
            child: Padding(
              padding: const EdgeInsets.only(bottom: Spacing.verticalPaddingInsideCell),
              child: PoiPhotosRow(
                objectId: objectId,
              ),
            ),
          ),
          duration: const Duration(milliseconds: 300),
        ),
    );
  }
}
