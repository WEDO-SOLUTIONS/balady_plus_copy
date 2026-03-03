import 'dart:io';
import 'dart:ui';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/parking_spot/parking_manage.dart';
import 'package:mapness/features/poi_card/enums/poi_card_bottom_sheet_state.dart';
import 'package:mapness/features/poi_card/provider/poi_photo_provider.dart';
import 'package:mapness/features/poi_card/widgets/photo_row/poi_photo_failure.dart';
import 'package:mapness/features/poi_card/widgets/photo_row/poi_photo_loading.dart';
import 'package:mapness/features/poi_card/widgets/photo_row/poi_photo_row_builder.dart';
import 'package:mapness/shared/providers/theme_controller.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/theme_controller.dart';
import 'package:provider/provider.dart';

class PoiPhotosRow extends ConsumerWidget {
  const PoiPhotosRow({required this.objectId, this.state, this.interpolation, super.key});

  final int objectId;
  final PoiCardBottomSheetState? state;
  final double? interpolation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parkingObject = objectId == parkingObjectId;
    final parkingPhotos = ref
        .read(parkingManageProvider(theme: context.read<ThemeController>().currentTheme))
        .value
        ?.imagesPaths;
    final photoFiles = parkingObject ? parkingPhotos?.map((e) => File(e)).toList() ?? [] : null;
    final photosState = ref.watch(poiPhotoProvider(objectId));

    final borderRadiusTop = _interpolation(
      state: state,
      interpolation: interpolation,
      initialValue: RadiusBorder.ml,
      finalValue: RadiusBorder.ml,
      expandedValue: 0,
    );
    final borderRadiusBottom = _interpolation(
      state: state,
      interpolation: interpolation,
      initialValue: RadiusBorder.ml,
      finalValue: 0,
    );
    final borderRadius = BorderRadius.only(
      topLeft: Radius.circular(borderRadiusTop),
      topRight: Radius.circular(borderRadiusTop),
      bottomLeft: Radius.circular(borderRadiusBottom),
      bottomRight: Radius.circular(borderRadiusBottom),
    );

    /// show shimmer while loading
    if (photosState.isLoading && !parkingObject) {
      return PoiPhotoRowLoading(borderRadius: borderRadius);
    }

    /// reload button on error
    if (photosState.hasError && !parkingObject) {
      return PoiPhotoRowFailure(objectId: objectId, borderRadius: borderRadius);
    }

    /// extract photo urls
    final photos = parkingObject ? parkingPhotos ?? [] : photosState.requireValue.items.map((e) => e.url).toList();
    final previewUrls = parkingObject
        ? parkingPhotos ?? []
        : photosState.requireValue.items.map((e) => e.previewUrls?.mediumByWidth ?? e.url).toList();

    final separatorWidth = _interpolation(
      state: state,
      interpolation: interpolation,
      initialValue: 6.0,
      finalValue: 0,
      curve: Curves.easeInExpo,
    );
    final padding = _interpolation(
      state: state,
      interpolation: interpolation,
      initialValue: Spacing.$3x,
      finalValue: 0,
    );
    return PoiPhotoRowBuilder(
      objectId: objectId,
      borderRadius: borderRadius,
      photosUrls: photos,
      previewUrls: previewUrls,
      photoFiles: photoFiles,
      padding: padding,
      separatorWidth: separatorWidth,
      state: state,
      interpolation: interpolation,
    );
  }

  double _interpolation({
    required double initialValue,
    required double finalValue,
    double? expandedValue,
    PoiCardBottomSheetState? state,
    double? interpolation,
    Curve? curve,
  }) {
    if (state == null || interpolation == null) {
      return initialValue;
    }

    if (state == PoiCardBottomSheetState.hidden) {
      return initialValue;
    }

    if (state == PoiCardBottomSheetState.open || state == PoiCardBottomSheetState.expanded) {
      return expandedValue ?? finalValue;
    }

    return (finalValue - initialValue) * (curve?.transform(interpolation) ?? interpolation) + initialValue;
  }
}

class POIPhotoItem extends StatelessWidget {
  const POIPhotoItem({required this.child, required this.isLast, super.key});

  final Widget child;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    if (!isLast) {
      return child;
    }
    return Stack(
      children: [
        child,
        Center(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              alignment: Alignment.center,
              color: Colors.white.withOpacity(0.2),
              child: Text(
                context.l10n.allPhotos,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  shadows: [Shadow(blurRadius: 4, color: Colors.black45, offset: Offset(1, 1))],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
