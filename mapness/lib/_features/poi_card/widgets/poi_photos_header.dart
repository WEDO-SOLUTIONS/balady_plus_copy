import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/poi_card/provider/poi_photo_provider.dart';
import 'package:mapness/_features/poi_card/widgets/poi_photos_row.dart';

class PoiPhotosHeader extends ConsumerWidget {
  const PoiPhotosHeader({
    required this.bottomSheetState,
    required this.objectId,
    super.key,
  });

  final ValueListenable<BottomSheetState> bottomSheetState;
  final int objectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photos = ref.watch(poiPhotoProvider(objectId));

    final isPhotosNotEmpty = !photos.hasValue || photos.requireValue.items.isEmpty;
    return ValueListenableBuilder(
      valueListenable: bottomSheetState,
      builder: (context, state, child) => AnimatedCrossFade(
        crossFadeState:
            isPhotosNotEmpty || state == BottomSheetState.hidden ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        firstCurve: Curves.easeInOut,
        secondCurve: Curves.easeInOut,
        sizeCurve: Curves.easeInOut,
        firstChild: const SizedBox.shrink(),
        secondChild: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: isPhotosNotEmpty
              ? 0
              : switch (state) {
                  BottomSheetState.hidden => 0,
                  BottomSheetState.open => 150,
                  BottomSheetState.halfOpen || BottomSheetState.expanded => 100,
                },
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: Spacing.$3x,
            ),
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
