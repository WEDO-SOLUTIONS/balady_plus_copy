import 'dart:math';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/poi_card/domain/model/poi_bottom_sheet_config.dart';
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
    final maxHeight = (MediaQuery.sizeOf(context).height - MediaQuery.paddingOf(context).vertical) * 0.2 - 20;
    final isPhotosNotEmpty = !photos.hasValue || photos.requireValue.items.isEmpty;
    return ValueListenableBuilder(
      valueListenable: bottomSheetAspectRatio,
      builder: (context, aspectRatio, child) {
        final height = _minPhotosHeight + (aspectRatio * _photosHeightDelta);

        var opacity = 1.0;
        if (aspectRatio < PoiBottomSheetConfig.lowerAspectRatio) {
          opacity =
              (aspectRatio - PoiBottomSheetConfig.fadeAspectRatioDelta) / PoiBottomSheetConfig.fadeAspectRatioDelta -
                  PoiBottomSheetConfig.fadeAspectRatioDelta * 10;
        }

        final isInFadeDelta = aspectRatio > PoiBottomSheetConfig.middleAspectRatio &&
            aspectRatio <= PoiBottomSheetConfig.middleAspectRatio + PoiBottomSheetConfig.fadeAspectRatioDelta;
        if (isInFadeDelta) {
          opacity =
              (1 - aspectRatio - PoiBottomSheetConfig.fadeAspectRatioDelta) / PoiBottomSheetConfig.fadeAspectRatioDelta;
        }
        if (aspectRatio > PoiBottomSheetConfig.middleAspectRatio + PoiBottomSheetConfig.fadeAspectRatioDelta) {
          opacity = 0.0;
        }
        return Opacity(
          opacity: opacity.clamp(0, 1),
          child: SizedBox(
            height: isPhotosNotEmpty ? 0.0 : min(height, maxHeight),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: Spacing.$3x,
        ),
        child: PoiPhotosRow(
          objectId: objectId,
        ),
      ),
    );
  }
}
