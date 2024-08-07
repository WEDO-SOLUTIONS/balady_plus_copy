import 'dart:math';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/poi_card/provider/poi_photo_provider.dart';
import 'package:mapness/_features/poi_card/widgets/poi_photos_row.dart';

const _minPhotosHeight = 100.0;
const _photosHeightDelta = 68.0;

class PoiPhotosHeader extends ConsumerWidget {
  const PoiPhotosHeader({
    required this.objectId,
    super.key,
  });

  final int objectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photos = ref.watch(poiPhotoProvider(objectId));
    final isPhotosNotEmpty = !photos.hasValue || photos.requireValue.items.isEmpty;

    return _HeaderComponent(
      isPhotosNotEmpty: isPhotosNotEmpty,
      objectId: objectId,
    );
  }
}

class _HeaderComponent extends BottomSheetComponentWidget<BottomSheetState> {
  final bool isPhotosNotEmpty;
  final int objectId;

  const _HeaderComponent({
    required this.isPhotosNotEmpty,
    required this.objectId,
  }) : super(
          defaultState: BottomSheetState.halfOpen,
        );

  @override
  Widget build(BuildContext context, BottomSheetState state, double interpolation) {
    final maxHeight = (MediaQuery.sizeOf(context).height - MediaQuery.paddingOf(context).vertical) * 0.2 - 20;
    final opacity = switch (state) {
      BottomSheetState.hidden => interpolation * 2 - 1,
      BottomSheetState.halfOpen => 1.0,
      BottomSheetState.open => 1 - interpolation * 2,
      BottomSheetState.expanded => 0.0,
    };
    final height = switch (state) {
      BottomSheetState.hidden => _minPhotosHeight,
      BottomSheetState.halfOpen => _minPhotosHeight + (interpolation * _photosHeightDelta),
      BottomSheetState.open => _minPhotosHeight + _photosHeightDelta,
      BottomSheetState.expanded => 0.0,
    };

    return Opacity(
      opacity: opacity.clamp(0, 1),
      child: SizedBox(
        height: isPhotosNotEmpty ? 0.0 : min(height, maxHeight),
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: Spacing.$3x,
          ),
          child: PoiPhotosRow(
            objectId: objectId,
          ),
        ),
      ),
    );
  }
}
