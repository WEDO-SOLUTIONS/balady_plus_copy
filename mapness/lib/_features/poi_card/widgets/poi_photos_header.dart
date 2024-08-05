import 'dart:math';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/poi_card/provider/poi_photo_provider.dart';
import 'package:mapness/_features/poi_card/widgets/poi_photos_row.dart';

const _minPhotosHeight = 100.0;
const _photosHeightDelta = 68.0;

class PoiPhotosHeader extends ConsumerWidget {
  const PoiPhotosHeader({
    required this.bottomSheetAspectRatio,
    required this.objectId,
    super.key,
  });

  final ValueListenable<double> bottomSheetAspectRatio;
  final int objectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photos = ref.watch(poiPhotoProvider(objectId));
    final mq = MediaQuery.of(context);
    final maxHeight = (mq.size.height - MediaQuery.paddingOf(context).vertical) * 0.2 - 20;
    final isPhotosNotEmpty = !photos.hasValue || photos.requireValue.items.isEmpty;
    return ValueListenableBuilder(
      valueListenable: bottomSheetAspectRatio,
      builder: (context, aspectRatio, child) {
        final height = _minPhotosHeight + (aspectRatio * _photosHeightDelta);
        return SizedBox(
          height: isPhotosNotEmpty ? 0.0 : min(height, maxHeight),
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: Spacing.$3x,
            ),
            child: PoiPhotosRow(
              objectId: objectId,
            ),
          ),
        );
      },
    );
  }
}
